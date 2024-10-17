import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';

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

class MessageListShimmer extends StatelessWidget {
  const MessageListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.maxFinite,
            child: Column(
              children: [
                CustomElevatedButton(
                    height: 24.v,
                    width: 137.h,
                    text: "msg_wednesday_jan_17th".tr,
                    margin: EdgeInsets.only(top: 20.v),
                    buttonStyle: CustomButtonStyles.fillOnPrimaryContainer,
                    buttonTextStyle: CustomTextStyles.bodySmallBluegray300,
                    alignment: Alignment.topCenter),
                Padding(
                    padding: EdgeInsets.only(
                        left: 188.h, right: 20.h, bottom: 10.v, top: 14.v),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.h, vertical: 14.v),
                              decoration: AppDecoration.fillPrimary.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.customBorderTL201),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 2.v),
                                    Text("msg_hey_how_s_it_going".tr,
                                        style:
                                            CustomTextStyles.bodyLargeGray900)
                                  ])),
                          SizedBox(height: 5.v),
                          Padding(
                              padding: EdgeInsets.only(left: 14.h),
                              child: _buildFrame(time: "lbl_09_32_pm".tr))
                        ])),
                Padding(
                    padding: EdgeInsets.only(left: 16.h, right: 142.h),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.h, vertical: 14.v),
                              decoration: AppDecoration.fillOnPrimaryContainer
                                  .copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.customBorderTL20),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 2.v),
                                    Text("msg_not_much_just_chilling".tr,
                                        style:
                                            CustomTextStyles.bodyLargeGray900)
                                  ])),
                          SizedBox(height: 5.v),
                          Padding(
                              padding: EdgeInsets.only(left: 14.h),
                              child: _buildFrame(time: "lbl_09_32_pm".tr))
                        ])),
                Container(
                    margin: EdgeInsets.only(left: 116.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 13.v),
                    decoration: AppDecoration.fillPrimary.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderTL201),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 2.v),
                          SizedBox(
                              width: 193.h,
                              child: Text("msg_same_here_anything".tr,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomTextStyles.bodyLargeGray900))
                        ])),
                SizedBox(height: 5.v),
                Padding(
                    padding: EdgeInsets.only(left: 130.h),
                    child: _buildFrame(time: "lbl_09_32_pm".tr)),
                SizedBox(height: 14.v),
                Container(
                    width: 253.h,
                    margin: EdgeInsets.only(right: 90.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 13.v),
                    decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderTL20),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 2.v),
                          Container(
                              width: 195.h,
                              margin: EdgeInsets.only(right: 27.h),
                              child: Text("msg_nah_just_the_usual".tr,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomTextStyles.bodyLargeGray900))
                        ])),
                SizedBox(height: 5.v),
                Padding(
                    padding: EdgeInsets.only(left: 14.h),
                    child: _buildFrame(time: "lbl_09_32_pm".tr)),
                Container(
                    margin: EdgeInsets.only(left: 87.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 13.v),
                    decoration: AppDecoration.fillPrimary.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderTL201),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 2.v),
                          SizedBox(
                              width: 224.h,
                              child: Text("msg_haha_i_feel_that".tr,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomTextStyles.bodyLargeGray900))
                        ])),
                SizedBox(height: 5.v),
                Padding(
                    padding: EdgeInsets.only(left: 101.h),
                    child: _buildFrame(time: "lbl_09_32_pm".tr)),
                SizedBox(height: 5.v),
                // _buildMessageChatWith(),
                const Spacer(),
                _buildNinetyNine()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNinetyNine() {
    return Container(
        margin: EdgeInsets.only(bottom: 5.v),
        // decoration: AppDecoration.outlineBlack90001,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Divider(),
          Padding(
              padding: EdgeInsets.only(left: 16.h, top: 6.v, right: 16.h),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                    child: CustomTextFormField(
                        hintText: "msg_write_a_message".tr,
                        hintStyle: CustomTextStyles.titleMediumBluegray300,
                        textInputAction: TextInputAction.done,
                        prefix: Container(
                            margin: EdgeInsets.fromLTRB(15.h, 14.v, 10.h, 14.v),
                            child: CustomImageView(
                                imagePath: ImageConstant.imgSmile,
                                height: 24.adaptSize,
                                width: 24.adaptSize)),
                        prefixConstraints: BoxConstraints(maxHeight: 52.v),
                        contentPadding: EdgeInsets.only(
                            top: 16.v, right: 30.h, bottom: 16.v),
                        borderDecoration:
                            TextFormFieldStyleHelper.outlineGrayTL26,
                        fillColor: appTheme.gray20002)),
                Padding(
                    padding: EdgeInsets.only(left: 6.h),
                    child: CustomIconButton(
                        height: 52.adaptSize,
                        width: 52.adaptSize,
                        padding: EdgeInsets.all(14.h),
                        decoration: IconButtonStyleHelper.fillPrimaryTL24,
                        child: CustomImageView(
                            imagePath:
                                ImageConstant.imgIconSolidPaperAirplane)))
              ]))
        ]));
  }

  /// Common widget
  Widget _buildFrame({required String time}) {
    return Row(children: [
      Text(time,
          style: CustomTextStyles.bodySmallBluegray300
              .copyWith(color: appTheme.blueGray300)),
      CustomImageView(
          imagePath: ImageConstant.imgDoubleCheck,
          height: 14.adaptSize,
          width: 14.adaptSize,
          margin: EdgeInsets.only(left: 4.h))
    ]);
  }
}
