import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/theme/theme_helper.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_six.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';

class EditProfessionalInfo extends StatefulWidget {
  const EditProfessionalInfo({super.key});

  @override
  State<EditProfessionalInfo> createState() => _EditProfessionalInfoState();
}

class _EditProfessionalInfoState extends State<EditProfessionalInfo> {
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_buildAppBar(), _buildBody()],
          )
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
            }),
        centerTitle: true,
        title: AppbarSubtitleSix(text: "Professional Info"));
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.v),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              "Your Profession",
              style: CustomTextStyles.bodyLargeBlack90001,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  onTapArrowLeft() {
    Get.back();
  }
}
