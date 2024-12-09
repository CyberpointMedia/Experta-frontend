import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/categoryDetails/category_details_screen.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:experta/widgets/custom_radio_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';

class WithdrawCreditsPage extends StatefulWidget {
  const WithdrawCreditsPage({super.key});

  @override
  State<WithdrawCreditsPage> createState() => _WithdrawCreditsPageState();
}

class _WithdrawCreditsPageState extends State<WithdrawCreditsPage> {
  final TextEditingController _amountController = TextEditingController();
  bool isUpiAdded = false;
  bool isBankAdded = false;
  bool isBankVerified = false;
  bool isLoading = false;

  String? upiDetails;
  Map<String, String>? bankDetails;
  ApiService apiService = ApiService();
  String selectedPaymentMethod = '';
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
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            Text(
              "Earn credits",
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(width: 5),
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
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _amountController,
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {});
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
            SizedBox(height: 10.v),
            Container(
              decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                color: Colors.transparent,
                borderRadius: BorderRadiusStyle.roundedBorder20,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(isUpiAdded ? "UPI" : "Add UPI",
                                    style: theme.textTheme.titleMedium!
                                        .copyWith(color: appTheme.gray900)),
                                (isUpiAdded)
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Container(
                                          width: 45,
                                          height: 16,
                                          decoration: BoxDecoration(
                                              color: appTheme.green100
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(2)),
                                          child: Center(
                                            child: Text(
                                              "Verified",
                                              style: theme.textTheme.titleSmall!
                                                  .copyWith(
                                                      color: appTheme.green500,
                                                      fontSize: 10),
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
                                    style: theme.textTheme.titleSmall!.copyWith(
                                        fontSize: 14, color: appTheme.black900),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                      const Spacer(),
                      (!isUpiAdded)
                          ? SizedBox(
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
                            )
                          : // For UPI section
                          CustomRadioButton(
                              value: 'upi', // Add this
                              groupValue: selectedPaymentMethod,
                              onChange: (value) {
                                setState(() {
                                  selectedPaymentMethod = value.toString();
                                });
                              },
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 16.v),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                      isBankAdded
                                          ? "A/C - ${bankDetails?['ifsc']?.substring(0, 4) ?? ''} Bank"
                                          : "Add Bank Account",
                                      style: theme.textTheme.titleMedium!
                                          .copyWith(color: appTheme.gray900)),
                                  (isBankAdded && isBankVerified)
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Container(
                                            width: 45,
                                            height: 16,
                                            decoration: BoxDecoration(
                                                color: appTheme.green100
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(2)),
                                            child: Center(
                                              child: Text(
                                                "Verified",
                                                style: theme
                                                    .textTheme.titleSmall!
                                                    .copyWith(
                                                        color:
                                                            appTheme.green500,
                                                        fontSize: 10),
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
                                      style: theme.textTheme.titleSmall!
                                          .copyWith(
                                              fontSize: 14,
                                              color: appTheme.black900),
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ),
                        const Spacer(),
                        !isBankAdded
                            ? SizedBox(
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
                              )
                            : CustomRadioButton(
                                value: 'bank',
                                groupValue: selectedPaymentMethod,
                                onChange: (value) {
                                  setState(() {
                                    selectedPaymentMethod = value.toString();
                                  });
                                },
                              ),
                      ],
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
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: isLoading
          ? const CircularProgressIndicator()
          : CustomElevatedButton(
              text: 'Submit',
              onPressed: () async {
                if (_amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an amount')),
                  );
                  return;
                }

                if (selectedPaymentMethod.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select a payment method')),
                  );
                  return;
                }
                setState(() {
                  isLoading = true;
                });
                try {
                  final kycResponse = await apiService.getKYCStatus();
                  if (kycResponse != null) {
                    final panVerification = kycResponse.panVerification;
                    if (panVerification.verificationStatus == false) {
                      setState(() {
                        isLoading = false;
                      });
                      _showPANVerificationDialog();
                    } else {
                      processWithdrawal();
                      setState(() {
                        isLoading = false; // Set loading to false
                      });
                    }
                  } else {
                    setState(() {
                      isLoading = false; // Set loading to false
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Failed to fetch KYC status.')),
                    );
                  }
                } catch (e) {
                  setState(() {
                    isLoading = false; // Set loading to false
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
            ),
    );
  }

  void _showPANVerificationDialog() {
    final formKey = GlobalKey<FormState>();
    final TextEditingController panController = TextEditingController();
    final ApiService apiService = ApiService();

    Future<void> verifyPAN() async {
      final panNumber = panController.text.trim();
      try {
        final responseData =
            await apiService.verifyPAN(panNumber.toUpperCase());

        if (responseData['status'] == 'success') {
          final clientData = responseData['data']['data'];
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Verification Successful"),
                content: Text(
                    "Hello ${clientData['full_name']}, your PAN has been verified successfully."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          showErrorDialog("PAN verification failed. Please try again.");
        }
      } catch (e) {
        showErrorDialog("An error occurred: ${e.toString()}");
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CustomIconButton(
                      height: 70,
                      width: 70,
                      padding: const EdgeInsets.all(10),
                      decoration: IconButtonStyleHelper.fillGreenTL245,
                      child: CustomImageView(imagePath: ImageConstant.pan),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "PAN Verification",
                      style: TextStyle(fontSize: 22, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "As per regulations, it is mandatory to verify your PAN details.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 150,
                    height: 32.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: appTheme.panCol, width: 1.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flash_on, color: appTheme.panCol, size: 14),
                        const SizedBox(width: 5),
                        Text(
                          "Takes less than 5 secs",
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: appTheme.panCol,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Enter PAN number",
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: appTheme.blueGray300,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: panController,
                    autofocus: false,
                    hintText: "Enter Your 10 Digit PAN Number",
                    hintStyle: theme.textTheme.titleSmall!.copyWith(
                      color: appTheme.blueGray300,
                      fontSize: 14,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your PAN number';
                      }
                      if (value.length != 10) {
                        return 'PAN number must be 10 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        verifyPAN();
                      }
                    },
                    text: "Verify",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void processWithdrawal() {
    final amount = double.tryParse(_amountController.text) ?? 0;

    if (selectedPaymentMethod == 'upi') {
      if (!isUpiAdded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please link your UPI first')),
        );
        return;
      }
      processUpiWithdrawal(amount);
    } else if (selectedPaymentMethod == 'bank') {
      if (!isBankAdded || !isBankVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please add and verify your bank account first')),
        );
        return;
      }
      processBankWithdrawal(amount);
    }
  }

  Future<void> processUpiWithdrawal(double amount) async {
    setState(() {
      isLoading = true;
    });
    try {
      final paymentDetails = {
        'vpa': upiDetails,
      };

      final response = await apiService.withdrawMoney(
        amount: amount,
        method: 'upi',
        paymentDetails: paymentDetails,
      );

      if (response['status'] == 'success') {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120.h,
                  height: 120.v,
                  decoration: BoxDecoration(
                    color: appTheme.green400.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 72.h,
                      height: 72.v,
                      decoration: BoxDecoration(
                        color: appTheme.green400,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomImageView(
                          imagePath: ImageConstant.success,
                          height: 20.v,
                          width: 30.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Withdrawal Successful',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your UPI withdrawal for ₹$amount has been initiated successfully',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  text: 'Done',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      } else {
        throw Exception('Withdrawal failed: ${response['data']['message']}');
      }
    } catch (e) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120.h,
                height: 120.v,
                decoration: BoxDecoration(
                  color: appTheme.red500.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 72.h,
                    height: 72.v,
                    decoration: BoxDecoration(
                      color: appTheme.red500,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomImageView(
                        imagePath: ImageConstant.cross,
                        color: Colors.white,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Withdrawal Failed',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Error processing UPI withdrawal: $e',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                text: 'Close',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> processBankWithdrawal(double amount) async {
    setState(() {
      isLoading = true;
    });
    try {
      final paymentDetails = {
        'accountNumber': bankDetails?['accountNumber'],
        'ifsc': bankDetails?['ifsc'],
        'accountName': 'Account Holder Name',
      };

      final response = await apiService.withdrawMoney(
        amount: amount,
        method: 'bank',
        paymentDetails: paymentDetails,
      );

      if (response['status'] == 'success') {
        // Show success bottom sheet with message from response
        final message =
            response['data']['message'] ?? 'Withdrawal initiated successfully';

        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120.h,
                  height: 120.v,
                  decoration: BoxDecoration(
                    color: appTheme.green400.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 72.h,
                      height: 72.v,
                      decoration: BoxDecoration(
                        color: appTheme.green400,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomImageView(
                          imagePath: ImageConstant.success,
                          height: 20.v,
                          width: 30.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Withdrawal Successful',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your bank withdrawal for ₹$amount has been initiated successfully.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: appTheme.green400),
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  text: 'Done',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      } else {
        throw Exception(
            'Failed to process withdrawal: ${response['data']['message']}');
      }
    } catch (e) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120.h,
                height: 120.v,
                decoration: BoxDecoration(
                  color: appTheme.red500.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 72.h,
                    height: 72.v,
                    decoration: BoxDecoration(
                      color: appTheme.red500,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomImageView(
                        imagePath: ImageConstant.cross,
                        color: Colors.white,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Withdrawal Failed',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Error processing bank withdrawal: ${e.toString()}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                text: 'Close',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
