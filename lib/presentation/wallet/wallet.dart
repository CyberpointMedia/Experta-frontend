import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_six.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_buildAppBar(),_buildAccountSettings1(), _buildAccountSettings2()],
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
        title: AppbarSubtitleSix(text: "Wallet"));
        
  }
  
  Widget _buildAccountSettings1(){
    return Padding(
     padding: EdgeInsets.only(right: 16.h, left: 16, top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.3,
         padding: EdgeInsets.symmetric(
                                      horizontal: 15.h, vertical: 16.v),
                                decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                          color: Colors.white,
                          borderRadius: BorderRadiusStyle.roundedBorder20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Wallet Balance",textAlign: TextAlign.left,style: CustomTextStyles.labelLargeGray700,),
                              Text("₹ 3,000",textAlign: TextAlign.left,style: CustomTextStyles.bodyLargeBlack,),
const SizedBox(height: 16),
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Deposits",
          style: TextStyle(
            fontSize: 16,
             color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
      "₹ 1,500",
      style: TextStyle(
        fontSize: 16,
         color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    ),
      ],
    ),
    SizedBox(height: 4),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          " Earn",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
         Text(
      "₹ 500",
      style: TextStyle(
        fontSize: 16,
         color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    ),
      ],
    ),
  ],
), 
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top Up Button
                  Container(
                    
                    height: 50,
                    width: 140,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow, // Background color
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Define your action here
                        print("Top Up button pressed!");
                      },
                      child: Text(
                        'Top Up',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // Spacing between buttons
                  // Withdraw Button
                  Container(
                    height: 50,
                    width: 140,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Background color
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey), // Border color
                        ),
                      ),
                      onPressed: () {
                        // Define your action here
                        print("Withdraw button pressed!");
                      },
                      child: Text(
                        'Withdraw',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              ],
            ),
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
                          borderRadius: BorderRadiusStyle.roundedBorder20),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.changeUserName);
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
                                            IconButtonStyleHelper.fillGreenTL24,
                                        child: CustomImageView(
                                            imagePath:ImageConstant.transaction,)),
                                             
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.h,
                                            top: 13.v,
                                            bottom: 10.v),
                                        child: Text("Transactions",
                                            style: theme.textTheme.titleMedium!
                                                .copyWith(
                                                    color: appTheme.gray900))),
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
                            Get.toNamed(AppRoutes.bank);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.h, vertical: 16.v),
                                decoration:
                                    AppDecoration.fillOnPrimaryContainer,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomIconButton(
                                          height: 44.adaptSize,
                                          width: 44.adaptSize,
                                          padding: EdgeInsets.all(6.h),
                                          decoration: IconButtonStyleHelper
                                              .fillGrayTL22,
                                          child: CustomImageView(
                                            imagePath:ImageConstant.uservarification,
                                                
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.h,
                                              top: 13.v,
                                              bottom: 10.v),
                                          child: Text("KYC Verification",
                                              style: theme
                                                  .textTheme.titleMedium!
                                                  .copyWith(
                                                      color:
                                                          appTheme.gray900))),
                                      const Spacer(),
                                      CustomImageView(
                                          imagePath: ImageConstant
                                              .imgArrowRightGray900,
                                          height: 24.adaptSize,
                                          width: 24.adaptSize,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.v))
                                    ])),
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
                                decoration:
                                    AppDecoration.fillOnPrimaryContainer,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomIconButton(
                                          height: 44.adaptSize,
                                          width: 44.adaptSize,
                                          padding: EdgeInsets.all(6.h),
                                          decoration: IconButtonStyleHelper
                                              .fillGrayTL22,
                                          child: CustomImageView(
                                            imagePath:ImageConstant.reffer,
                                                
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.h,
                                              top: 13.v,
                                              bottom: 10.v),
                                          child: Text("Referral Program",
                                              style: theme
                                                  .textTheme.titleMedium!
                                                  .copyWith(
                                                      color:
                                                          appTheme.gray900))),
                                      const Spacer(),
                                      CustomImageView(
                                          imagePath: ImageConstant
                                              .imgArrowRightGray900,
                                          height: 24.adaptSize,
                                          width: 24.adaptSize,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.v))
                                    ])),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.phoneNumber);
                          },
                        child:Padding(
                      
                          padding: const EdgeInsets.only(top: 3),
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
                                        decoration:
                                            IconButtonStyleHelper.fillGreenTL24,
                                        child: CustomImageView(
                                          imagePath: ImageConstant.help,
                                         
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.h,
                                            top: 13.v,
                                            bottom: 10.v),
                                        child: Text("Need Help?",
                                            style: theme.textTheme.titleMedium!
                                                .copyWith(
                                                    color: appTheme.gray900))),
                                    const Spacer(),
                                    CustomImageView(
                                        imagePath:
                                            ImageConstant.imgArrowRightGray900,
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

