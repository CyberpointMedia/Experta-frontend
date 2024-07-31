import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:experta/presentation/notification/notification_controller.dart';
import 'package:experta/theme/theme_helper.dart';
import 'package:experta/core/utils/size_utils.dart';

// ignore_for_file: must_be_immutable

class NotificationScreen extends GetWidget<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray20002,
        // appBar: _buildAppBar(),
        body: SizedBox(
          height: 626.v,
          width: 375.adaptSize,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              _buildNotificationList(),
              Column(
                children: [_buildAppBar(context), _buildTodayColumn()],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget

  PreferredSizeWidget _buildAppBar(context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 50,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leadingWidth: 40,
      leading: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          top: 1,
          bottom: 1,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: SizedBox(
            height: 24.v,
            width: 24.adaptSize,
            child: SvgPicture.asset("assets/images/img_arrow_left.svg"),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          "Notifications",
          style: theme.textTheme.titleLarge!,
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return Positioned(
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
    );
  }

  Widget _buildTodayColumn() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          top: 35,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today",
              style:
                  theme.textTheme.headlineLarge?.copyWith(fontSize: 16.fSize),
            ),
            SizedBox(
              height: 13.v,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    "assets/images/img_ellipse_133.png",
                    height: 48.v,
                    width: 48.adaptSize,
                  ),
                ),
                Container(
                  width: 199.adaptSize,
                  margin: const EdgeInsets.only(
                    left: 15,
                    top: 4,
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Aniket Thakur",
                          style: theme.textTheme.titleMedium!,
                        ),
                        const TextSpan(
                          text: " ",
                        ),
                        TextSpan(
                          text: "liked your post. ",
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: appTheme.gray900),
                        ),
                        TextSpan(
                          text: "1hr ago",
                          style: theme.textTheme.bodyLarge!,
                        )
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  "assets/images/img_mask_group.png",
                  height: 48.v,
                  width: 48.adaptSize,
                )
              ],
            ),
            SizedBox(
              height: 30.v,
            ),
            Text(
              "Last 7 days",
              style:
                  theme.textTheme.headlineLarge?.copyWith(fontSize: 16.fSize),
            )
          ],
        ),
      ),
    );
  }
}
