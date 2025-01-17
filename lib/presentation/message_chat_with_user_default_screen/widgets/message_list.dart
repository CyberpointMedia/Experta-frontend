import 'dart:ui';

import 'package:experta/core/app_export.dart';

class MessageList extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> groupedMessages;
  final Function convertToISTs;
  final Function buildFrame;
  final String currentUserId;

  const MessageList({
    super.key,
    required this.groupedMessages,
    required this.convertToISTs,
    required this.buildFrame,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: groupedMessages.keys.length,
      itemBuilder: (context, index) {
        final date = groupedMessages.keys.elementAt(index);
        final dateMessages = groupedMessages[date]!.reversed.toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: 24.v,
                      width: 137.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.0),
                        border:
                            Border.all(color: Colors.transparent, width: 1.0),
                      ),
                      child: Center(
                        child: Text(
                          date,
                          style: CustomTextStyles.bodySmallBluegray300.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ...dateMessages.map((msg) {
              final isOwnMessage = msg['sender']['_id'] == currentUserId;
              return Column(
                children: [
                  isOwnMessage
                      ? Padding(
                          padding: EdgeInsets.only(
                            left: 40.h,
                            right: 16.h,
                            bottom: 10.v,
                            top: 4.v,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.h,
                                  vertical: 14.v,
                                ),
                                decoration: AppDecoration.fillPrimary.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.customBorderTL201,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 2.v),
                                    Text(
                                      "${msg['content']}",
                                      style: CustomTextStyles.bodyLargeGray900,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5.v),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 14.h),
                                    child: buildFrame(
                                      time: convertToISTs(msg['createdAt']),
                                      readBy: msg['readBy'],
                                    ),
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
                                  horizontal: 15.h,
                                  vertical: 14.v,
                                ),
                                decoration: AppDecoration.fillOnPrimaryContainer
                                    .copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.customBorderTL20,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 2.v),
                                    Text(
                                      "${msg['content']}",
                                      style: CustomTextStyles.bodyLargeGray900,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5.v),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 14.h),
                                    child: buildFrame(
                                      time: convertToISTs(msg['createdAt']),
                                      readBy: [],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ],
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
