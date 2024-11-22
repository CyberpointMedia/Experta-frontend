import 'dart:developer';
import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/message_screen/widgets/anjaliarora_item_widget.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'controller/message_controller.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final MessageController controller = Get.put(MessageController());
  late IO.Socket socket;
  late ApiService apiServices;
  List<Map<String, dynamic>> chats = [];
  List<Map<String, dynamic>> filteredChats = [];
  bool isFetchingChats = false;
  final currentUserId = PrefUtils().getaddress();
  Set<String> onlineUsers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        apiServices = ApiService();
        initSocket();
        fetchChats(currentUserId!);
      } catch (error) {
        log('Error in initState: $error');
      }
    });

    controller.searchController.addListener(_filterChats);
  }

  void initSocket() {
    final currentUserId = PrefUtils().getaddress();

    // Initialize the socket connection
    socket = IO.io('http://3.110.252.174:8080', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, // Prevents automatic connection
    });

    // Set up socket event listeners
    socket.onConnect((_) {
      log('Connected to socket');
      socket.emit('init_user', currentUserId);
      log('User ID emitted: $currentUserId');
      fetchChats(currentUserId!);
    });

    socket.on('chats_fetched', (data) {
      log('Chats fetched event received: $data');
      // Ensure data is a list
      if (data is List) {
        setState(() {
          chats = List<Map<String, dynamic>>.from(
              data.map((chat) => Map<String, dynamic>.from(chat)));
          isFetchingChats = false;
          _filterChats(); // Filter chats after fetching
        });
      } else {
        log('Invalid data format for chats_fetched');
      }
    });

    socket.on('update_unread_count', (data) {
      log('Update unread count event received: $data');
    });

    socket.on('getUserOnline', (data) {
      String userId = data['userId'];
      log('User online event received: $userId');
      setState(() {
        onlineUsers.add(userId);
      });
    });

    socket.on('getUserOffline', (data) {
      String userId = data['userId'];
      log('User offline event received: $userId');
      setState(() {
        onlineUsers.remove(userId);
      });
    });

    socket.onDisconnect((_) {
      log('Disconnected from socket');
    });

    socket.connect(); 
  }

  void fetchChats(String userId) {
    setState(() {
      isFetchingChats = true;
    });
    socket.emit('fetch_chats', userId);
  }
  void markMessagesAsRead(String chatId, String userId) {
    socket.emit('mark_messages_read', {'chatId': chatId, 'userId': userId});
  }

  void _filterChats() {
    final query = controller.searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredChats = chats;
      });
    } else {
      setState(() {
        filteredChats = chats.where((chat) {
          final otherUser = chat['users']?.firstWhere(
            (u) => u['_id'] != PrefUtils().getaddress(),
            orElse: () => null,
          );
          if (otherUser == null) return false;

          final displayName =
              otherUser['basicInfo']?['displayName']?.toLowerCase() ??
                  otherUser['email']?.toLowerCase() ??
                  'unknown';

          return displayName.contains(query);
        }).toList();
      });
    }
    log('Filtered Chats: $filteredChats');
  }

  @override
  void dispose() {
    controller.searchController.removeListener(_filterChats);
    // controller.searchController.dispose();
    controller.searchController.clear();
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = PrefUtils().getaddress();

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          centerTitle: true,
          height: 48.v,
          title: AppbarSubtitle(
              text: "lbl_inbox".tr, margin: EdgeInsets.only(left: 15.h)),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.notification);
                },
                padding: const EdgeInsets.only(right: 5),
                icon: Container(
                  width: 35.0,
                  height: 35.0,
                  padding: const EdgeInsets.all(5),
                  decoration: IconButtonStyleHelper.outline.copyWith(
                    color: appTheme.whiteA700.withOpacity(0.6),
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgBell02,
                    height: 8.0,
                    width: 8.0,
                  ),
                ),
              ),
            )
          ]),
      body: Stack(
        children: [
          Positioned(
            left: 270,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                tileMode: TileMode.decal,
                sigmaX: 60,
                sigmaY: 60,
              ),
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
          SizedBox(
              width: double.maxFinite,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 25.v),
                        child: CustomSearchView(
                          width: 343.h,
                          controller: controller.searchController,
                          hintText: "lbl_search".tr,
                        )),
                    SizedBox(height: 29.v),
                    SizedBox(
                      height: 100.v,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) {
                          return SizedBox(width: 20.h);
                        },
                        itemCount: filteredChats.length,
                        itemBuilder: (context, index) {
                          final chat = filteredChats[index];
                          final otherUser = chat['users']?.firstWhere(
                            (u) => u['_id'] != currentUserId,
                            orElse: () => null,
                          );

                          if (otherUser == null ||
                              !(otherUser['online'] ?? false)) {
                            return const SizedBox.shrink();
                          }

                          final basicInfo = otherUser['basicInfo'];
                          final profilePic = basicInfo?['profilePic'] ?? '';
                          final displayName = basicInfo?['displayName'] ??
                              basicInfo?["firstName"] +
                                  " " +
                                  basicInfo?["lastName"] ??
                              'Unknown';

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ChatItemWidget(
                              profilePic: profilePic,
                              displayName: displayName,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 9.v),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.h),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("lbl_recent_messages".tr,
                                      style: CustomTextStyles.titleMediumBold),
                                  SizedBox(height: 17.v),
                                  _buildChatList(currentUserId!)
                                ])))
                  ])),
        ],
      ),
    ));
  }

  Widget _buildChatList(String currentUserId) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: filteredChats.length,
        itemBuilder: (context, index) {
          final chat = filteredChats[index];
          final otherUser = chat['users']?.firstWhere(
            (u) => u['_id'] != currentUserId,
            orElse: () => null,
          );

          if (otherUser == null) {
            return const SizedBox.shrink();
          }

          final unreadCount = chat['unreadCounts']?.firstWhere(
            (uc) => uc['user'] == currentUserId,
            orElse: () => {'count': 0},
          )['count'];

          int unreadCountInt = (unreadCount is int)
              ? unreadCount
              : int.tryParse(unreadCount.toString()) ?? 0;
          final basicInfo = otherUser['basicInfo'];
          final profilePic = basicInfo?['profilePic'];
          final online = otherUser['online'];
          final displayName =
              basicInfo?['displayName'] ?? basicInfo['firstName'] ?? 'Unknown';
          final lastMessage =
              chat['lastMessage']?['content'] ?? 'No messages yet';
          final lastMessageTime = chat['lastMessage']?["time"] ?? "0.00";

          return GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRoutes.chattingScreen,
                arguments: {'chat': chat, 'socket': socket},
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.v),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CustomImageView(
                      height: 55.h,
                      width: 55.v,
                      imagePath: profilePic ?? ImageConstant.imageNotFound,
                      radius: BorderRadius.circular(55.h),
                      border: Border.all(color: appTheme.deepYello),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 16.adaptSize,
                        width: 16.adaptSize,
                        decoration: BoxDecoration(
                          color: online == true
                              ? appTheme.green400
                              : appTheme.red500,
                          borderRadius: BorderRadius.circular(8.h),
                          border: Border.all(
                            color: theme.colorScheme.onPrimaryContainer
                                .withOpacity(1),
                            width: 2.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: Padding(
                        padding:
                            EdgeInsets.only(left: 15.h, top: 4.v, bottom: 7.v),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 270.h,
                                  child: Row(children: [
                                    Column(
                                      children: [
                                        Text(displayName,
                                            style: CustomTextStyles
                                                .titleMediumSemiBold),
                                        SizedBox(height: 2.v),
                                        Text(lastMessage,
                                            textAlign: TextAlign.start,
                                            style: theme.textTheme.titleSmall!
                                                .copyWith(
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                      ],
                                    ),
                                    if (basicInfo?['isVerified'] == true)
                                      CustomImageView(
                                          imagePath: ImageConstant.imgVerified,
                                          height: 16.adaptSize,
                                          width: 16.adaptSize,
                                          margin: EdgeInsets.only(
                                              left: 2.h,
                                              top: 2.v,
                                              bottom: 2.v)),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        Text(lastMessageTime,
                                            textAlign: TextAlign.right,
                                            style: CustomTextStyles
                                                .bodyMediumLight),
                                        if (unreadCountInt > 0)
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor: appTheme.deepYello,
                                            child: Text(
                                              '$unreadCountInt',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ])),
                            ]))),
              ]),
            ),
          );
        },
      ),
    );
  }

  onTapArrowLeft() {
    Get.back();
  }

  /// Navigates to the notificationScreen when the action is triggered.
  onTapBellTwo() {
    Get.toNamed(
      AppRoutes.notification,
    );
  }
}
