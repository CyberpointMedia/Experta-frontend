import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:experta/widgets/custom_toast_message.dart';

class AddBankAccount extends StatefulWidget {
  const AddBankAccount({super.key});

  @override
  State<AddBankAccount> createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {
  // Controllers for each field
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController reEnterAccountNumberController =
      TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController accountHolderNameController =
      TextEditingController();

  // Focus nodes for each field
  final FocusNode accountNumberFocusNode = FocusNode();
  final FocusNode reEnterAccountNumberFocusNode = FocusNode();
  final FocusNode ifscCodeFocusNode = FocusNode();
  final FocusNode accountHolderNameFocusNode = FocusNode();

  @override
  void dispose() {
    // clear controllers and focus nodes to free up resources
    accountNumberController.clear();
    reEnterAccountNumberController.clear();
    ifscCodeController.clear();
    accountHolderNameController.clear();

    accountNumberFocusNode.dispose();
    reEnterAccountNumberFocusNode.dispose();
    ifscCodeFocusNode.dispose();
    accountHolderNameFocusNode.dispose();

    super.dispose();
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
                  const Text("Account Number"),
                  CustomTextFormField(
                    hintText: "Bank account number",
                    hintStyle: CustomTextStyles.titleMediumBluegray300,
                    textInputType: TextInputType.number,
                    controller: accountNumberController,
                    focusNode: accountNumberFocusNode,
                    autofocus: false,
                  ),
                  const SizedBox(height: 10),
                  const Text("Re-enter Account Number"),
                  CustomTextFormField(
                    hintText: "Re-enter bank account number",
                    hintStyle: CustomTextStyles.titleMediumBluegray300,
                    textInputType: TextInputType.number,
                    controller: reEnterAccountNumberController,
                    focusNode: reEnterAccountNumberFocusNode,
                    autofocus: false,
                  ),
                  const SizedBox(height: 10),
                  const Text("IFSC Code"),
                  CustomTextFormField(
                    hintText: "Enter IFSC code",
                    hintStyle: CustomTextStyles.titleMediumBluegray300,
                    textInputType: TextInputType.text,
                    controller: ifscCodeController,
                    focusNode: ifscCodeFocusNode,
                    autofocus: false,
                  ),
                  const SizedBox(height: 10),
                  const Text("Account Holder Name"),
                  CustomTextFormField(
                    hintText: "Account holder’s name",
                    hintStyle: CustomTextStyles.titleMediumBluegray300,
                    textInputType: TextInputType.name,
                    controller: accountHolderNameController,
                    focusNode: accountHolderNameFocusNode,
                    autofocus: false,
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                    text: "Save",
                    onPressed: () {
                      // Validation and navigation logic
                      if (accountNumberController.text.isNotEmpty &&
                          reEnterAccountNumberController.text.isNotEmpty &&
                          ifscCodeController.text.isNotEmpty &&
                          accountHolderNameController.text.isNotEmpty) {
                        CustomToast().showToast(
                          context: context,
                          message: "Bank account details saved successfully",
                          isSuccess: true,
                        );
                        Get.toNamed(AppRoutes.accountSetting);
                      } else {
                        CustomToast().showToast(
                          context: context,
                          message: "Please fill in all the fields",
                          isSuccess: false,
                        );
                      }
                    },
                    margin: const EdgeInsets.all(10),
                  ),
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
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Add Bank Account"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
