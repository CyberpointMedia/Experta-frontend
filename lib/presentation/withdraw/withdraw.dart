import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/categoryDetails/category_details_screen.dart';
import 'package:experta/widgets/custom_icon_button.dart';

class WithdrawCreditsPage extends StatefulWidget {
  const WithdrawCreditsPage({super.key});

  @override
  State<WithdrawCreditsPage> createState() => _WithdrawCreditsPageState();
}

class _WithdrawCreditsPageState extends State<WithdrawCreditsPage> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: _buildAppBar(),
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
            children: [
              _buildAppBar(),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildEnterAmountSection(),
                      _buildAccountSettings(),
                      const Spacer(),
                      _buildSummitButton(),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
      title: AppbarSubtitleSix(text: "Withdraw Credits"),
    );
  }

  Widget _buildEnterAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Earn credits",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(width: 5), // Add some space between text and icon
            CustomImageView(
              imagePath: ImageConstant.imgInfoBlueGray300,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            CustomImageView(
                imagePath: ImageConstant.imgLayer1, height: 28, width: 28),
            const SizedBox(
                width: 8), // Add space between coin and entered amount
            Expanded(
              child: TextFormField(
                controller: _amountController,
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    // Trigger a rebuild to update the text near the equal sign
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text(
              "= ",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              "₹${_amountController.text}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.v),
            // Add the heading here
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 7),
              child: Text(
                "Withdrawal Modes",
                style: TextStyle(
                  fontSize: 18, // Set text size to 18
                  fontWeight: FontWeight.bold,
                  color: appTheme.gray900,
                ),
              ),
            ),
            SizedBox(
                height: 10.v), // Optional space between heading and container
            Container(
              decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                color: Colors.transparent,
                borderRadius: BorderRadiusStyle.roundedBorder20,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.addupi);
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
                          decoration: IconButtonStyleHelper.fillPrimary,
                          child: CustomImageView(
                            imagePath: ImageConstant.upi,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 15.h, top: 13.v, bottom: 10.v),
                          child: Text(
                            "Add UPI",
                            style: theme.textTheme.titleMedium!
                                .copyWith(color: appTheme.gray900),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 33,
                          width: 57,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.addupi);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appTheme.whiteA700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: BorderSide(color: appTheme.gray300),
                            ),
                            child: const Text(
                              "link",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.addbankaccount);
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
                            decoration: IconButtonStyleHelper.fillDeepPurple,
                            child: CustomImageView(
                              imagePath: ImageConstant.bank,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.h, top: 13.v, bottom: 10.v),
                            child: Text(
                              "Add Bank Account",
                              style: theme.textTheme.titleMedium!
                                  .copyWith(color: appTheme.gray900),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 33,
                            width: 57,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.addbankaccount);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appTheme.whiteA700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                side: BorderSide(color: appTheme.gray300),
                              ),
                              child: const Text(
                                "Add",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummitButton() {
    return const Padding(
      padding: EdgeInsets.only(top: 50, bottom: 20),
      child: CustomElevatedButton(text: 'sumit'),
    );
  }
}
