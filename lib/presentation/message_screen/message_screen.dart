import 'dart:ui';
import 'package:experta/widgets/socket_service.dart';
import 'package:provider/provider.dart';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/message_screen/widgets/anjaliarora_item_widget.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_iconbutton.dart';
import 'controller/message_controller.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final MessageController controller = Get.put(MessageController());
  List<dynamic> filteredChats = [];

  @override
  void initState() {
    super.initState();
    final socketService =
        Provider.of<InboxSocketService>(context, listen: false);
    final currentUserId = PrefUtils().getaddress();
    socketService.initUser(currentUserId!);
    controller.searchController.addListener(_filterChats);

    // Fetch initial chats
    socketService.fetchChats(currentUserId);
    socketService.onChatsFetched((data) {
      setState(() {
        filteredChats = data;
      });
    });
  }

  @override
  void dispose() {
    controller.searchController.removeListener(_filterChats);
    controller.searchController.clear();
    super.dispose();
  }

  void _filterChats() {
    final socketService =
        Provider.of<InboxSocketService>(context, listen: false);
    final query = controller.searchController.text.toLowerCase();
    setState(() {
      filteredChats = socketService.chats.where((chat) {
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
    final unreadCounts = chat['unreadCounts'];

    if (unreadCounts is List) {
      final unreadCount = unreadCounts.firstWhere(
        (uc) => uc['user'] == currentUserId,
        orElse: () => {'count': 0},
      )['count'];

      return unreadCount is int
          ? unreadCount
          : int.tryParse(unreadCount.toString()) ?? 0;
    } else {
      // If unreadCounts is not a list, return 0 or handle accordingly
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<InboxSocketService>(context);
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
              arguments: {'chat': chat},
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.v),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CustomImageView(
                    height: 60.v,
                    width: 60.h,
                    imagePath: profilePic ?? ImageConstant.imageNotFound,
                    radius: BorderRadius.circular(50.h),
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
                          color: appTheme.whiteA700,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          displayName,
                          style: CustomTextStyles.titleMediumSemiBold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (basicInfo?['isVerified'] == true)
                          CustomImageView(
                              imagePath: ImageConstant.imgVerified,
                              height: 16.adaptSize,
                              width: 16.adaptSize,
                              margin: EdgeInsets.only(
                                  left: 2.h, top: 2.v, bottom: 2.v)),
                        Text(
                          lastMessageTime,
                          style: CustomTextStyles.bodyMediumLight,
                        ),
                      ],
                    ),
                    SizedBox(height: 5.v),
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
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

void onTapBellTwo() {
  Get.toNamed(AppRoutes.notification);
}
