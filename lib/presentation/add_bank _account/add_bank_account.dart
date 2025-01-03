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
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController reEnterAccountNumberController =
      TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController accountHolderNameController =
      TextEditingController();
  ApiService apiService = ApiService();
  final FocusNode accountNumberFocusNode = FocusNode();
  final FocusNode reEnterAccountNumberFocusNode = FocusNode();
  final FocusNode ifscCodeFocusNode = FocusNode();
  final FocusNode accountHolderNameFocusNode = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    accountNumberController.dispose();
    reEnterAccountNumberController.dispose();
    ifscCodeController.dispose();
    accountHolderNameController.dispose();

    accountNumberFocusNode.dispose();
    reEnterAccountNumberFocusNode.dispose();
    ifscCodeFocusNode.dispose();
    accountHolderNameFocusNode.dispose();

    super.dispose();
  }

  String? validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Account number is required';
    }
    if (value.length < 9 || value.length > 18) {
      return 'Enter valid account number';
    }
    return null;
  }

  String? validateReEnteredAccount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please re-enter account number';
    }
    if (value != accountNumberController.text) {
      return 'Account numbers do not match';
    }
    return null;
  }

  String? validateIFSC(String? value) {
    if (value == null || value.isEmpty) {
      return 'IFSC code is required';
    }
    if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value)) {
      return 'Enter valid IFSC code';
    }
    return null;
  }

  Future<void> verifyAndProceed() async {
    // Validate all fields
    String? accountNumberError =
        validateAccountNumber(accountNumberController.text);
    String? reEnteredError =
        validateReEnteredAccount(reEnterAccountNumberController.text);
    String? ifscError = validateIFSC(ifscCodeController.text);

    if (accountNumberError != null) {
      CustomToast().showToast(
          context: context, message: accountNumberError, isSuccess: false);
      return;
    }
    if (reEnteredError != null) {
      CustomToast().showToast(
          context: context, message: reEnteredError, isSuccess: false);
      return;
    }
    if (ifscError != null) {
      CustomToast()
          .showToast(context: context, message: ifscError, isSuccess: false);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await apiService.verifyBank(
        accountNumber: accountNumberController.text.trim(),
        ifsc: ifscCodeController.text.trim(),
      );

      if (response['status'] == 'success') {
        // Auto-fill account holder name from API response
        final bankData = response['data']['data'];
        accountHolderNameController.text = bankData['full_name'];

        CustomToast().showToast(
          context: context,
          message: "Bank account verified successfully",
          isSuccess: true,
        );
        Get.back();
      } else {
        CustomToast().showToast(
          context: context,
          message: "Bank verification failed",
          isSuccess: false,
        );
      }
    } catch (e) {
      CustomToast().showToast(
        context: context,
        message: "Error verifying bank details",
        isSuccess: false,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account Number",
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  CustomTextFormField(
                    hintText: "Bank account number",
                    hintStyle:
                        theme.textTheme.titleSmall!.copyWith(fontSize: 14),
                    textInputType: TextInputType.number,
                    controller: accountNumberController,
                    focusNode: accountNumberFocusNode,
                    autofocus: false, inputFormatters: [],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Re-enter Account Number",
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  CustomTextFormField(
                    hintText: "Re-enter bank account number",
                    hintStyle:
                        theme.textTheme.titleSmall!.copyWith(fontSize: 14),
                    textInputType: TextInputType.number,
                    controller: reEnterAccountNumberController,
                    focusNode: reEnterAccountNumberFocusNode,
                    autofocus: false, inputFormatters: [],
                  ),
                  const SizedBox(),
                  Text(
                    "IFSC Code",
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  CustomTextFormField(
                    hintText: "Enter IFSC code",
                    hintStyle:
                        theme.textTheme.titleSmall!.copyWith(fontSize: 14),
                    textInputType: TextInputType.text,
                    controller: ifscCodeController,
                    focusNode: ifscCodeFocusNode,
                    autofocus: false, inputFormatters: [],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Account Holder Name",
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  CustomTextFormField(
                    hintText: "Account holder's name",
                    hintStyle:
                        theme.textTheme.titleSmall!.copyWith(fontSize: 14),
                    textInputType: TextInputType.name,
                    controller: accountHolderNameController,
                    focusNode: accountHolderNameFocusNode,
                    autofocus: false, inputFormatters: [],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Important:",
                    style: theme.textTheme.titleSmall!
                        .copyWith(color: appTheme.black900, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "• Your full name on bank account, Aadhaar card and \n   PAN card should match.",
                    style: theme.textTheme.titleSmall!.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "• Transfer might take up to 48 hours to reflect in your \n   account.",
                    style: theme.textTheme.titleSmall!.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  CustomElevatedButton(
                    text: _isLoading ? "Verifying..." : "Save",
                    onPressed: _isLoading ? null : verifyAndProceed,
                    margin: const EdgeInsets.all(10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 60.h,
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