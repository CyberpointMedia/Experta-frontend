import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/pan_detrail/pan_detail.dart';
import 'package:experta/presentation/verify_account/Models/verify_account_model.dart';
import 'package:experta/presentation/verify_account/face_live.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';

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
  KYCResponse? kycData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKYCData();
  }

  Future<void> fetchKYCData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService().getKYCStatus();
      if (response != null) {
        setState(() {
          kycData = response;
        });
      }
    } catch (e) {
      print('Error fetching KYC data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_buildAppBar(), _buildVerifyAccount()],
          )
        ],
      ),
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  String maskPanNumber(String panNumber) {
    if (panNumber.length >= 10) {
      return "XXXXXXXX${panNumber.substring(8)}";
    }
    return panNumber; // return the original if it's less than 10 characters
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
    if (isLoading) {
      return const CircularProgressIndicator();
    }

    if (kycData == null) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(right: 16.h, left: 16, top: 15),
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
                        Get.toNamed(AppRoutes.changeUserName);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.h, vertical: 16.v),
                        decoration:
                            AppDecoration.fillOnPrimaryContainer.copyWith(
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
                              child: CustomImageView(
                                  imagePath: ImageConstant.user),
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
                        padding: const EdgeInsets.only(top: 1),
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
                                decoration:
                                    IconButtonStyleHelper.fillDeepPurple,
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
                        padding: const EdgeInsets.only(top: 1),
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
                    // GestureDetector(
                    //   onTap: () {
                    //     //Get.toNamed(AppRoutes.adhardetail);
                    //     showAadhaarCardVerificationDialog();
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 1),
                    //     child: Container(
                    //       padding: EdgeInsets.symmetric(
                    //           horizontal: 15.h, vertical: 16.v),
                    //       decoration: AppDecoration.fillOnPrimaryContainer,
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           CustomIconButton(
                    //             height: 44.adaptSize,
                    //             width: 44.adaptSize,
                    //             padding: EdgeInsets.all(10.h),
                    //             decoration: IconButtonStyleHelper.fillOrange,
                    //             child: CustomImageView(
                    //                 imagePath: ImageConstant.pancard),
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsets.only(
                    //                 left: 15.h, top: 13.v, bottom: 10.v),
                    //             child: Text(
                    //               "Aadhaar Card",
                    //               style: theme.textTheme.titleMedium!.copyWith(
                    //                 color: appTheme.gray900,
                    //               ),
                    //             ),
                    //           ),
                    //           const Spacer(),
                    //           CustomImageView(
                    //             imagePath: ImageConstant.imgArrowRightGray900,
                    //             height: 24.adaptSize,
                    //             width: 24.adaptSize,
                    //             margin: EdgeInsets.symmetric(vertical: 10.v),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const FaceDetectorView()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1),
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
                                  "Face Liveliness",
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
                        padding: const EdgeInsets.only(top: 1),
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
                                decoration: IconButtonStyleHelper.fillOnPrimaryContainer,
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
    print(kycData!.userData!.phoneNo);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(right: 16.h, left: 16, top: 15),
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
                    onTap: () {},
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
                            padding: EdgeInsets.all(10.h),
                            decoration: IconButtonStyleHelper.fillGray,
                            child:
                                CustomImageView(imagePath: ImageConstant.phone),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Mobile Number",
                                      style:
                                          (kycData!.userData!.phoneNo != null)
                                              ? theme.textTheme.titleMedium!
                                                  .copyWith(
                                                  fontSize: 12,
                                                  color: appTheme.gray400,
                                                )
                                              : theme.textTheme.titleMedium!
                                                  .copyWith(
                                                  color: appTheme.black900,
                                                ),
                                    ),
                                    (kycData!.userData!.phoneNo != null)
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Container(
                                              width: 45,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                  color: appTheme.green100
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(2)),
                                              child: Center(
                                                child: Text(
                                                  "Verified",
                                                  style: theme
                                                      .textTheme.titleSmall!
                                                      .copyWith(
                                                          color:
                                                              appTheme.green500,
                                                          fontSize: 10),
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                                Text(
                                  kycData!.userData!.phoneNo.toString(),
                                  style: theme.textTheme.titleSmall!.copyWith(
                                      fontSize: 14, color: appTheme.black900),
                                ),
                              ],
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
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1),
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
                              decoration: IconButtonStyleHelper.fillOrange,
                              child: CustomImageView(
                                  imagePath: ImageConstant.email),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 15.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Email Address",
                                        style: (kycData!.userData!.email !=
                                                null)
                                            ? theme.textTheme.titleMedium!
                                                .copyWith(
                                                fontSize: 12,
                                                color: appTheme.gray400,
                                              )
                                            : theme.textTheme.titleMedium!
                                                .copyWith(
                                                color: appTheme.black900,
                                              ),
                                      ),
                                      (kycData!.userData!.email != null)
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Container(
                                                width: 45,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                    color: appTheme.green100
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                                child: Center(
                                                  child: Text(
                                                    "Verified",
                                                    style: theme
                                                        .textTheme.titleSmall!
                                                        .copyWith(
                                                            color: appTheme
                                                                .green500,
                                                            fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                  Text(
                                    kycData!.userData!.email.toString(),
                                    style: theme.textTheme.titleSmall!.copyWith(
                                        fontSize: 14, color: appTheme.black900),
                                  ),
                                ],
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
  if (kycData!.panVerification!.verificationStatus == false) {
    _showPANVerificationDialog();
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PanDetail(name: '', panno: '', dob: '',), // Replace NextPage with your actual page class
      ),
    );
  }
},
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1),
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
                              decoration: IconButtonStyleHelper.fillGreenTL24,
                              child: CustomImageView(
                                  imagePath: ImageConstant.panset),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.h, top: 13.v, bottom: 10.v),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Pan Card",
                                        style: (kycData!.panVerification!
                                                    .verificationStatus ==
                                                true)
                                            ? theme.textTheme.titleMedium!
                                                .copyWith(
                                                fontSize: 12,
                                                color: appTheme.gray400,
                                              )
                                            : theme.textTheme.titleMedium!
                                                .copyWith(
                                                color: appTheme.black900,
                                              ),
                                      ),
                                      (kycData!.panVerification!
                                                  .verificationStatus ==
                                              true)
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Container(
                                                width: 45,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                    color: appTheme.green100
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                                child: Center(
                                                  child: Text(
                                                    "Verified",
                                                    style: theme
                                                        .textTheme.titleSmall!
                                                        .copyWith(
                                                            color: appTheme
                                                                .green500,
                                                            fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                  Text(
                                    maskPanNumber(kycData!
                                        .panVerification!.panNumber
                                        .toString()),
                                    style: theme.textTheme.titleSmall!.copyWith(
                                        fontSize: 14, color: appTheme.black900),
                                  ),
                                ],
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
                  // GestureDetector(
                  //   onTap: () {
                  //     //Get.toNamed(AppRoutes.adhardetail);
                  //     showAadhaarCardVerificationDialog();
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top: 1),
                  //     child: Container(
                  //       padding: EdgeInsets.symmetric(
                  //           horizontal: 15.h, vertical: 16.v),
                  //       decoration: AppDecoration.fillOnPrimaryContainer,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           CustomIconButton(
                  //             height: 44.adaptSize,
                  //             width: 44.adaptSize,
                  //             padding: EdgeInsets.all(10.h),
                  //             decoration: IconButtonStyleHelper.fillOrange,
                  //             child: CustomImageView(
                  //                 imagePath: ImageConstant.pancard),
                  //           ),
                  //           Padding(
                  //             padding: EdgeInsets.only(
                  //                 left: 15.h, top: 13.v, bottom: 10.v),
                  //             child: Text(
                  //               "Aadhaar Card",
                  //               style: theme.textTheme.titleMedium!.copyWith(
                  //                 color: appTheme.gray900,
                  //               ),
                  //             ),
                  //           ),
                  //           const Spacer(),
                  //           CustomImageView(
                  //             imagePath: ImageConstant.imgArrowRightGray900,
                  //             height: 24.adaptSize,
                  //             width: 24.adaptSize,
                  //             margin: EdgeInsets.symmetric(vertical: 10.v),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      (kycData!.faceLiveness!.status == true)
                          ? null
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const FaceDetectorView()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1),
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
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.h, top: 13.v, bottom: 10.v),
                                  child: Text(
                                    "Face Liveliness",
                                    style:
                                        theme.textTheme.titleMedium!.copyWith(
                                      color: appTheme.gray900,
                                    ),
                                  ),
                                ),
                                (kycData!.faceLiveness!.status == true)
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Container(
                                          width: 45,
                                          height: 16,
                                          decoration: BoxDecoration(
                                              color: appTheme.green100
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(2)),
                                          child: Center(
                                            child: Text(
                                              "Verified",
                                              style: theme.textTheme.titleSmall!
                                                  .copyWith(
                                                      color: appTheme.green500,
                                                      fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
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
                      padding: const EdgeInsets.only(top: 1),
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
    final ApiService apiService = ApiService();

    Future<void> verifyPAN() async {
      final panNumber = panController.text.trim();
      try {
        final responseData =
            await apiService.verifyPAN(panNumber.toUpperCase());

        if (responseData['status'] == 'success') {
          final clientData = responseData['data']['data'];
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Verification Successful"),
                content: Text(
                    "Hello ${clientData['full_name']}, your PAN has been verified successfully."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          showErrorDialog("PAN verification failed. Please try again.");
        }
      } catch (e) {
        showErrorDialog("An error occurred: ${e.toString()}");
      }
    }

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CustomIconButton(
                      height: 70,
                      width: 70,
                      padding: const EdgeInsets.all(10),
                      decoration: IconButtonStyleHelper.fillGreenTL245,
                      child: CustomImageView(imagePath: ImageConstant.pan),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "PAN Verification",
                      style: TextStyle(fontSize: 22, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "As per regulations, it is mandatory to verify your PAN details.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 150,
                    height: 32.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: appTheme.panCol, width: 1.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flash_on, color: appTheme.panCol, size: 14),
                        const SizedBox(width: 5),
                        Text(
                          "Takes less than 5 secs",
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: appTheme.panCol,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Enter PAN number",
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: appTheme.blueGray300,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: panController,
                    autofocus: false,
                    hintText: "Enter Your 10 Digit PAN Number",
                    hintStyle: theme.textTheme.titleSmall!.copyWith(
                      color: appTheme.blueGray300,
                      fontSize: 14,
                    ),
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
                        verifyPAN();
                      }
                    },
                    text: "Verify",
                  ),
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
                        fontSize: 22,
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
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.amber,
                        width: 1.0,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flash_on, color: Colors.yellow),
                        SizedBox(
                          width: 5,
                        ),
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
