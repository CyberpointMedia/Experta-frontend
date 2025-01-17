import 'dart:ui';

import 'package:experta/core/app_export.dart';
//import 'package:experta/widgets/custom_elevated_button.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
//import 'package:experta/widgets/custom_outlined_button.dart';

class VerifyAccount extends StatefulWidget {
  const VerifyAccount({super.key});

  @override
  State<VerifyAccount> createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController panController = TextEditingController();
  // ignore: non_constant_identifier_names
  final TextEditingController AadharCardController = TextEditingController();

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_buildAppBar(), _buildVerifyAccount()],
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
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "VerifyAccount"),
    );
  }

  Widget _buildVerifyAccount() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(right: 16.h, left: 16, top: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.v),
            Container(
              decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                color: Colors.transparent,
                borderRadius: BorderRadiusStyle.roundedBorder20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Get.toNamed(AppRoutes.changeUserName);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.h, vertical: 16.v),
                      decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderBL20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconButton(
                            height: 44.adaptSize,
                            width: 44.adaptSize,
                            padding: EdgeInsets.all(6.h),
                            decoration: IconButtonStyleHelper.fillPrimary,
                            child:
                                CustomImageView(imagePath: ImageConstant.user),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.h, top: 13.v, bottom: 10.v),
                            child: Text(
                              "U9465288001",
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: appTheme.gray900,
                              ),
                            ),
                          ),
                          const Spacer(),
                          CustomImageView(
                            imagePath: ImageConstant.imgArrowRightGray900,
                            height: 24.adaptSize,
                            width: 24.adaptSize,
                            margin: EdgeInsets.symmetric(vertical: 10.v),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.changeDateOfBirth);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.h, vertical: 16.v),
                        decoration: AppDecoration.fillOnPrimaryContainer,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              height: 44.adaptSize,
                              width: 44.adaptSize,
                              padding: EdgeInsets.all(6.h),
                              decoration: IconButtonStyleHelper.fillDeepPurple,
                              child: CustomImageView(
                                  imagePath: ImageConstant.birthday),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.h, top: 13.v, bottom: 10.v),
                              child: Text(
                                "Email Address",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: appTheme.gray900,
                                ),
                              ),
                            ),
                            const Spacer(),
                            CustomImageView(
                              imagePath: ImageConstant.imgArrowRightGray900,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              margin: EdgeInsets.symmetric(vertical: 10.v),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showPANVerificationDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.h, vertical: 16.v),
                        decoration: AppDecoration.fillOnPrimaryContainer,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              height: 44.adaptSize,
                              width: 44.adaptSize,
                              padding: EdgeInsets.all(6.h),
                              decoration: IconButtonStyleHelper.fillGreenTL24,
                              child: CustomImageView(
                                  imagePath: ImageConstant.card),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.h, top: 13.v, bottom: 10.v),
                              child: Text(
                                "Pan Card",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: appTheme.gray900,
                                ),
                              ),
                            ),
                            const Spacer(),
                            CustomImageView(
                              imagePath: ImageConstant.imgArrowRightGray900,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              margin: EdgeInsets.symmetric(vertical: 10.v),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //Get.toNamed(AppRoutes.adhardetail);
                      showAadhaarCardVerificationDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.h, vertical: 16.v),
                        decoration: AppDecoration.fillOnPrimaryContainer,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              height: 44.adaptSize,
                              width: 44.adaptSize,
                              padding: EdgeInsets.all(10.h),
                              decoration: IconButtonStyleHelper.fillOrange,
                              child: CustomImageView(
                                  imagePath: ImageConstant.pancard),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.h, top: 13.v, bottom: 10.v),
                              child: Text(
                                "Aadhaar Card",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: appTheme.gray900,
                                ),
                              ),
                            ),
                            const Spacer(),
                            CustomImageView(
                              imagePath: ImageConstant.imgArrowRightGray900,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              margin: EdgeInsets.symmetric(vertical: 10.v),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.paymentmethod);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.h, vertical: 16.v),
                        decoration:
                            AppDecoration.fillOnPrimaryContainer.copyWith(
                          borderRadius: BorderRadiusStyle.customBorderL20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              height: 44.adaptSize,
                              width: 44.adaptSize,
                              padding: EdgeInsets.all(10.h),
                              decoration: IconButtonStyleHelper.fillGrayTL22,
                              child: CustomImageView(
                                  imagePath: ImageConstant.bank),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.h, top: 13.v, bottom: 10.v),
                              child: Text(
                                "Payment Method",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: appTheme.gray900,
                                ),
                              ),
                            ),
                            const Spacer(),
                            CustomImageView(
                              imagePath: ImageConstant.imgArrowRightGray900,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              margin: EdgeInsets.symmetric(vertical: 10.v),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showPANVerificationDialog() {
    final formKey = GlobalKey<FormState>();
    final TextEditingController panController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align to the left
                children: [
                  Center(
                    // Center the CircleAvatar and Icon
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green.shade100,
                      child: const Icon(Icons.credit_card,
                          color: Colors.green, size: 30),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    // Center the PAN Verification text
                    child: Text(
                      "PAN Verification",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "As per regulations, it is mandatory to verify your PAN details.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity, // Adjust width as needed
                    height: 40.0, // Adjust height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.amber, width: 1.0),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flash_on, color: Colors.amber),
                        SizedBox(width: 5),
                        Text("Takes less than 5 secs"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Enter PAN number", // Example PAN number
                    style: TextStyle(
                      fontSize:
                          14, // Adjust the font size to match the text style above
                    ),
                  ),
                  const SizedBox(
                      height:
                          8), // Add some space between the PAN number and the TextFormField
                  CustomTextFormField(
                    controller: panController,
                    autofocus: false,
                    hintText: "Enter Your 10 Digit PAN Number",
                    hintStyle: CustomTextStyles.titleMediumGray400,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your PAN number';
                      }
                      if (value.length != 10) {
                        return 'PAN number must be 10 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Add your verification logic here
                        }
                      },
                      text: "Verify"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showAadhaarCardVerificationDialog() {
    final formKey = GlobalKey<FormState>();
    final TextEditingController aadhaarCardController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green.shade100,
                      child: const Icon(Icons.credit_card,
                          color: Colors.green, size: 30),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "Aadhaar Verification",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "As per regulations, it is mandatory to verify your Aadhaar details.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity, // Adjust width as needed
                    height: 40.0, // Adjust height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.amber, width: 1.0),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flash_on, color: Colors.yellow),
                        SizedBox(width: 5),
                        Text("Takes less than 5 secs"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Enter Aadhaar number",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: aadhaarCardController,
                    autofocus: false,
                    hintText: "Enter Your 12 Digit Aadhaar Number",
                    hintStyle: CustomTextStyles.titleMediumGray400,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your PAN number';
                      }
                      if (value.length != 12) {
                        return 'PAN number must be 12characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Add your verification logic here
                        }
                      },
                      text: "Verify"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
