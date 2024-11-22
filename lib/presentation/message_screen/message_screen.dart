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
  late final ApiService apiServices;
  final String? currentUserId = PrefUtils().getaddress();

  List<Map<String, dynamic>> _chats = [];
  List<Map<String, dynamic>> _filteredChats = [];
  final Set<String> _onlineUsers = {};

  @override
  void initState() {
    super.initState();
    _initializeServices();
    controller.searchController.addListener(_filterChats);
  }

  void _initializeServices() async {
    try {
      apiServices = ApiService();
      await _initSocket();
      if (currentUserId != null) {
        fetchChats(currentUserId!);
      }
    } catch (error) {
      log('Error in initialization: $error');
    }
  }

  Future<void> _initSocket() async {
    socket = IO.io('http://3.110.252.174:8080', {
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _setupSocketListeners();
    socket.connect();
  }

  void _setupSocketListeners() {
    socket
      ..onConnect((_) {
        log('Connected to socket');
        socket.emit('init_user', currentUserId);
        if (currentUserId != null) fetchChats(currentUserId!);
      })
      ..on('chats_fetched', _handleChatsFetched)
      ..on('update_unread_count', (data) => log('Unread count updated: $data'))
      ..on('getUserOnline', _handleUserOnline)
      ..on('getUserOffline', _handleUserOffline)
      ..onDisconnect((_) => log('Disconnected from socket'));
  }

  void _handleChatsFetched(dynamic data) {
    if (data is! List) {
      log('Invalid data format for chats_fetched');
      return;
    }

    setState(() {
      _chats = List<Map<String, dynamic>>.from(
        data.map((chat) => Map<String, dynamic>.from(chat)),
      );
      _filterChats();
    });
  }

  void _handleUserOnline(dynamic data) {
    final userId = data['userId'] as String?;
    if (userId != null) {
      setState(() => _onlineUsers.add(userId));
    }
  }

  void _handleUserOffline(dynamic data) {
    final userId = data['userId'] as String?;
    if (userId != null) {
      setState(() => _onlineUsers.remove(userId));
    }
  }

  void fetchChats(String userId) {
    socket.emit('fetch_chats', userId);
  }

  void markMessagesAsRead(String chatId, String userId) {
    socket.emit('mark_messages_read', {'chatId': chatId, 'userId': userId});
  }

  void _filterChats() {
    final query = controller.searchController.text.toLowerCase();
    setState(() {
      _filteredChats = query.isEmpty
          ? _chats
          : _chats.where((chat) => _matchesSearchQuery(chat, query)).toList();
    });
  }

  bool _matchesSearchQuery(Map<String, dynamic> chat, String query) {
    final otherUser = _getOtherUser(chat);
    if (otherUser == null) return false;

    final displayName = _getDisplayName(otherUser).toLowerCase();
    return displayName.contains(query);
  }

  Map<String, dynamic>? _getOtherUser(Map<String, dynamic> chat) {
    return chat['users']?.firstWhere(
      (u) => u['_id'] != currentUserId,
      orElse: () => null,
    );
  }

  String _getDisplayName(Map<String, dynamic> user) {
    final basicInfo = user['basicInfo'];
    return basicInfo?['displayName'] ??
        '${basicInfo?['firstName'] ?? ''} ${basicInfo?['lastName'] ?? ''}'
            .trim() ??
        'Unknown';
  }

  @override
  void dispose() {
    controller.searchController.removeListener(_filterChats);
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
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            _buildBlurredBackground(),
            _buildMessageContent(currentUserId!),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      centerTitle: true,
      height: 48.v,
      title: AppbarSubtitle(
        text: "lbl_inbox".tr,
        margin: EdgeInsets.only(left: 15.h),
      ),
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(AppRoutes.notification),
          padding: EdgeInsets.only(right: 5, left: 10),
          icon: _buildNotificationIcon(),
        ),
      ],
    );
  }

  Widget _buildNotificationIcon() {
    return Container(
      width: 35.0,
      height: 35.0,
      padding: const EdgeInsets.all(5),
      decoration: IconButtonStyleHelper.outline.copyWith(
        color: appTheme.whiteA700.withOpacity(0.6),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: CustomImageView(
        imagePath: ImageConstant.imgBell02,
        height: 8.0,
        width: 8.0,
      ),
    );
  }

  Widget _buildBlurredBackground() {
    return Positioned(
      left: 270,
      top: 50,
      child: ImageFiltered(
        imageFilter:
            ImageFilter.blur(sigmaX: 60, sigmaY: 60, tileMode: TileMode.decal),
        child: Container(
          width: 252,
          height: 252,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(126),
            color: appTheme.deepOrangeA20.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent(String currentUserId) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSearchField(),
          SizedBox(height: 29.v),
          _buildOnlineUsers(currentUserId),
          SizedBox(height: 9.v),
          _buildMessagesList(currentUserId),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.only(top: 25.v),
      child: CustomSearchView(
        width: 343.h,
        controller: controller.searchController,
        hintText: "lbl_search".tr,
      ),
    );
  }

  Widget _buildOnlineUsers(String currentUserId) {
    return SizedBox(
      height: 100.v,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filteredChats.length,
        separatorBuilder: (_, __) => SizedBox(width: 20.h),
        itemBuilder: (_, index) {
          final chat = _filteredChats[index];
          final otherUser = _getOtherUser(chat);

          if (!_isUserOnline(otherUser)) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChatItemWidget(
              profilePic: otherUser!['basicInfo']?['profilePic'] ?? '',
              displayName: _getUserDisplayName(otherUser),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessagesList(String currentUserId) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "lbl_recent_messages".tr,
              style: CustomTextStyles.titleMediumBold,
            ),
            SizedBox(height: 17.v),
            _buildChatList(currentUserId),
          ],
        ),
      ),
    );
  }

  bool _isUserOnline(Map<String, dynamic>? user) {
    return user != null && (user['online'] ?? false);
  }

  String _getUserDisplayName(Map<String, dynamic> user) {
    final basicInfo = user['basicInfo'];
    return basicInfo?['displayName'] ??
        '${basicInfo?["firstName"] ?? ""} ${basicInfo?["lastName"] ?? ""}' ??
        'Unknown';
  }

  Widget _buildChatList(String currentUserId) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _filteredChats.length,
        itemBuilder: (context, index) {
          final chat = _filteredChats[index];
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
