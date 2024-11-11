import 'dart:ui';
import 'package:experta/core/app_export.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<dynamic>> _notificationsFuture;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _notificationsFuture = fetchNotifications();
  }

  Future<List<dynamic>> fetchNotifications() async {
    try {
      final response = await apiService.fetchNotifications();
      return response['data']['notifications'];
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await apiService.markNotificationAsRead(notificationId);
      setState(() {
        _notificationsFuture = fetchNotifications();
      });
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      await apiService.markAllNotificationsAsRead();
      setState(() {
        _notificationsFuture = fetchNotifications();
      });
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
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
          Column(
            children: [
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _notificationsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final notifications = snapshot.data!;
                      if (notifications.isEmpty) {
                        return const Center(
                            child: Text('No notifications found'));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return GestureDetector(
                            onTap: () =>
                                markNotificationAsRead(notification['_id']),
                            child: _buildNotificationCard(notification),
                          );
                        },
                      );
                    }
                    return const Center(child: Text('No data'));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 60.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.mark_email_read),
          onPressed: markAllNotificationsAsRead,
          tooltip: 'Mark All as Read',
        ),
      ],
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Notifications"),
    );
  }

  Widget _buildNotificationCard(dynamic notification) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification['title'] ?? 'No title',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            notification['body'] ?? 'No body',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              notification['read']
                  ? const Icon(Icons.check_circle,
                      size: 18, color: Colors.green)
                  : const Icon(Icons.circle, size: 12, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                notification['read'] ? 'Read' : 'Unread',
                style: TextStyle(
                  fontSize: 12,
                  color: notification['read'] ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
