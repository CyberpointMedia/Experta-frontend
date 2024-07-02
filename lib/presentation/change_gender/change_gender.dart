import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/change_gender/controller/change_gender_controller.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/custom_elevated_button.dart';
import 'package:experta/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';

class ChangeGender extends StatefulWidget {
  const ChangeGender({super.key});

  @override
  State<ChangeGender> createState() => _ChangeGenderState();
}

class _ChangeGenderState extends State<ChangeGender> {

  ChangeGenderController controller = Get.put(ChangeGenderController());
    bool isMaleSelected = false;
  bool isFemaleSelected = false;

  void _selectMale() {
    setState(() {
      isMaleSelected = true;
      isFemaleSelected = false;
    });
  }

  void _selectFemale() {
    setState(() {
       isFemaleSelected = true;
      isMaleSelected = false;
     
    });
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
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
            _bodyWidget(context),
          ],
        ),
      
      ),
    );
  }

  Padding _bodyWidget(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.only(top: 30,left: 15,right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Change Gender",style: theme.textTheme.headlineSmall!.copyWith(color: Colors.black,fontWeight: FontWeight.bold),),
                const Padding(
                  padding: EdgeInsets.only(top: 5,bottom: 15),
                  child: Text("This help us find your more relevant content. We won’t show it on your profile.",maxLines: 2),
                ),
                 Center( // Centering the Row horizontally and vertically
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Centering Row content
        children: [
          GestureDetector(
            onTap: _selectMale,
            child: Container(
               width: 144.0,
                    height: 144.0,
              padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 24.0),
              decoration: BoxDecoration(
                color: isMaleSelected ? Colors.white: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                
              ),
              child: Column(
                children: [
                  CustomImageView(
                    imagePath: isMaleSelected ? ImageConstant.male : ImageConstant.maleunselected,
                    width: 50.0,
                    height: 50.0,
                  ),
                  const SizedBox(width: 8.0), // Adding space between image and text
                  Text(
                    "Male",
                    style: TextStyle(
                      color: isMaleSelected ? Colors.black : Colors.black,
                      fontWeight: isMaleSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16.0), // Space between the two containers
          GestureDetector(
            onTap: _selectFemale,
            child: Container(
               width: 144.0,
                    height: 144.0,
              padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 24.0),
              decoration: BoxDecoration(
                color: isFemaleSelected ? Colors.white : Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                
              ),
              child: Column(
                children: [
                  CustomImageView(
                    imagePath: isFemaleSelected ? ImageConstant.female: ImageConstant.femele,
                    width: 50.0,
                    height: 50.0,
                  ),
                  const SizedBox(width: 8.0), 
                  Text(
                    "Female",
                    style: TextStyle(
                      color: isFemaleSelected ? Colors.black : Colors.black,
                      fontWeight: isFemaleSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),               
                const Spacer(),
                CustomElevatedButton(text: "Save",onPressed: () {
                  
                },
                
                margin: const EdgeInsets.all(10),
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
            }),);
  }

   onTapArrowLeft() {
    Get.back();
  }
}






