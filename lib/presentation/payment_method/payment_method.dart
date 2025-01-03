import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/add_upi/add_upi.dart';
import 'package:experta/presentation/payment_method/display_bank.dart';
import 'package:experta/widgets/custom_icon_button.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  bool isUpiAdded = false;
  bool isBankAdded = false;
  bool isBankVerified = false;
  String? upiDetails;
  Map<String, String>? bankDetails;
  ApiService apiService = ApiService();
  @override
  void initState() {
    super.initState();
    fetchPaymentMethodsStatus();
  }

  Future<void> fetchPaymentMethodsStatus() async {
    try {
      final data = await apiService.getPaymentMethodsStatus();
      setState(() {
        isUpiAdded = data['data']['upi']['isAdded'];
        isBankAdded = data['data']['bank']['isAdded'];
        isBankVerified = data['data']['bank']['isVerified'];
        if (isUpiAdded) {
          upiDetails = data['data']['upi']['details'];
        }
        if (isBankAdded) {
          bankDetails = {
            'accountNumber': data['data']['bank']['details']['accountNumber'],
            'ifsc': data['data']['bank']['details']['ifsc'],
          };
        }
      });
    } catch (e) {
      print('Error: $e');
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
            children: [_buildAppBar(), _buildAccountSettings()],
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
        title: AppbarSubtitleSix(text: "Payment Method"));
  }

  Widget _buildAccountSettings() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, top: 15),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.v),
                  Container(
                      decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                          color: Colors.transparent,
                          borderRadius: BorderRadiusStyle.roundedBorder20),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        GestureDetector(
                          onTap: () {
                            if (!isUpiAdded) {
                              Get.toNamed(AppRoutes.addupi);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AddUpi()));
                            }
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.h, vertical: 16.v),
                              decoration: AppDecoration.fillOnPrimaryContainer
                                  .copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.customBorderBL20),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconButton(
                                        height: 44.adaptSize,
                                        width: 44.adaptSize,
                                        padding: EdgeInsets.all(10.h),
                                        decoration:
                                            IconButtonStyleHelper.fillPrimary,
                                        child: CustomImageView(
                                          imagePath: ImageConstant.upi,
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.h,
                                            top: 13.v,
                                            bottom: 10.v),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    isUpiAdded
                                                        ? "UPI"
                                                        : "Add UPI",
                                                    style: theme
                                                        .textTheme.titleMedium!
                                                        .copyWith(
                                                            color: appTheme
                                                                .gray900)),
                                                (isUpiAdded)
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Container(
                                                          width: 45,
                                                          height: 16,
                                                          decoration: BoxDecoration(
                                                              color: appTheme
                                                                  .green100
                                                                  .withOpacity(
                                                                      0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2)),
                                                          child: Center(
                                                            child: Text(
                                                              "Verified",
                                                              style: theme
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .copyWith(
                                                                      color: appTheme
                                                                          .green500,
                                                                      fontSize:
                                                                          10),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                              ],
                                            ),
                                            isUpiAdded
                                                ? Text(
                                                    upiDetails ?? ''.toString(),
                                                    style: theme
                                                        .textTheme.titleSmall!
                                                        .copyWith(
                                                            fontSize: 14,
                                                            color: appTheme
                                                                .black900),
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        )),
                                    const Spacer(),
                                    CustomImageView(
                                        imagePath:
                                            ImageConstant.imgArrowRightGray900,
                                        height: 24.adaptSize,
                                        width: 24.adaptSize,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.v))
                                  ])),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!isBankAdded) {
                              Get.toNamed(AppRoutes.addbankaccount);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BankDetails()));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.h, vertical: 16.v),
                                decoration: AppDecoration.fillOnPrimaryContainer
                                    .copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.customBorderL20),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomIconButton(
                                          height: 44.adaptSize,
                                          width: 44.adaptSize,
                                          padding: EdgeInsets.all(10.h),
                                          decoration: IconButtonStyleHelper
                                              .fillDeepPurple,
                                          child: CustomImageView(
                                            imagePath: ImageConstant.bank,
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.h,
                                              top: 13.v,
                                              bottom: 10.v),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                      isBankAdded
                                                          ? "A/C - ${bankDetails?['ifsc']?.substring(0, 4) ?? ''} Bank"
                                                          : "Add Bank Account",
                                                      style: theme.textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              color: appTheme
                                                                  .gray900)),
                                                  (isBankAdded &&
                                                          isBankVerified)
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5),
                                                          child: Container(
                                                            width: 45,
                                                            height: 16,
                                                            decoration: BoxDecoration(
                                                                color: appTheme
                                                                    .green100
                                                                    .withOpacity(
                                                                        0.5),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            2)),
                                                            child: Center(
                                                              child: Text(
                                                                "Verified",
                                                                style: theme
                                                                    .textTheme
                                                                    .titleSmall!
                                                                    .copyWith(
                                                                        color: appTheme
                                                                            .green500,
                                                                        fontSize:
                                                                            10),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                ],
                                              ),
                                              (isBankAdded && isBankVerified)
                                                  ? Text(
                                                      "xxxxxxxxxxxx${bankDetails?['accountNumber']?.substring((bankDetails?['accountNumber']?.length ?? 0) - 4) ?? ''}",
                                                      style: theme
                                                          .textTheme.titleSmall!
                                                          .copyWith(
                                                              fontSize: 14,
                                                              color: appTheme
                                                                  .black900),
                                                    )
                                                  : const SizedBox.shrink()
                                            ],
                                          )),
                                      const Spacer(),
                                      CustomImageView(
                                          imagePath: ImageConstant
                                              .imgArrowRightGray900,
                                          height: 24.adaptSize,
                                          width: 24.adaptSize,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.v)),
                                    ])),
                          ),
                        ),
                      ]))
                ])));
  }

  onTapArrowLeft() {
    Get.back();
  }
}
