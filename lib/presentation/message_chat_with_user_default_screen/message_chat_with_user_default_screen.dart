import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/data/apiClient/call_api_service.dart';
import 'package:experta/presentation/message_chat_with_user_default_screen/widgets/message_list.dart';
import 'package:experta/presentation/video_call/audio_call.dart';
import 'package:experta/presentation/video_call/video_call_screen.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_one.dart';
import 'package:experta/widgets/app_bar/appbar_title_image.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_button_one.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_image.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  TextEditingController controller = TextEditingController();
  final Map<String, dynamic> arguments = Get.arguments;
  late final Map<String, dynamic> chat;
  late final IO.Socket socket;
  late ApiService apiServices;
  List<Map<String, dynamic>> messages = [];
  final currentUserId = PrefUtils().getaddress();
  List<File> selectedFiles = [];
  bool isLoading = true;
  int? balance;
  final CallApiService _apiService = CallApiService();
  final ApiService apiService = ApiService();
  bool isLoading2 = false;
  bool isLoading1 = false;

  Future<void> pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        selectedFiles = result.paths.map((path) => File(path!)).toList();
      });
    }
  }

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
    fetchWalletBalance();
  }

  void _scheduleMeeting(String type) async {
    final otherUserId = chat['users']?.firstWhere(
        (u) => u['_id'] != currentUserId,
        orElse: () => null)?['_id'];

    final otherUser = chat['users']?.firstWhere(
      (u) => u['_id'] != currentUserId,
      orElse: () => null,
    );
    final basicInfo = otherUser?['basicInfo'];
    final displayName = basicInfo?['firstName'] ?? 'Unknown';
    DateTime currentTime = DateTime.now();

    DateTime timeAfter30Minutes = currentTime.add(const Duration(minutes: 1));

    String isoStartTime = currentTime.toIso8601String();
    String isoEndTime = timeAfter30Minutes.toIso8601String();

    final bookingData = {
      "expertId": otherUserId,
      "startTime": "${isoStartTime}Z",
      "endTime": "${isoEndTime}Z",
      "type": type
    };
    log("$bookingData");
    try {
      final responses = await apiService.createBooking(bookingData);

      if (responses['status'] == 'success') {
        type == 'video'
            ? setState(() {
                isLoading2 = false;
              })
            : setState(() {
                isLoading1 = false;
              });
        final meetingId = responses['data']['_id'];
        _startCall(otherUserId, meetingId, type, displayName, '');
      } else {
        _showErrorDialog(context, " ${responses['error']['errorMessage']}");
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _startCall(String userId, String meetingId, String Type, String userName,
      String profilePic) async {
    if (userId.isNotEmpty && meetingId.isNotEmpty) {
      if (userId != currentUserId.toString()) {
        final response = await _apiService.getMeeting(meetingId);
        if (response.statusCode == 201) {
          Type == 'video'
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoCallScreen(
                      userId: userId,
                      meetingId: meetingId,
                      userName: userName,
                      bookingId: meetingId,
                      profilePic: profilePic,
                    ),
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioCallScreen(
                      userId: userId,
                      meetingId: meetingId,
                      userName: userName,
                      bookingId: meetingId,
                      profilePic: profilePic,
                    ),
                  ),
                );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to get meeting details')),
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: "You cannot call yourself",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: appTheme.red500,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both User ID and Meeting ID')),
      );
    }
  }

  Future<void> fetchWalletBalance() async {
    ApiService apiServices = ApiService();
    int? fetchedBalance = await apiServices.getWalletBalance();

    setState(() {
      balance = fetchedBalance;
      isLoading = false;
    });
  }

  void initializeSocket() {
    log('Initializing socket...');
    socket.connect();

    socket.on('connect', (_) {
      log('Connected to socket server');
      socket.emit('join', {'chatId': chat['_id'], 'userId': currentUserId});
      fetchMessages();
    });

    socket.on('connect_error', (error) {
      log('Socket connection error: $error');
      reconnectSocket();
    });

    socket.on('disconnect', (_) {
      log('Disconnected from socket server');
      reconnectSocket();
    });

    socket.on('reconnect_attempt', (_) {
      log('Attempting to reconnect to socket server...');
    });

    socket.on('reconnect_failed', (_) {
      log('Failed to reconnect to socket server');
    });

    socket.on('reconnect', (_) {
      log('Reconnected to socket server');
    });

    socket.on('messages', (data) {
      log('Messages received: $data');
      setState(() {
        messages = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
      _markMessagesAsReadIfNecessary();
    });

    socket.on('new_msg_received', (data) async {
      log('New message received: $data');
      setState(() {
        messages.insert(0, Map<String, dynamic>.from(data));
        markMessagesAsRead();
      });
    });

    socket.on('messages_marked_read', (data) {
      log('Messages marked as read: $data');
      final chatId = data['chatId'];
      final userId = data['userId'];
      if (userId != currentUserId) {
        updateMessageReadStatus(chatId);
      }
    });
  }

  void updateMessageReadStatus(String chatId) {
    setState(() {
      messages = messages.map((msg) {
        if (msg['chat'] == chatId && !msg['readBy'].contains(currentUserId)) {
          msg['readBy'].add(currentUserId);
        }
        return msg;
      }).toList();
    });
  }

  void _markMessagesAsReadIfNecessary() {
    List<String> messageIds = messages
        .where((msg) => msg['sender']['_id'] != currentUserId)
        .map<String>((msg) => msg['_id'])
        .toList();
    if (messageIds.isNotEmpty) {
      markMessagesAsRead();
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
      setState(() {
        messages = fetchedMessages;
        isLoading = false;
      });
      List<String> messageIds = fetchedMessages
          .where((msg) => msg['sender']['_id'] != currentUserId)
          .map<String>((msg) => msg['_id'])
          .toList();
      if (messageIds.isNotEmpty) {
        await markMessagesAsRead();
      }
    } catch (error) {
      log('Error fetching messages: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> markMessagesAsRead() async {
    try {
      socket.emit('mark_messages_read', {
        'chatId': chat['_id'],
        'userId': currentUserId,
      });
    } catch (error) {
      log('Error marking messages as read: $error');
    }
  }

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty && selectedFiles.isEmpty) return;
    final content = controller.text.trim();
    final newMsg = {
      'content': content,
      'createdAt': DateTime.now().toUtc().toString(),
      'sender': {'_id': currentUserId},
      'readBy': [currentUserId]
    };

    setState(() {
      messages.insert(0, newMsg);
      controller.clear();
      selectedFiles.clear();
    });

    try {
      final sentMsg = await apiServices.sendMessage(
          content, "${chat['_id']}", selectedFiles);
      setState(() {
        int index = messages
            .indexWhere((msg) => msg['createdAt'] == newMsg['createdAt']);
        if (index != -1) {
          messages[index] = sentMsg;
        }
      });
      setState(() {
        messages.remove(newMsg);
        fetchMessages();
      });
      log("hey the new messagesent is $newMsg");
      socket.emit('new_msg_sent', sentMsg);
      // fetchMessages();
      markMessagesAsRead();
    } catch (error) {
      log('Error sending message: $error');
    }
  }

  void updateChatWithNewMessage(Map newMsg) {
    setState(() {
      messages = messages.map((chat) {
        if (chat['_id'] == newMsg['chat']['_id']) {
          chat['lastMessage'] = newMsg;
        }
        return chat;
      }).toList();
    });
  }

  String convertToIST(String utcTime) {
    DateTime utcDateTime = DateTime.parse(utcTime).toUtc();
    DateTime istDateTime =
        utcDateTime.add(const Duration(hours: 5, minutes: 30));
    return DateFormat('d MMMM yyyy').format(istDateTime);
  }

  String convertToISTs(String utcTime) {
    DateTime utcDateTime = DateTime.parse(utcTime).toUtc();
    DateTime istDateTime =
        utcDateTime.add(const Duration(hours: 5, minutes: 30));
    return DateFormat('hh:mm a').format(istDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final otherUser = chat['users']?.firstWhere(
      (u) => u['_id'] != currentUserId,
      orElse: () => null,
    );
    final basicInfo = otherUser?['basicInfo'];
    final displayName = basicInfo?['firstName'] ?? 'Unknown';

    Map<String, List<Map<String, dynamic>>> groupedMessages = {};
    for (var message in messages) {
      String date = convertToIST(message['createdAt']);
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
            child: Row(
              children: [
                AppbarSubtitleOne(text: displayName),
                AppbarTitleImage(
                  imagePath: ImageConstant.imgVerified,
                  margin: EdgeInsets.only(left: 2.h, top: 3.v, bottom: 2.v),
                ),
              ],
            ),
          ),
          actions: [
            AppbarTrailingButtonOne(
              balance: balance ?? 0,
              margin: EdgeInsets.only(left: 12.h, top: 8.v),
              onTap: onTapThreeThousand,
            ),
            isLoading2
                ? CircularProgressIndicator(
                    color: theme.primaryColor,
                  )
                : AppbarTrailingImage(
                    imagePath: ImageConstant.imgVideo,
                    margin: EdgeInsets.fromLTRB(5.h, 18.v, 8.h, 10.v),
                    onTap: () {
                      setState(() {
                        isLoading2 = true;
                      });
                      _scheduleMeeting('video');
                    },
                  ),
            isLoading1
                ? CircularProgressIndicator(
                    color: theme.primaryColor,
                  )
                : AppbarTrailingImage(
                    imagePath: ImageConstant.imgPhoneGray900,
                    margin: EdgeInsets.fromLTRB(10.h, 18.v, 24.h, 10.v),
                    onTap: () {
                      setState(() {
                        isLoading1 = true;
                      });
                      _scheduleMeeting('audio');
                    },
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
                imageFilter: ImageFilter.blur(
                    tileMode: TileMode.decal, sigmaX: 60, sigmaY: 60),
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
                  child: isLoading
                      ? const MessageListShimmer()
                      : messages.isEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "👋",
                                    style: theme.textTheme.titleSmall!
                                        .copyWith(fontSize: 70),
                                  ),
                                  Text(
                                    "Say hi to $displayName",
                                    style: theme.textTheme.titleSmall!.copyWith(
                                        fontSize: 18, color: appTheme.black900),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    child: Text(
                                      "You have 250 characters to ask a question get advice, or whatever. Remember, there’s no guarantee you’ll get a response.",
                                      style: theme.textTheme.titleSmall!,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              reverse: true,
                              itemCount: groupedMessages.keys.length,
                              itemBuilder: (context, index) {
                                String date =
                                    groupedMessages.keys.elementAt(index);
                                List<Map<String, dynamic>> dateMessages =
                                    groupedMessages[date]!.reversed.toList();
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10.0, sigmaY: 10.0),
                                            child: Container(
                                              height: 24.v,
                                              width: 137.h,
                                              decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
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
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    15.h,
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
                                                            SizedBox(
                                                                height: 2.v),
                                                            Text(
                                                                "${msg['content']}",
                                                                style: theme
                                                                    .textTheme
                                                                    .titleSmall!
                                                                    .copyWith(
                                                                        color: appTheme
                                                                            .black900)),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 5.v),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right:
                                                                        14.h),
                                                            child: _buildFrame(
                                                              time: convertToISTs(
                                                                  msg['createdAt']),
                                                              readBy:
                                                                  msg['readBy'],
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
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    15.h,
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
                                                            SizedBox(
                                                                height: 2.v),
                                                            Text(
                                                                "${msg['content']}",
                                                                style: theme
                                                                    .textTheme
                                                                    .titleSmall!
                                                                    .copyWith(
                                                                        color: appTheme
                                                                            .black900)),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 5.v),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 14.h),
                                                        child: Text(
                                                          convertToISTs(
                                                              msg['createdAt']),
                                                          style: CustomTextStyles
                                                              .bodySmallBluegray300
                                                              .copyWith(
                                                                  color: appTheme
                                                                      .blueGray300),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      );
                                    }),
                                  ],
                                );
                              },
                            ),
                ),
                _buildNinetyNine(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNinetyNine() {
    return Container(
      margin: EdgeInsets.only(bottom: 5.v),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          Padding(
            padding: EdgeInsets.only(left: 16.h, top: 6.v, right: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: controller,
                    hintText: "msg_write_a_message".tr,
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
                    contentPadding:
                        EdgeInsets.only(top: 16.v, right: 30.h, bottom: 16.v),
                    borderDecoration: TextFormFieldStyleHelper.outlineGrayTL26,
                    fillColor: appTheme.gray20002,
                    // suffix: IconButton(
                    //   icon: const Icon(CupertinoIcons.paperclip),
                    //   onPressed: () {
                    //     pickFiles();
                    //   },
                    // ),
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
    );
  }

  Widget _buildFrame({
    required String time,
    required List<dynamic> readBy,
  }) {
    log("the message is getting marked");
    final otherUserId = chat['users']?.firstWhere(
        (u) => u['_id'] != currentUserId,
        orElse: () => null)?['_id'];

    bool isReadByBoth =
        readBy.contains(currentUserId) && readBy.contains(otherUserId);
    log("is read by both: $isReadByBoth");

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          time,
          style: CustomTextStyles.bodySmallBluegray300
              .copyWith(color: appTheme.blueGray300),
        ),
        const SizedBox(width: 4),
        if (isReadByBoth)
          Icon(
            Icons.done_all,
            size: 16,
            color: appTheme.blueGray300,
          )
        else
          Icon(
            Icons.done,
            size: 16,
            color: appTheme.blueGray300,
          ),
      ],
    );
  }
}

void onTapArrowLeft() {
  Get.back();
}

void onTapThreeThousand() {
  Get.toNamed(AppRoutes.wallet);
}
