import 'package:flutter/material.dart';
import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_one.dart';
import 'package:experta/widgets/app_bar/appbar_title_image.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_button_one.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_image.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String displayName;
  final bool isConnected;
  final Function onTapArrowLeft;
  final Function onTapThreeThousand;
  final Function onTapVideo;
  final Function onTapPhone;

  const ChatAppBar({
    Key? key,
    required this.displayName,
    required this.isConnected,
    required this.onTapArrowLeft,
    required this.onTapThreeThousand,
    required this.onTapVideo,
    required this.onTapPhone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      height: 56.v,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h, top: 16.v, bottom: 16.v),
        onTap: onTapArrowLeft,
      ),
      title: Padding(
        padding: EdgeInsets.only(left: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppbarSubtitleOne(text: displayName),
                if (isConnected)
                  Padding(
                    padding: EdgeInsets.only(left: 8.h),
                    child: const Icon(Icons.circle, color: Colors.green, size: 12),
                  ),
                AppbarTitleImage(
                  imagePath: ImageConstant.imgVerified,
                  margin: EdgeInsets.only(left: 2.h, top: 3.v, bottom: 2.v),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        AppbarTrailingButtonOne(
          margin: EdgeInsets.only(left: 12.h, top: 8.v),
          onTap: onTapThreeThousand,
        ),
        AppbarTrailingImage(
          imagePath: ImageConstant.imgVideo,
          margin: EdgeInsets.fromLTRB(5.h, 18.v, 8.h, 10.v),
          onTap: onTapVideo,
        ),
        AppbarTrailingImage(
          imagePath: ImageConstant.imgPhoneGray900,
          margin: EdgeInsets.fromLTRB(10.h, 18.v, 24.h, 10.v),
          onTap: onTapPhone,
        ),
      ],
      styleType: Styled.bgFill_3,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.v);
}
