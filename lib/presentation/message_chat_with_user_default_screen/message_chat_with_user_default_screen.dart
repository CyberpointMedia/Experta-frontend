import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_one.dart';
import 'package:experta/widgets/app_bar/appbar_title_image.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_button_one.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_image.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shimmer/shimmer.dart';
import 'models/database_helper/database_helper.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final TextEditingController controller = TextEditingController();
  final Map<String, dynamic> arguments = Get.arguments;
  late final Map<String, dynamic> chat;
  late final IO.Socket socket;
  late final ApiService apiServices;
  final List<Map<String, dynamic>> messages = [];
  final List<Map<String, dynamic>> unsentMessages = [];
  final String? currentUserId = PrefUtils().getaddress();
  final Set<String> onlineUsers = {};
  final Set<String> typingUsers = {};
  bool isConnected = true;
  late final StreamSubscription<ConnectivityResult> connectivitySubscription;
  final Map<String, bool> messageStatus = {}; // Track message status

  @override
  void initState() {
    super.initState();
    chat = arguments['chat'];
    socket = IO.io('http://3.110.252.174:8080', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    apiServices = ApiService();
    fetchMessages();
    initializeSocket();
    monitorConnectivity();

    controller.addListener(() {
      if (controller.text.isNotEmpty) {
        onTyping();
      } else {
        onStopTyping();
      }
    });
  }

  void monitorConnectivity() {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (mounted) {
        setState(() {
          isConnected = result != ConnectivityResult.none;
        });
        if (isConnected) {
          fetchMessages(); // Fetch messages when connection is restored
          resendUnsentMessages();
        }
      }
    });
  }

  void initializeSocket() {
    log('Initializing socket...');
    socket.connect();
    log("Socket connected");

    socket.emit("init_user", currentUserId);

    socket.on('connect', (_) {
      log('Connected to socket server');
      socket.emit('join', {'chatId': chat['_id'], 'userId': currentUserId});
      fetchMessages();
      resendUnsentMessages();
    });

    socket.on(
        'connect_error', (error) => log('Socket connection error: $error'));
    socket.on('disconnect', (_) => reconnectSocket());
    socket.on('reconnect_attempt',
        (_) => log('Attempting to reconnect to socket server...'));
    socket.on(
        'reconnect_failed', (_) => log('Failed to reconnect to socket server'));
    socket.on('reconnect', (_) => resendUnsentMessages());

    socket.on('messages', (data) {
      log('Messages received: $data');
      if (mounted) {
        setState(() {
          messages.clear();
          messages.addAll(List<Map<String, dynamic>>.from(data));
        });
      }
    });

    socket.on('new_msg_received', (data) async {
      log('New message received: $data');
      if (mounted) {
        setState(() {
          messages.insert(0, Map<String, dynamic>.from(data));
        });
      }
      _markMessageAsReadIfNecessary(data);
    });

    socket.on('update_unread_count',
        (data) => updateUnreadCount(data['chatId'], data['unreadCount']));
    socket.on('messages_marked_read', (data) {
      if (data['userId'] != currentUserId) {
        updateMessageReadStatus(data['chatId']);
      }
    });

    socket.on('getUserOnline', (userId) {
      if (mounted) {
        setState(() {
          onlineUsers.add(userId);
        });
      }
    });

    socket.on('getUserOffline', (userId) {
      if (mounted) {
        setState(() {
          onlineUsers.remove(userId);
        });
      }
    });

    socket.on('user_typing', (data) {
      if (mounted) {
        setState(() {
          typingUsers.add(data['userId']);
        });
      }
    });

    socket.on('user_stopped_typing', (data) {
      if (mounted) {
        setState(() {
          typingUsers.remove(data['userId']);
        });
      }
    });
  }

  void _markMessageAsReadIfNecessary(Map<String, dynamic> message) {
    if (message['sender']['_id'] != currentUserId) {
      markMessagesAsRead([message['_id']]);
    }
  }

  void reconnectSocket() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!socket.connected) {
        log('Attempting to reconnect to socket server...');
        socket.connect();
      }
    });
  }

  Future<void> fetchMessages() async {
    try {
      final fetchedMessages = await apiServices.fetchMessages("${chat['_id']}");
      log("API response is $fetchedMessages");
      if (mounted) {
        setState(() {
          messages.clear();
          messages.addAll(fetchedMessages);
        });
      }
      for (var message in fetchedMessages) {
        await DatabaseHelper().insertMessage(message);
      }
    } catch (error) {
      log('Error fetching messages: $error');
      final localMessages =
          await DatabaseHelper().fetchMessages("${chat['_id']}");
      if (mounted) {
        setState(() {
          messages.clear();
          messages.addAll(localMessages);
        });
      }
    }
  }

  Future<void> markMessagesAsRead(List<String> messageIds) async {
    try {
      for (String messageId in messageIds) {
        await apiServices.markMessagesAsRead(messageId);
        socket.emit('mark_messages_read',
            {'chatId': messageId, 'userId': currentUserId});
        await DatabaseHelper()
            .updateMessageReadStatus(messageId, currentUserId!);
      }
    } catch (error) {
      log('Error marking messages as read: $error');
    }
  }

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty) return;
    final content = controller.text.trim();
    final newMsg = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
      'content': content,
      'createdAt': DateTime.now().toUtc().toString(),
      'sender': {'_id': currentUserId},
      'readBy': [],
      'status': 'pending'
    };

    if (mounted) {
      setState(() {
        messages.insert(0, newMsg);
        controller.clear();
      });
    }

    if (isConnected) {
      try {
        final sentMsg =
            await apiServices.sendMessage(content, "${chat['_id']}");
        sentMsg['status'] = 'sent';
        if (mounted) {
          setState(() {
            int index = messages.indexWhere((msg) => msg['id'] == newMsg['id']);
            if (index != -1) {
              messages[index] = sentMsg;
            } else {
              messages.insert(0, sentMsg);
            }
          });
        }
        socket.emit('new_msg_sent', sentMsg);
        await DatabaseHelper().insertMessage(sentMsg);
      } catch (error) {
        log('Error sending message: $error');
        unsentMessages.add(newMsg);
        await DatabaseHelper().insertMessage(newMsg);
      }
    } else {
      unsentMessages.add(newMsg);
      await DatabaseHelper().insertMessage(newMsg);
    }
  }

  Future<void> resendUnsentMessages() async {
    if (unsentMessages.isEmpty) return;

    final successfullySentMessages = <Map<String, dynamic>>[];

    for (var unsentMsg in unsentMessages) {
      try {
        final sentMsg = await apiServices.sendMessage(
            unsentMsg['content'], "${chat['_id']}");
        sentMsg['status'] = 'sent';
        if (mounted) {
          setState(() {
            int index =
                messages.indexWhere((msg) => msg['id'] == unsentMsg['id']);
            if (index != -1) {
              messages[index] = sentMsg;
            } else {
              messages.insert(0, sentMsg);
            }
          });
        }
        socket.emit('new_msg_sent', sentMsg);
        await DatabaseHelper().insertMessage(sentMsg);
        successfullySentMessages.add(unsentMsg);
      } catch (error) {
        log('Error resending message: $error');
      }
    }

    unsentMessages.removeWhere((msg) =>
        successfullySentMessages.any((sentMsg) => sentMsg['id'] == msg['id']));

    log('Current messages: $messages');
    log('Unsent messages: $unsentMessages');

    if (mounted) {
      setState(() {});
    }
  }

  void updateUnreadCount(String chatId, int count) {
    // Implement the logic to update the unread count for the chat
  }

  void updateMessageReadStatus(String chatId) {
    if (mounted) {
      setState(() {
        messages.forEach((msg) {
          if (msg['chat'] == chatId && !msg['readBy'].contains(currentUserId)) {
            msg['readBy'].add(currentUserId);
          }
        });
      });
    }
  }

  String convertToIST(String utcTime) {
    final utcDateTime = DateTime.parse(utcTime).toUtc();
    final istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));
    return DateFormat('d MMMM yyyy').format(istDateTime);
  }

  String convertToISTs(String utcTime) {
    final utcDateTime = DateTime.parse(utcTime).toUtc();
    final istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));
    return DateFormat('hh:mm a').format(istDateTime);
  }

  void onTyping() {
    socket.emit('typing', {'chatId': chat['_id'], 'userId': currentUserId});
  }

  void onStopTyping() {
    socket
        .emit('stop_typing', {'chatId': chat['_id'], 'userId': currentUserId});
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otherUser = chat['users']
        ?.firstWhere((u) => u['_id'] != currentUserId, orElse: () => null);
    final basicInfo = otherUser?['basicInfo'];
    final displayName = basicInfo?['firstName'] ?? 'Unknown';
    final isOnline = onlineUsers.contains(otherUser['_id']);
    final isTyping = typingUsers.contains(otherUser['_id']);

    final groupedMessages = <String, List<Map<String, dynamic>>>{};
    for (var message in messages) {
      final date = convertToIST(message['createdAt']);
      groupedMessages.putIfAbsent(date, () => []).add(message);
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          height: 56.v,
          leadingWidth: 40.h,
          leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
            margin: EdgeInsets.only(left: 16.h, top: 16.v, bottom: 16.v),
            onTap: onTapArrowLeft,
          ),
          title: Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppbarSubtitleOne(text: displayName),
                    if (isOnline)
                      Padding(
                        padding: EdgeInsets.only(left: 8.h),
                        child: const Icon(Icons.circle,
                            color: Colors.green, size: 12),
                      ),
                    AppbarTitleImage(
                      imagePath: ImageConstant.imgVerified,
                      margin: EdgeInsets.only(left: 2.h, top: 3.v, bottom: 2.v),
                    ),
                  ],
                ),
                if (isTyping)
                  Text(
                    "$displayName is typing...",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
              ],
            ),
          ),
          actions: [
            AppbarTrailingButtonOne(
              margin: EdgeInsets.only(left: 12.h, top: 8.v),
              onTap: onTapThreeThousand,
            ),
            AppbarTrailingImage(
              imagePath: ImageConstant.imgVideo,
              margin: EdgeInsets.fromLTRB(5.h, 18.v, 8.h, 10.v),
              onTap: onTapVideo,
            ),
            AppbarTrailingImage(
              imagePath: ImageConstant.imgPhoneGray900,
              margin: EdgeInsets.fromLTRB(10.h, 18.v, 24.h, 10.v),
              onTap: onTapPhone,
            ),
          ],
          styleType: Styled.bgFill_3,
        ),
        body: Stack(
          children: [
            Positioned(
              left: 270,
              top: 50,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Align(
                  child: SizedBox(
                    width: 252,
                    height: 252,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(126),
                        color: appTheme.deepOrangeA20.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ListView.builder(
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  CustomElevatedButton(
                                      height: 24.v,
                                      width: 137.h,
                                      text: "msg_wednesday_jan_17th".tr,
                                      margin: EdgeInsets.only(top: 20.v),
                                      buttonStyle: CustomButtonStyles
                                          .fillOnPrimaryContainer,
                                      buttonTextStyle:
                                          CustomTextStyles.bodySmallBluegray300,
                                      alignment: Alignment.topCenter),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 188.h,
                                          right: 20.h,
                                          bottom: 10.v,
                                          top: 14.v),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.h,
                                                    vertical: 14.v),
                                                decoration: AppDecoration
                                                    .fillPrimary
                                                    .copyWith(
                                                        borderRadius:
                                                            BorderRadiusStyle
                                                                .customBorderTL201),
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(height: 2.v),
                                                      Text(
                                                          "msg_hey_how_s_it_going"
                                                              .tr,
                                                          style: CustomTextStyles
                                                              .bodyLargeGray900)
                                                    ])),
                                            SizedBox(height: 5.v),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 14.h),
                                                child: _buildFrame(
                                                    time: "lbl_09_32_pm".tr,
                                                    readBy: []))
                                          ])),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 16.h, right: 142.h),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.h,
                                                    vertical: 14.v),
                                                decoration: AppDecoration
                                                    .fillOnPrimaryContainer
                                                    .copyWith(
                                                        borderRadius:
                                                            BorderRadiusStyle
                                                                .customBorderTL20),
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(height: 2.v),
                                                      Text(
                                                          "msg_not_much_just_chilling"
                                                              .tr,
                                                          style: CustomTextStyles
                                                              .bodyLargeGray900)
                                                    ])),
                                            SizedBox(height: 5.v),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 14.h),
                                                child: _buildFrame(
                                                    time: "lbl_09_32_pm".tr,
                                                    readBy: []))
                                          ])),
                                  Container(
                                      margin: EdgeInsets.only(left: 116.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.h, vertical: 13.v),
                                      decoration: AppDecoration.fillPrimary
                                          .copyWith(
                                              borderRadius: BorderRadiusStyle
                                                  .customBorderTL201),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 2.v),
                                            SizedBox(
                                                width: 193.h,
                                                child: Text(
                                                    "msg_same_here_anything".tr,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: CustomTextStyles
                                                        .bodyLargeGray900))
                                          ])),
                                  SizedBox(height: 5.v),
                                  Padding(
                                      padding: EdgeInsets.only(left: 130.h),
                                      child: _buildFrame(
                                          time: "lbl_09_32_pm".tr, readBy: [])),
                                  SizedBox(height: 14.v),
                                  Container(
                                      width: 253.h,
                                      margin: EdgeInsets.only(right: 90.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.h, vertical: 13.v),
                                      decoration: AppDecoration
                                          .fillOnPrimaryContainer
                                          .copyWith(
                                              borderRadius: BorderRadiusStyle
                                                  .customBorderTL20),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 2.v),
                                            Container(
                                                width: 195.h,
                                                margin: EdgeInsets.only(
                                                    right: 27.h),
                                                child: Text(
                                                    "msg_nah_just_the_usual".tr,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: CustomTextStyles
                                                        .bodyLargeGray900))
                                          ])),
                                  SizedBox(height: 5.v),
                                  Padding(
                                      padding: EdgeInsets.only(left: 14.h),
                                      child: _buildFrame(
                                          time: "lbl_09_32_pm".tr, readBy: [])),
                                  Container(
                                      margin: EdgeInsets.only(left: 87.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.h, vertical: 13.v),
                                      decoration: AppDecoration.fillPrimary
                                          .copyWith(
                                              borderRadius: BorderRadiusStyle
                                                  .customBorderTL201),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 2.v),
                                            SizedBox(
                                                width: 224.h,
                                                child: Text(
                                                    "msg_haha_i_feel_that".tr,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: CustomTextStyles
                                                        .bodyLargeGray900))
                                          ])),
                                  SizedBox(height: 5.v),
                                  Padding(
                                      padding: EdgeInsets.only(left: 101.h),
                                      child: _buildFrame(
                                          time: "lbl_09_32_pm".tr, readBy: [])),
                                  SizedBox(height: 5.v),
                                ],
                              );
                            },
                          ),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: groupedMessages.keys.length,
                          itemBuilder: (context, index) {
                            final date = groupedMessages.keys.elementAt(index);
                            final dateMessages =
                                groupedMessages[date]!.reversed.toList();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10.0, sigmaY: 10.0),
                                        child: Container(
                                          height: 24.v,
                                          width: 137.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                                color: Colors.transparent,
                                                width: 1.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              date,
                                              style: CustomTextStyles
                                                  .bodySmallBluegray300
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ...dateMessages.map((msg) {
                                  final isOwnMessage =
                                      msg['sender']['_id'] == currentUserId;
                                  return Column(
                                    children: [
                                      isOwnMessage
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 40.h,
                                                  right: 16.h,
                                                  bottom: 10.v,
                                                  top: 4.v),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15.h,
                                                            vertical: 14.v),
                                                    decoration: AppDecoration
                                                        .fillPrimary
                                                        .copyWith(
                                                            borderRadius:
                                                                BorderRadiusStyle
                                                                    .customBorderTL201),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(height: 2.v),
                                                        Text(
                                                            "${msg['content']}",
                                                            style: CustomTextStyles
                                                                .bodyLargeGray900),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.v),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 14.h),
                                                        child: _buildFrame(
                                                          time: convertToISTs(
                                                              msg['createdAt']),
                                                          readBy: msg['readBy'],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16.h, right: 142.h),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15.h,
                                                            vertical: 14.v),
                                                    decoration: AppDecoration
                                                        .fillOnPrimaryContainer
                                                        .copyWith(
                                                            borderRadius:
                                                                BorderRadiusStyle
                                                                    .customBorderTL20),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(height: 2.v),
                                                        Text(
                                                            "${msg['content']}",
                                                            style: CustomTextStyles
                                                                .bodyLargeGray900),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.v),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 14.h),
                                                        child: _buildFrame(
                                                          time: convertToISTs(
                                                              msg['createdAt']),
                                                          readBy: msg['readBy'],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: controller,
                          hintText: "Write a message...",
                          hintStyle: CustomTextStyles.titleMediumBluegray300,
                          textInputAction: TextInputAction.done,
                          prefix: Container(
                            margin: EdgeInsets.fromLTRB(15.h, 14.v, 10.h, 14.v),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgSmile,
                              color: Colors.transparent,
                              height: 12.adaptSize,
                              width: 12.adaptSize,
                            ),
                          ),
                          prefixConstraints: BoxConstraints(maxHeight: 52.v),
                          contentPadding: EdgeInsets.only(
                              top: 16.v, right: 30.h, bottom: 16.v),
                          borderDecoration:
                              TextFormFieldStyleHelper.outlineGrayTL26,
                          fillColor: appTheme.gray20002,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6.h),
                        child: CustomIconButton(
                          height: 52.adaptSize,
                          width: 52.adaptSize,
                          padding: EdgeInsets.all(14.h),
                          decoration: IconButtonStyleHelper.fillPrimaryTL24,
                          onTap: sendMessage,
                          child: CustomImageView(
                            imagePath: ImageConstant.imgIconSolidPaperAirplane,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrame({required String time, required List<dynamic> readBy}) {
    final otherUserId = chat['users']?.firstWhere(
        (u) => u['_id'] != currentUserId,
        orElse: () => null)?['_id'];

    bool isReadByBoth =
        readBy.contains(currentUserId) && readBy.contains(otherUserId);

    return Row(
      children: [
        Text(
          time,
          style: CustomTextStyles.bodySmallBluegray300,
        ),
        if (isReadByBoth)
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Icon(
              Icons.done_all,
              size: 16.adaptSize,
              color: Colors.blue,
            ),
          )
        else if (readBy.contains(currentUserId))
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Icon(
              Icons.done,
              size: 16.adaptSize,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }

  void onTapThreeThousand() {
    // Implement the logic for the trailing button action
  }

  void onTapVideo() {
    // Implement the logic for the video call action
  }

  void onTapPhone() {
    // Implement the logic for the phone call action
  }
}
