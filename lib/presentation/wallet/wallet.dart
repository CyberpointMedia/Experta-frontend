import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_icon_button.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool _isExpanded = false;
  int? balance;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWalletBalance();
  }

  Future<void> fetchWalletBalance() async {
    ApiService apiServices = ApiService();
    int? fetchedBalance = await apiServices.getWalletBalance();

    setState(() {
      balance = fetchedBalance;
      isLoading = false;
    });
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
            children: [
              _buildAppBar(),
              _buildAccountSettings1(),
              _buildAccountSettings2()
            ],
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
      title: AppbarSubtitleSix(text: "Wallet"),
    );
  }

  Widget _buildAccountSettings1() {
    return Padding(
      padding: EdgeInsets.only(right: 16.h, left: 16, top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 16.v),
        decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
          color: Colors.white,
          borderRadius: BorderRadiusStyle.roundedBorder20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Wallet Balance",
              textAlign: TextAlign.left,
              style: CustomTextStyles.labelLargeGray700,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomImageView(
                    imagePath: ImageConstant.imgLayer1, height: 28, width: 28),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : balance != null
                          ? Text(
                              balance.toString(),
                              textAlign: TextAlign.left,
                              style: CustomTextStyles.bodyLargeBlack
                                  .copyWith(fontWeight: FontWeight.bold),
                            )
                          : const Text('Failed to load balance',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.red)),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              height: _isExpanded ? 80 : 0,
              child: _isExpanded
                  ? Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Deposits",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: CustomImageView(
                                        imagePath:
                                            ImageConstant.imgInfoBlueGray300),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomImageView(
                                      imagePath: ImageConstant.imgLayer1),
                                  const Text(
                                    " 1,500",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(Icons.keyboard_arrow_right)
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Earned",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: CustomImageView(
                                        imagePath:
                                            ImageConstant.imgInfoBlueGray300),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomImageView(
                                      imagePath: ImageConstant.imgLayer1),
                                  const Text(
                                    " 500",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(Icons.keyboard_arrow_right)
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Top Up Button
                    SizedBox(
                      height: 55.adaptSize,
                      width: 135.adaptSize,
                      child: CustomElevatedButton(
                          buttonStyle: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // Define your action here
                            Get.toNamed(AppRoutes.topup);
                            print("Top Up button pressed!");
                          },
                          text: 'Top Up'),
                    ),
                    SizedBox(width: 40.adaptSize),
                    // Withdraw Button
                    SizedBox(
                      height: 55.adaptSize,
                      width: 135.adaptSize,
                      child: CustomElevatedButton(
                        buttonStyle: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: appTheme.gray300),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(AppRoutes.widraw);
                          print("Withdraw button pressed!");
                        },
                        text: "Withdraw",
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettings2() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(right: 16.h, left: 16, top: 10),
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
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.Transaction);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 16.v),
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
                          decoration: IconButtonStyleHelper.fillGreenTL24,
                          child: CustomImageView(
                            imagePath: ImageConstant.transaction,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 15.h, top: 13.v, bottom: 10.v),
                          child: Text(
                            "Transactions",
                            style: theme.textTheme.titleMedium!
                                .copyWith(color: appTheme.gray900),
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
                    Get.toNamed(AppRoutes.bank);
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
                            decoration: IconButtonStyleHelper.fillGrayTL22,
                            child: CustomImageView(
                              imagePath: ImageConstant.uservarification,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.h, top: 13.v, bottom: 10.v),
                            child: Text(
                              "KYC Verification",
                              style: theme.textTheme.titleMedium!
                                  .copyWith(color: appTheme.gray900),
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
                            decoration: IconButtonStyleHelper.fillGrayTL22,
                            child: CustomImageView(
                              imagePath: ImageConstant.reffer,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.h, top: 13.v, bottom: 10.v),
                            child: Text(
                              "Referral Program",
                              style: theme.textTheme.titleMedium!
                                  .copyWith(color: appTheme.gray900),
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
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.phoneNumber);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.h, vertical: 16.v),
                      decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderL20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconButton(
                            height: 44.adaptSize,
                            width: 44.adaptSize,
                            padding: EdgeInsets.all(10.h),
                            decoration: IconButtonStyleHelper.fillGreenTL24,
                            child: CustomImageView(
                              imagePath: ImageConstant.help,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.h, top: 13.v, bottom: 10.v),
                            child: Text(
                              "Need Help?",
                              style: theme.textTheme.titleMedium!
                                  .copyWith(color: appTheme.gray900),
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
              ]),
            )
          ],
        ),
      ),
    );
  }

  onTapArrowLeft() {
    Get.back();
  }
}
