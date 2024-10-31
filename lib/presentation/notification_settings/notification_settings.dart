import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:flutter/material.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

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
                      const SizedBox(height: 0.0),

                      // "Push notification" text and "Pause all" switch in a single column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Push notification",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SwitchListTile(
                            title: const Text("Pause all"),
                            subtitle: const Text(
                              "Temporarily pause notifications",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            value: pauseAll,
                            onChanged: (bool value) {
                              setState(() {
                                pauseAll = value;
                              });
                            },
                            activeTrackColor:
                                Colors.green, // Entire button color when active
                            thumbColor:
                                WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return Colors.white; // White thumb when active
                              }
                              return Colors.grey; // Grey thumb when inactive
                            }),
                          ),
                        ],
                      ),

                      // Remaining toggles
                      SwitchListTile(
                        title: const Text("Post, Like and Comment"),
                        value: postLikeComment,
                        onChanged: (bool value) {
                          setState(() {
                            postLikeComment = value;
                          });
                        },
                        activeTrackColor: Colors.green,
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white;
                          }
                          return Colors.grey;
                        }),
                      ),
                      SwitchListTile(
                        title: const Text("Following and Followers"),
                        value: followingFollowers,
                        onChanged: (bool value) {
                          setState(() {
                            followingFollowers = value;
                          });
                        },
                        activeTrackColor: Colors.green,
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white;
                          }
                          return Colors.grey;
                        }),
                      ),
                      SwitchListTile(
                        title: const Text("Messages"),
                        value: messages,
                        onChanged: (bool value) {
                          setState(() {
                            messages = value;
                          });
                        },
                        activeTrackColor: Colors.green,
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white;
                          }
                          return Colors.grey;
                        }),
                      ),
                      SwitchListTile(
                        title: const Text("Calls"),
                        value: calls,
                        onChanged: (bool value) {
                          setState(() {
                            calls = value;
                          });
                        },
                        activeTrackColor: Colors.green,
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white;
                          }
                          return Colors.grey;
                        }),
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
