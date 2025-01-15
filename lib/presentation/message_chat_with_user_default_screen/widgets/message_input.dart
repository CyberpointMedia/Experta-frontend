import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController messageController;
  final Function sendMessage;

  const MessageInput({
    super.key,
    required this.messageController,
    required this.sendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: messageController,
              hintText: "Write a message...",
              hintStyle: CustomTextStyles.titleMediumBluegray300,
              textInputAction: TextInputAction.done,
              prefix: Container(
                margin: EdgeInsets.fromLTRB(15.h, 14.v, 10.h, 14.v),
                child: CustomImageView(
                  imagePath: ImageConstant.imgSmile,
                  color: Colors.transparent,
                  height: 12.adaptSize,
                  width: 12.adaptSize,
                ),
              ),
              prefixConstraints: BoxConstraints(maxHeight: 52.v),
              contentPadding: EdgeInsets.only(top: 16.v, right: 30.h, bottom: 16.v),
              borderDecoration: TextFormFieldStyleHelper.outlineGrayTL26,
              fillColor: appTheme.gray20002,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 6.h),
            child: CustomIconButton(
              height: 52.adaptSize,
              width: 52.adaptSize,
              padding: EdgeInsets.all(14.h),
              decoration: IconButtonStyleHelper.fillPrimaryTL24,
              onTap: () => sendMessage(),
              child: CustomImageView(
                imagePath: ImageConstant.imgIconSolidPaperAirplane,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
