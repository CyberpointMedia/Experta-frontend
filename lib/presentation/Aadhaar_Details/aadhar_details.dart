import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/add_upi/controller/add_upi_controller.dart';
import 'package:experta/widgets/custom_text_form_field.dart';

class AadharDetails extends StatefulWidget {
  const AadharDetails({super.key});

  @override
  State<AadharDetails> createState() => _AadharDetailsState();
}

class _AadharDetailsState extends State<AadharDetails> {
  final AddUpiController controller = Get.put(AddUpiController());

  // Define separate controllers for each field
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController aadhaarNumberController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  // Define focus nodes for each field
  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode aadhaarNumberFocusNode = FocusNode();
  final FocusNode dateOfBirthFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode stateFocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();
  final FocusNode pinCodeFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose controllers and focus nodes when the widget is disposed
    fullNameController.dispose();
    aadhaarNumberController.dispose();
    dateOfBirthController.dispose();
    addressController.dispose();
    stateController.dispose();
    cityController.dispose();
    pinCodeController.dispose();

    fullNameFocusNode.dispose();
    aadhaarNumberFocusNode.dispose();
    dateOfBirthFocusNode.dispose();
    addressFocusNode.dispose();
    stateFocusNode.dispose();
    cityFocusNode.dispose();
    pinCodeFocusNode.dispose();

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
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Full Name"),
                    const SizedBox(
                      height: 6,
                    ),
                    CustomTextFormField(
                      hintText: "Naveen Verma",
                      hintStyle: CustomTextStyles.titleMediumBluegray300,
                      textInputType: TextInputType.name,
                      controller: fullNameController,
                      focusNode: fullNameFocusNode,
                      autofocus: false,
                    ),
                    const SizedBox(height: 10),
                    const Text("Aadhaar Number"),
                    const SizedBox(
                      height: 6,
                    ),
                    CustomTextFormField(
                      hintText: "4400 2059 9088",
                      hintStyle: CustomTextStyles.titleMediumBluegray300,
                      textInputType: TextInputType.number,
                      controller: aadhaarNumberController,
                      focusNode: aadhaarNumberFocusNode,
                      autofocus: false,
                    ),
                    const SizedBox(height: 10),
                    const Text("Date of Birth"),
                    const SizedBox(
                      height: 6,
                    ),
                    CustomTextFormField(
                      hintText: "25/11/1992",
                      hintStyle: CustomTextStyles.titleMediumBluegray300,
                      textInputType: TextInputType.datetime,
                      controller: dateOfBirthController,
                      focusNode: dateOfBirthFocusNode,
                      autofocus: false,
                    ),
                    const SizedBox(height: 10),
                    const Text("Address"),
                    const SizedBox(
                      height: 6,
                    ),
                    CustomTextFormField(
                      hintText:
                          "Flat no 351, 4th floor, Tower 2, Sector 91, Mohali",
                      hintStyle: CustomTextStyles.titleMediumBluegray300,
                      textInputType: TextInputType.streetAddress,
                      controller: addressController,
                      focusNode: addressFocusNode,
                      autofocus: false,
                    ),
                    const SizedBox(height: 10),
                    const Text("State"),
                    const SizedBox(
                      height: 6,
                    ),
                    CustomTextFormField(
                      hintText: "Punjab",
                      hintStyle: CustomTextStyles.titleMediumBluegray300,
                      textInputType: TextInputType.text,
                      controller: stateController,
                      focusNode: stateFocusNode,
                      autofocus: false,
                    ),
                    const SizedBox(height: 10),
                    const Text("City"),
                    const SizedBox(
                      height: 6,
                    ),
                    CustomTextFormField(
                      hintText: "SAS Nagar (Mohali)",
                      hintStyle: CustomTextStyles.titleMediumBluegray300,
                      textInputType: TextInputType.text,
                      controller: cityController,
                      focusNode: cityFocusNode,
                      autofocus: false,
                    ),
                    const SizedBox(height: 10),
                    const Text("Pin Code"),
                    const SizedBox(
                      height: 6,
                    ),
                    CustomTextFormField(
                      hintText: "140308",
                      hintStyle: CustomTextStyles.titleMediumBluegray300,
                      textInputType: TextInputType.number,
                      controller: pinCodeController,
                      focusNode: pinCodeFocusNode,
                      autofocus: false,
                    ),
                    const SizedBox(height: 20), // Add spacing before the button
                    // CustomElevatedButton(
                    //   text: "Save",
                    //   onPressed: () {
                    //     // Check if all fields are filled
                    //     if (fullNameController.text.isNotEmpty &&
                    //         aadhaarNumberController.text.isNotEmpty &&
                    //         dateOfBirthController.text.isNotEmpty &&
                    //         addressController.text.isNotEmpty &&
                    //         stateController.text.isNotEmpty &&
                    //         cityController.text.isNotEmpty &&
                    //         pinCodeController.text.isNotEmpty) {
                    //       // Show success toast
                    //       CustomToast().showToast(
                    //         context: context,
                    //         message: "Aadhaar Details saved successfully",
                    //         isSuccess: true,
                    //       );
                    //       Get.toNamed(AppRoutes.accountSetting);
                    //     } else {
                    //       // Show error toast
                          // CustomToast().showToast(
                          //   context: context,
                          //   message: "Please fill in all the fields",
                          //   isSuccess: false,
                          // );
                    //     }
                    //   },
                    //   margin: const EdgeInsets.all(10),
                    // ),
                    const SizedBox(height: 20), // Extra space at the bottom
                  ],
                ),
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
      title: AppbarSubtitleSix(text: "Aadhaar Details"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
