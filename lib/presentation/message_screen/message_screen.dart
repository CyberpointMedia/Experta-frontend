import 'dart:developer';
import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/message_screen/widgets/anjaliarora_item_widget.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_iconbutton.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        apiServices = ApiService();
        fetchChats();
        initSocket();
      } catch (error) {
        log('Error in initState: $error');
      }
    });

    controller.searchController.addListener(_filterChats);
  }

  // Initialize socket connection and listen for events
  void initSocket() {
    final currentUserId = PrefUtils().getaddress();

    // Initialize the socket connection
    socket = IO.io('http://3.110.252.174:8080', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {'Authorization': 'Bearer $currentUserId'},
    });

    // Connect to the socket server
    socket.connect();

    // Listen for chat updates
    socket.on('chatUpdate', (data) {
      log('Chat update received: $data');
      fetchChats();
    });

    // Listen for user status updates (online/offline)
    socket.on('userStatus', (data) {
      final userId = data['userId'];
      final isOnline = data['isOnline'];
      log('User status update received: $userId is ${isOnline ? "online" : "offline"}');

      // Update the user's status in the chat list
      setState(() {
        for (var chat in chats) {
          final otherUser = chat['users']?.firstWhere(
            (u) => u['_id'] == userId,
            orElse: () => null,
          );
          if (otherUser != null) {
            otherUser['online'] = isOnline;
          }
        }
      });
    });

    // Handle connection errors
    socket.on('connect_error', (data) {
      log('Socket connection error: $data');
    });

    // Handle disconnection
    socket.on('disconnect', (_) {
      log('Socket disconnected');
    });
  }

  Future<void> fetchChats() async {
    if (isFetchingChats) return;
    setState(() {
      isFetchingChats = true;
    });

    try {
      final fetchedChats = await apiServices.fetchChats();
      setState(() {
        chats = List<Map<String, dynamic>>.from(fetchedChats);
        filteredChats = chats;
      });
    } catch (error) {
      log('Error fetching chats: $error');
    } finally {
      setState(() {
        isFetchingChats = false;
      });
    }
  }

  void _filterChats() {
    final query = controller.searchController.text.toLowerCase();
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

  int handleUnreadCount(Map<String, dynamic> chat, String currentUserId) {
    final unreadCount = chat['unreadCounts']?.firstWhere(
      (uc) => uc['user'] == currentUserId,
      orElse: () => {'count': 0},
    )['count'];

    int unreadCountInt = (unreadCount is int)
        ? unreadCount
        : int.tryParse(unreadCount.toString()) ?? 0;

    return unreadCountInt;
  }

  @override
  void dispose() {
    controller.searchController.dispose();
    socket.dispose(); // Disconnect the socket when the widget is disposed
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
            AppbarTrailingIconbutton(
                imagePath: ImageConstant.imgBell02,
                margin: EdgeInsets.symmetric(horizontal: 16.h),
                onTap: () {
                  onTapBellTwo();
                })
          ]),
      body: Stack(
        children: [
          Positioned(
            left: 270,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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

        final unreadCountInt = handleUnreadCount(chat, currentUserId);
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
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 29.h,
                    backgroundColor: appTheme.whiteA700,
                    backgroundImage: profilePic != null
                        ? NetworkImage(profilePic) as ImageProvider
                        : const AssetImage('assets/images/image_not_found.png'),
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
              SizedBox(width: 12.h),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    SizedBox(
                        width: 270.h,
                        child: Row(children: [
                          Text(displayName,
                              style: CustomTextStyles.titleMediumSemiBold),
                          if (basicInfo?['isVerified'] == true)
                            CustomImageView(
                                imagePath: ImageConstant.imgVerified,
                                height: 16.adaptSize,
                                width: 16.adaptSize,
                                margin: EdgeInsets.only(
                                    left: 2.h, top: 2.v, bottom: 2.v)),
                          const Spacer(),
                          Text(lastMessageTime,
                              textAlign: TextAlign.right,
                              style: CustomTextStyles.bodyMediumLight)
                        ])),
                    SizedBox(height: 6.v),
                    Row(
                      children: [
                        Expanded(
                          child: Text(lastMessage,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: theme.textTheme.bodyLarge),
                        ),
                        if (unreadCountInt > 0)
                          CircleAvatar(
                            backgroundColor: appTheme.deepOrangeA20,
                            radius: 12,
                            child: Text(
                              '$unreadCountInt',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                      ],
                    ),
                  ])),
            ]),
          ),
        );
      },
    );
  }

  void onTapBellTwo() {
    Get.toNamed(AppRoutes.notification);
  }
}
