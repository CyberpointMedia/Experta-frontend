import 'dart:ui';
import 'package:experta/core/app_export.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Toggle switches
  bool pauseAll = false;
  bool postLikeComment = true;
  bool followingFollowers = true;
  bool messages = true;
  bool calls = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      
                      const SizedBox(height: 16.0),

                      // Push Notification Section
                      _buildToggleRow(
                        title: "Pause all",
                        subtitle: "Temporarily pause notifications",
                        value: pauseAll,
                        onChanged: (bool value) {
                          setState(() {
                            pauseAll = value;
                          });
                        },
                      ),

                      // Post, Like, and Comment
                      _buildToggleRow(
                        title: "Post, Like and Comment",
                        value: postLikeComment,
                        onChanged: (bool value) {
                          setState(() {
                            postLikeComment = value;
                          });
                        },
                      ),

                      // Following and Followers
                      _buildToggleRow(
                        title: "Following and Followers",
                        value: followingFollowers,
                        onChanged: (bool value) {
                          setState(() {
                            followingFollowers = value;
                          });
                        },
                      ),

                      // Messages
                      _buildToggleRow(
                        title: "Messages",
                        value: messages,
                        onChanged: (bool value) {
                          setState(() {
                            messages = value;
                          });
                        },
                      ),

                      // Calls
                      _buildToggleRow(
                        title: "Calls",
                        value: calls,
                        onChanged: (bool value) {
                          setState(() {
                            calls = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
         Switch(
  value: value,
  onChanged: onChanged,
  activeColor: Colors.white, // White thumb when active
  activeTrackColor: Colors.green, // Green track when active
  inactiveThumbColor: Colors.grey, // Grey thumb when inactive
  inactiveTrackColor: Colors.grey.shade300, // Light grey track when inactive
),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapArrowLeft();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Notifications"),
    );
  }

  void onTapArrowLeft() {
    Navigator.pop(context);
  }
}
