// import 'dart:io';
// import 'dart:ui';

// import 'package:country_pickers/country.dart';
// import 'package:experta/core/app_export.dart';
// import 'package:experta/core/utils/validation_functions.dart';
// import 'package:experta/presentation/signin_page/controller/signin_controller.dart';
// import 'package:experta/widgets/custom_outlined_button.dart';
// import 'package:experta/widgets/custom_phone_number.dart';
// import 'package:experta/widgets/custom_text_form_field.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
//   final SigninController controller = Get.put(SigninController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         children: [
//           Positioned(
//             left: 270,
//             top: 50,
//             child: ImageFiltered(
//               imageFilter: ImageFilter.blur(
//                 tileMode: TileMode.decal,
//                 sigmaX: 60,
//                 sigmaY: 60,
//               ),
//               child: Align(
//                 child: SizedBox(
//                   width: 252,
//                   height: 252,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(126),
//                       color: appTheme.deepOrangeA20.withOpacity(0.35),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.only(
//                 top: MediaQuery.of(context).size.height * 0.15,
//               ),
//               child: emailTabContent(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget emailTabContent() {
//     return Container(
//       color: Colors.transparent,
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height * 0.85,
//       child: Form(
//         key: _formKey1,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.adaptSize),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 19),
//               _buildFirstName(),
//               SizedBox(height: 15.v),
//               _buildInputField2(),
//               SizedBox(height: 15.v),
//               _buildInputField1(),
//               const SizedBox(height: 18),
//               _buildContinueButton2(),
//               const SizedBox(height: 25),
//               _buildOrcontinuewithsocial(),
//               SizedBox(height: 15.v),
//               _buildLoginOption(),
//               const Spacer(),
//               _buildTermsText(),
//               SizedBox(height: 15.v),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField2() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "lbl_email".tr,
//           style: theme.textTheme.titleMedium,
//         ),
//         SizedBox(height: 3.v),
//         CustomTextFormField(
//           controller: controller.emailController,
//           focusNode: controller.emailFocusNode,
//           hintText: "lbl_your_email".tr,
//           hintStyle: CustomTextStyles.titleMediumBluegray300,
//           textInputType: TextInputType.emailAddress,
//           validator: (value) {
//             if (value == null || (!isValidEmail(value, isRequired: true))) {
//               return "err_msg_please_enter_valid_email".tr;
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildInputField1() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("lbl_phone_number".tr, style: theme.textTheme.titleMedium),
//         SizedBox(height: 3.v),
//         Obx(
//           () => CustomPhoneNumber(
//             country: controller.selectedCountry.value,
//             controller: controller.phoneNumberController,
//             onTap: (Country value) {
//               controller.selectedCountry.value = value;
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTermsText() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: RichText(
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: "msg_by_continuing_i2".tr,
//               style: theme.textTheme.titleSmall!.copyWith(
//                   color: appTheme.blueGray300,
//                   fontSize: 14.fSize,
//                   fontWeight: FontWeight.w300),
//             ),
//             TextSpan(
//               text: "msg_terms_conditions".tr,
//               style: theme.textTheme.titleSmall!.copyWith(
//                 color: appTheme.black900,
//               ),
//             ),
//             TextSpan(
//               text: " and ".tr,
//               style: theme.textTheme.titleSmall!.copyWith(
//                   color: appTheme.blueGray300, fontWeight: FontWeight.w300),
//             ),
//             TextSpan(
//               text: "lbl_privacy_policy".tr,
//               style: theme.textTheme.titleSmall!.copyWith(
//                 color: appTheme.black900,
//               ),
//             ),
//           ],
//         ),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }

//   Widget _buildContinueButton2() {
//     return Column(
//       children: [
//         Obx(() {
//           if (controller.isLoading.value) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
//               ),
//             );
//           } else {
//             return CustomElevatedButton(
//               text: "Sign Up".tr,
//               buttonStyle: (controller.isEmailValid.value &&
//                       controller.isPhoneNumberValid.value &&
//                       controller.isTextValid.value)
//                   ? CustomButtonStyles.fillPrimaryTL23
//                   : CustomButtonStyles.fillOnError,
//               buttonTextStyle: (controller.isEmailValid.value &&
//                       controller.isPhoneNumberValid.value &&
//                       controller.isTextValid.value)
//                   ? CustomTextStyles.bodySmall0XFF171717
//                   : CustomTextStyles.titleMediumGray400,
//               onPressed: (controller.isEmailValid.value &&
//                       controller.isPhoneNumberValid.value &&
//                       controller.isTextValid.value)
//                   ? () => controller.registerUser(context)
//                   : null,
//             );
//           }
//         }),
//         Obx(() {
//           if (controller.errorMessage.isNotEmpty) {
//             return Text(
//               controller.errorMessage.value,
//               style: const TextStyle(color: Colors.red),
//             );
//           }
//           return Container();
//         }),
//       ],
//     );
//   }

//   Widget _buildFirstName() {
//     return Row(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("First Name".tr, style: theme.textTheme.titleMedium),
//             SizedBox(height: 3.v),
//             CustomTextFormField(
//               width: 150.v,
//               controller: controller.nameController,
//               focusNode: controller.nameFocusNode,
//               hintText: "First name".tr,
//               hintStyle: CustomTextStyles.titleMediumBluegray300.copyWith(),
//               textInputType: TextInputType.name,
//             ),
//           ],
//         ),
//         SizedBox(width: 15.v),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Last Name".tr, style: theme.textTheme.titleMedium),
//             SizedBox(height: 3.v),
//             CustomTextFormField(
//               width: 166.v,
//               controller: controller.passwordController,
//               focusNode: controller.passwordFocusNode,
//               hintText: "Last name".tr,
//               hintStyle: CustomTextStyles.titleMediumBluegray300.copyWith(),
//               textInputType: TextInputType.name,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// Widget _buildOrcontinuewithsocial() {
//   return Row(
//     children: [
//       const Expanded(
//         child: Divider(
//           thickness: 2,
//         ),
//       ),
//       SizedBox(width: 15.adaptSize),
//       Text(
//         'Or continue with social',
//         style: theme.textTheme.bodySmall!.copyWith(
//           fontSize: 12.fSize,
//           color: appTheme.black900,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       SizedBox(width: 15.adaptSize),
//       const Expanded(
//         child: Divider(
//           thickness: 1,
//         ),
//       ),
//     ],
//   );
// }

// Widget _buildContinueWithGoogle() {
//   return SizedBox(
//     height: 52.v,
//     width: double.infinity,
//     child: CustomOutlinedButton(
//       text: "msg_continue_with_google".tr,
//       leftIcon: Container(
//         margin: EdgeInsets.only(right: 10.h),
//         child: CustomImageView(
//           imagePath: ImageConstant.imgGoogle,
//           height: 24.adaptSize,
//           width: 24.adaptSize,
//         ),
//       ),
//       buttonStyle: CustomButtonStyles.outlineGray,
//       buttonTextStyle: CustomTextStyles.titleSmallGray900,
//       buttonColor: appTheme.googlee,
//     ),
//   );
// }

// Widget _buildContinueWithFacebook() {
//   return CustomOutlinedButton(
//     height: 52.v,
//     text: "msg_continue_with_facebook".tr,
//     leftIcon: Container(
//       margin: EdgeInsets.only(right: 10.h),
//       child: CustomImageView(
//         imagePath: ImageConstant.imgFacebook,
//         height: 24.adaptSize,
//         width: 24.adaptSize,
//       ),
//     ),
//     buttonStyle: CustomButtonStyles.outlineGray,
//     buttonTextStyle: CustomTextStyles.titleSmallGray900,
//     buttonColor: appTheme.facebokk,
//   );
// }

// Widget _buildContinueWithApple() {
//   return CustomOutlinedButton(
//     height: 52.v,
//     text: "msg_continue_with_apple".tr,
//     leftIcon: Container(
//       margin: EdgeInsets.only(right: 10.h),
//       child: CustomImageView(
//         imagePath: ImageConstant.imgSocialIcon,
//         height: 24.adaptSize,
//         width: 24.adaptSize,
//       ),
//     ),
//     buttonStyle: CustomButtonStyles.outlineGray,
//     buttonTextStyle: CustomTextStyles.titleSmallGray900,
//     buttonColor: Colors.black,
//   );
// }

// Widget _buildLoginOption() {
//   return Align(
//     alignment: Alignment.bottomCenter,
//     child: Padding(
//       padding: EdgeInsets.only(
//         left: 0.h,
//         right: 0.h,
//         // bottom: 155.v,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(height: 10.v),
//           _buildContinueWithGoogle(),
//           SizedBox(height: 10.v),
//           _buildContinueWithFacebook(),
//           SizedBox(height: 10.v),
//           Platform.isIOS ? _buildContinueWithApple() : const SizedBox.shrink(),
//         ],
//       ),
//     ),
//   );
// }
