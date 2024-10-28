import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/add_upi/controller/add_upi_controller.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:experta/widgets/custom_toast_message.dart';

class AddUpi extends StatefulWidget {
  const AddUpi({super.key});

  @override
  State<AddUpi> createState() => _AddUpiState();
}

class _AddUpiState extends State<AddUpi> {
  AddUpiController controller = Get.put(AddUpiController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Positioned(
              left: 270.adaptSize,
              top: 50.adaptSize,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  tileMode: TileMode.decal,
                  sigmaX: 60,
                  sigmaY: 60,
                ),
                child: Align(
                  child: SizedBox(
                    width: 252.adaptSize,
                    height: 252.adaptSize,
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
              padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text("Change User Name",style: theme.textTheme.headlineSmall!.copyWith(color: Colors.black,fontWeight: FontWeight.bold),),
                  const Text("UPI ID"),
                  SizedBox(
                    height: 6.adaptSize,
                  ),
                  CustomTextFormField(
                    hintText: "Enter your UPI ID",
                    hintStyle: CustomTextStyles.titleMediumBluegray300,
                    textInputType: TextInputType.name,
                    controller: controller.textField1,
                    focusNode: controller.focus1,
                    autofocus: false,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 6, bottom: 15),
                    child: Text("Example: username@bankname", maxLines: 1),
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                    text: "Save",
                    onPressed: () {
                      if (controller.textField1.text.isNotEmpty) {
                        CustomToast().showToast(
                            context: context,
                            message: "User Name changed Sucessfully",
                            isSuccess: true);
                        Get.toNamed(AppRoutes.accountSetting);
                      } else {
                        CustomToast().showToast(
                            context: context,
                            message: "Please Fill the user name",
                            isSuccess: false);
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
            }),
        centerTitle: true,
        title: AppbarSubtitleSix(text: "Add UPI"));
  }

  onTapArrowLeft() {
    Get.back();
  }
}
