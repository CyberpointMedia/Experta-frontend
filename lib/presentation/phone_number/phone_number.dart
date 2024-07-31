import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/phone_number/controller/phone_number_controller.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:experta/widgets/custom_toast_message.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key});

  @override
  State<PhoneNumber> createState() => _ChangeDateOfBirthState();
}

class _ChangeDateOfBirthState extends State<PhoneNumber> {
   PhoneNumberController controller = Get.put(PhoneNumberController());
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
            Padding(
              padding: const EdgeInsets.only(top: 30,left: 15,right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Phone number",style: theme.textTheme.headlineSmall!.copyWith(color: Colors.black,fontWeight: FontWeight.bold),),
                  const Padding(
                    padding: EdgeInsets.only(top: 5,bottom: 15),
                    child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit",maxLines: 1),
                  ),
                  const Text("Phone Number"),
                  CustomTextFormField(
                    hintText: "1234567891",
                     hintStyle: CustomTextStyles.titleMediumBluegray300,
                textInputType: TextInputType.name,
                 controller: controller.textField1,
                focusNode: controller.focus1,
                    autofocus: false,
            
                  ),
                  const Spacer(),
                  CustomElevatedButton(text: "Save",onPressed: () {
                    if(controller.textField1.text.isNotEmpty){
                       CustomToast().showToast(context: context, message: "Date of birth changed Sucessfully", isSuccess: true);
                      Get.toNamed(AppRoutes.accountSetting);
                    }else{
                      CustomToast().showToast(context: context, message: "Please Fill the Date of birth", isSuccess: false);
                    }
                    
                  },
                  
                  margin: const EdgeInsets.all(10),
                  )
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
            }),);
  }

   onTapArrowLeft() {
    Get.back();
  }
}