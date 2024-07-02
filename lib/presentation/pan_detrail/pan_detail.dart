import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/add_upi/controller/add_upi_controller.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_six.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/custom_elevated_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:experta/widgets/custom_toast_message.dart';
import 'package:flutter/material.dart';

class PanDetail extends StatefulWidget {
  const PanDetail({super.key});

  @override
  State<PanDetail> createState() => _PanDetailState();
}

class _PanDetailState extends State<PanDetail> {
  // Define separate controllers for each field
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController panNumberController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  // Define focus nodes for each field
  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode panNumberFocusNode = FocusNode();
  final FocusNode dateOfBirthFocusNode = FocusNode();

  AddUpiController controller = Get.put(AddUpiController());

  @override
  void dispose() {
    // Dispose controllers and focus nodes when the widget is disposed
    fullNameController.dispose();
    panNumberController.dispose();
    dateOfBirthController.dispose();
    fullNameFocusNode.dispose();
    panNumberFocusNode.dispose();
    dateOfBirthFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
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
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Full Name"),
                  CustomTextFormField(
                    hintText: "Naveen Verma",
                    hintStyle: CustomTextStyles.titleMediumBluegray300,
                    textInputType: TextInputType.name,
                    controller: fullNameController,
                    focusNode: fullNameFocusNode,
                    autofocus: false,
                  ),
                  const SizedBox(height: 20),
                  const Text("PAN Number"),
                  CustomTextFormField(
                    hintText: "AMAPV8100G",
                    hintStyle: CustomTextStyles.titleMediumBluegray300,
                    textInputType: TextInputType.text,
                    controller: panNumberController,
                    focusNode: panNumberFocusNode,
                    autofocus: false,
                  ),
                  const SizedBox(height: 20),
                  const Text("Date of Birth"),
                  CustomTextFormField(
                    hintText: "25/11/1992",
                    hintStyle: CustomTextStyles.titleMediumBluegray300,
                    textInputType: TextInputType.datetime,
                    controller: dateOfBirthController,
                    focusNode: dateOfBirthFocusNode,
                    autofocus: false,
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                    text: "Save",
                    onPressed: () {
                      if (fullNameController.text.isNotEmpty &&
                          panNumberController.text.isNotEmpty &&
                          dateOfBirthController.text.isNotEmpty) {
                        CustomToast().showToast(
                          context: context,
                          message: "Details saved successfully",
                          isSuccess: true,
                        );
                        Get.toNamed(AppRoutes.accountSetting);
                      } else {
                        CustomToast().showToast(
                          context: context,
                          message: "Please fill in all the fields",
                          isSuccess: false,
                        );
                      }
                    },
                    margin: const EdgeInsets.all(10),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      title: AppbarSubtitleSix(text: "PAN Details"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
