import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/pan_detrail/pan_detail.dart';
import 'package:experta/presentation/payment_method/payment_method.dart';
import 'package:experta/presentation/verify_account/Models/verify_account_model.dart';
import 'package:experta/presentation/verify_account/face_live.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifyAccount extends StatefulWidget {
  const VerifyAccount({super.key});

  @override
  State<VerifyAccount> createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController panController = TextEditingController();
  final TextEditingController aadharCardController = TextEditingController();
  KYCResponse? kycData;
  bool isLoading = true;
  bool isLoading2 = false;

  @override
  void initState() {
    super.initState();
    fetchKYCData();
  }

  Future<void> fetchKYCData() async {
    setState(() => isLoading = true);

    try {
      final response = await ApiService().getKYCStatus();
      if (response != null) {
        setState(() => kycData = response);
      }
    } catch (e) {
      print('Error fetching KYC data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_buildAppBar(), _buildVerifyAccount()],
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned(
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
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: onTapArrowLeft,
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "VerifyAccount"),
    );
  }

  Widget _buildVerifyAccount() {
    if (isLoading) {
      return const CircularProgressIndicator();
    }

    return _buildUserDetails();
  }

  Widget _buildUserDetails() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 15),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildUserDetail(
                    icon: ImageConstant.phone,
                    label: "Mobile Number",
                    value: kycData?.userData.phoneNo ?? '',
                    isVerified: kycData?.userData.phoneNo.isNotEmpty ?? false,
                    decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderBL20,
                    ),
                  ), 
                  _buildUserDetail(
                    icon: ImageConstant.email,
                    label: "Email Address",
                    value: kycData?.userData.email ?? '',
                    isVerified: kycData?.userData.email?.isNotEmpty ?? false,
                  ),
                  _buildUserDetail(
                    icon: ImageConstant.panset,
                    label: "Pan Card",
                    value:
                        maskPanNumber(kycData?.panVerification.panNumber ?? ''),
                    isVerified:
                        kycData?.kycStatus.steps.panVerification ?? false,
                    onTap: () {
                      if (!(kycData?.kycStatus.steps.panVerification ??
                          false)) {
                        _showPANVerificationDialog();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PanDetail(
                              name: kycData
                                      ?.panVerification.panDetails.fullName ??
                                  '',
                              panno: kycData?.panVerification.panNumber ?? '',
                              dob: '',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  _buildUserDetail(
                    icon: ImageConstant.pancard,
                    label: "Face Liveliness",
                    isVerified: kycData?.kycStatus.steps.faceLiveness ?? false,
                    onTap: () {
                      if (!(kycData?.kycStatus.steps.faceLiveness ?? false)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const FaceDetectorView()),
                        );
                      }
                    },
                  ),
                  _buildUserDetail(
                    icon: ImageConstant.gst,
                    label: "GST Number",
                    value: kycData?.gstDetails.gstNumber,
                    isVerified:
                        kycData?.gstDetails.gstNumber.isNotEmpty ?? false,
                    onTap: () {
                      if (kycData?.gstDetails.gstNumber.isEmpty ?? false) {
                        gstVerificationDialog();
                      }
                    },
                  ),
                  _buildUserDetail(
                    icon: ImageConstant.bank,
                    label: "Payment Method",
                    isVerified:
                        kycData?.kycStatus.steps.bankVerification ?? false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PaymentMethod()),
                    ),
                    decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderL20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetail({
    required String icon,
    required String label,
    String? value,
    bool isVerified = false,
    VoidCallback? onTap,
    Decoration? decoration,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 16.v),
          decoration: decoration ?? AppDecoration.fillOnPrimaryContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconButton(
                height: 44.adaptSize,
                width: 44.adaptSize,
                padding: EdgeInsets.all(10.h),
                decoration: IconButtonStyleHelper.fillGray,
                child: CustomImageView(imagePath: icon),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          label,
                          style: isVerified
                              ? theme.textTheme.titleLarge!.copyWith(
                                  fontSize: 16,
                                  color: appTheme.black900,
                                )
                              : theme.textTheme.titleMedium!.copyWith(
                                  color: appTheme.black900,
                                ),
                        ),
                        if (isVerified)
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Container(
                              width: 45,
                              height: 16,
                              // decoration: BoxDecoration(
                              //   color: appTheme.green100.withOpacity(0.5),
                              //   borderRadius: BorderRadius.circular(2),
                              // ),
                              // child: Center(
                              //   child: Text(
                              //     "Verified",
                              //     style: theme.textTheme.titleSmall!.copyWith(
                              //       color: appTheme.green500,
                              //       fontSize: 10,
                              //     ),
                              //   ),
                              // ),
                            ),
                          ),
                      ],
                    ),
                    if (value != null)
                      Text(
                        value,
                        style: theme.textTheme.titleSmall!.copyWith(
                          fontSize: 16,
                          color: appTheme.black900,
                        ),
                      ),
                  ],
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
                    "Hello ${clientData['full_name']}, Your PAN has been successfully verified and linked to your account"),
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
    // PAN regex pattern: 5 uppercase letters, 4 digits, 1 uppercase letter
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegex.hasMatch(value)) {
      return 'Please enter a valid PAN number';
    }
    return null;
  },
  inputFormatters: [
    // Ensures only uppercase letters and digits are entered
    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
    //UpperCaseTextFormatter(),
  ],
),
const SizedBox(height: 16),
CustomElevatedButton(
  onPressed: () {
    if (formKey.currentState!.validate()) {
      verifyPAN();
      // No need for setState unless there's a specific reason
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

  void gstVerificationDialog() {
    final formKey = GlobalKey<FormState>();
    final TextEditingController gstController = TextEditingController();

    showDialog(
  context: context,
  builder: (BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon or Image at the top
                Center(
                  child: CustomIconButton(
                    height: 64.adaptSize,
                    width: 64.adaptSize,
                    padding: EdgeInsets.all(15.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(32.h),
                    ),
                    child: CustomImageView(imagePath: ImageConstant.gst),
                  ),
                ),
                const SizedBox(height: 16),
                // Dialog Title
                const Center(
                  child: Text(
                    "GST Verification",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Description Text
                Text(
                  "As per regulations, it is mandatory to verify your GST details.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                // GST Input Field
                CustomTextFormField(
                  controller: gstController,
                  autofocus: false,
                  hintText: "Enter Your GST Number",
                  hintStyle: theme.textTheme.titleSmall!.copyWith(
                    color: appTheme.blueGray300,
                    fontSize: 14,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your GST number';
                    }
                    // GST number should match the regex pattern
                    final gstRegex = RegExp(r'^[A-Z]{2}[0-9]{10}[A-Z]{1}[0-9]{1}[Z]{1}[A-Z0-9]{1}$');
                    if (!gstRegex.hasMatch(value)) {
                      return 'Please enter a valid GST number (e.g., 12ABCDE1234F1Z5)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Submit Button
                CustomElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Perform GST verification logic here
                      Navigator.pop(context); // Close the dialog
                    }
                  },
                  text: "Verify",
                ),
                const SizedBox(height: 8),
                // Cancel Button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  },
);

                  const SizedBox(height: 19);
                  Container(
                    width: 160,
                    height: 32.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: appTheme.panCol, width: 1.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flash_on, color: appTheme.panCol, size: 10),
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
                  );
                  const SizedBox(height: 16);
                  Text(
                    "Enter GST number",
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: appTheme.blueGray300,
                      fontSize: 14,
                    ),
                  );
                  const SizedBox(height: 8);
                  CustomTextFormField(
                    controller: gstController,
                    autofocus: false,
                    hintText: "Enter Your 15 Digit GST Number",
                    hintStyle: theme.textTheme.titleSmall!.copyWith(
                      color: appTheme.blueGray300,
                      fontSize: 14,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your GST number';
                      }
                      if (value.length != 15) {
                        return 'GST number must be 15 characters';
                      }
                      return null;
                    },
                    inputFormatters: [],
                  );
                  const SizedBox(height: 16);
                  CustomElevatedButton(
                    onPressed: () async {
                      setState(() => isLoading2 = true);
                      if (formKey.currentState!.validate()) {
                        try {
                          final apiService = ApiService();
                          final response = await apiService
                              .saveGstNumber(gstController.text);

                          if (response['status'] == 'success') {
                            setState(() => isLoading2 = false);
                            Fluttertoast.showToast(
                              msg: "GST verification successful",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            setState(() => isLoading2 = false);
                            Fluttertoast.showToast(
                              msg: "Error verifying GST number",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        } catch (e) {
                          setState(() => isLoading2 = false);
                          Fluttertoast.showToast(
                            msg: "Error verifying GST: $e",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );

                          print('Error verifying GST: $e');
                        }
                      }
                      setState(() {});
                      Navigator.pop(context);
                    },
                    text: !isLoading2 ? "Verify" : "Verifying .... ",
                  );
              
      }
    
  }

  void showErrorDialog(String message) {
    var context;
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

  String maskPanNumber(String? panNumber) {
    if (panNumber == null || panNumber.isEmpty) {
      return '';
    }
    if (panNumber.length >= 10) {
      return "XXXXXXXX${panNumber.substring(8)}";
    }
    return panNumber;
  }

  void onTapArrowLeft() {
    Get.back();
  }

