import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/change_date_of_birth/controller/change_date_of_birth_controller.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:experta/widgets/custom_toast_message.dart';

class ChangeDateOfBirth extends StatefulWidget {
  const ChangeDateOfBirth({super.key});

  @override
  State<ChangeDateOfBirth> createState() => _ChangeDateOfBirthState();
}

class _ChangeDateOfBirthState extends State<ChangeDateOfBirth> {
  ChangeDateOfBirthController controller = Get.put(ChangeDateOfBirthController());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.textField1.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
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
                  Text(
                    "Change Date of birth",
                    style: theme.textTheme.headlineSmall!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 15),
                    child: Text(
                      "Enter your email or phone number to reset the password.",
                      maxLines: 1,
                    ),
                  ),
                  const Text("Date of birth (DD/MM/YYYY)"),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          hintText: "01/01/2024",
                          hintStyle: CustomTextStyles.titleMediumBluegray300,
                          textInputType: TextInputType.name,
                          controller: controller.textField1,
                          focusNode: controller.focus1,
                          autofocus: false,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                    text: "Save",
                    onPressed: () {
                      if (controller.textField1.text.isNotEmpty) {
                        CustomToast().showToast(
                          context: context,
                          message: "Date of birth changed Successfully",
                          isSuccess: true,
                        );
                        Get.toNamed(AppRoutes.accountSetting);
                      } else {
                        CustomToast().showToast(
                          context: context,
                          message: "Please Fill the Date of birth",
                          isSuccess: false,
                        );
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
        },
      ),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
