import 'package:flutter/material.dart';
import 'package:experta/core/app_export.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final bool isOwnMessage;
  final String time;
  final List<dynamic> readBy;
  final Function buildFrame;

  const MessageBubble({
    super.key,
    required this.content,
    required this.isOwnMessage,
    required this.time,
    required this.readBy,
    required this.buildFrame,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isOwnMessage
            ? Padding(
                padding: EdgeInsets.only(
                    left: 40.h, right: 16.h, bottom: 10.v, top: 4.v),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.h, vertical: 14.v),
                      decoration: AppDecoration.fillPrimary.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderTL201,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 2.v),
                          Text(content,
                              style: CustomTextStyles.bodyLargeGray900),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.v),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 14.h),
                          child: buildFrame(time: time, readBy: readBy),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.only(left: 16.h, right: 142.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.h, vertical: 14.v),
                      decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderTL20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 2.v),
                          Text(content,
                              style: CustomTextStyles.bodyLargeGray900),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.v),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 14.h),
                          child: buildFrame(time: time, readBy: []),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
