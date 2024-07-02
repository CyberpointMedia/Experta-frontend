import 'dart:developer';

import 'package:experta/data/apiClient/api_service.dart';
import 'package:experta/data/models/request/login_request_model.dart';
import 'package:experta/data/models/request/register_request_model.dart';
import 'package:experta/data/models/response/login_response_model.dart';
import 'package:experta/widgets/custom_toast_message.dart';

import '../../../core/app_export.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/validation_functions.dart';

class SigninController extends GetxController {
  var phoneNumberController = TextEditingController();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var isEmailValid = false.obs;
  var isPasswordValid = false.obs;
  var otpController = TextEditingController();
  var isShowPassword = false.obs;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final ApiService _apiService = ApiService();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isPhoneNumberValid =
      false.obs; // Observable variable to track phone number validity
  Rx<Country> selectedCountry =
      CountryPickerUtils.getCountryByPhoneCode('91').obs;
  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateEmail);
    passwordController.addListener(_validatePassword);
    phoneNumberController.addListener(_validatePhoneNumber);
  }

  void _validatePhoneNumber() {
    if (phoneNumberController.text.length >= 10) {
      isPhoneNumberValid.value = true;
    } else {
      isPhoneNumberValid.value = false;
    }
  }

  void _validateEmail() {
    isEmailValid.value = isValidEmail(emailController.text, isRequired: true);
  }

  void _validatePassword() {
    isPasswordValid.value =
        isValidPassword(passwordController.text, isRequired: true);
  }

  void loginUser(context) async {
    LoginRequestModel requestModel = LoginRequestModel(
      phoneNo: phoneNumberController.text,
    );

    try {
      LoginResponseModel? response = await _apiService.loginUser(requestModel);
      if (response != null && response.status == "success") {
        CustomToast().showToast(
          context: context,
          message: 'Otp Sent Sucessfully',
          isSuccess: true,
        );
        log('hi the otp is ${response.data.otp}');
        Get.toNamed(
          AppRoutes.verifynumberScreen,
          arguments: phoneNumberController,
        );
      } else {
        print("Login failed");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

  // void registerUser() async {
  //   RegisterRequestModel requestModel = RegisterRequestModel(
  //     email: emailController.text,
  //     firstName: nameController.text,
  //     lastName: passwordController.text,
  //     phoneNo: phoneNumberController.text,
  //   );

  //   try {
  //     RegisterResponseModel? response =
  //         await _apiService.registerUser(requestModel);

  //     if (response != null && response.status == "success") {
  //       Get.toNamed(AppRoutes.verifynumberScreen);
  //     } else {
  //       print("Registration failed");
  //     }
  //   } catch (e) {
  //     print("Exception occurred: $e");
  //   }
  // }
  void registerUser(context) async {
    isLoading(true);
    try {
      RegisterRequestModel requestModel = RegisterRequestModel(
        email: emailController.text,
        firstName: nameController.text,
        lastName: passwordController.text,
        phoneNo: phoneNumberController.text,
      );

      final response = await _apiService.registerUser(requestModel);
      if (response is RegisterResponseSuccess) {
        CustomToast().showToast(
          context: context,
          message: 'Otp Sent Sucessfully',
          isSuccess: true,
        );
        Get.toNamed(
          AppRoutes.verifynumberScreen,
          arguments: phoneNumberController,
        );
        log('Registration successful: ${response.data.toString()}');
      } else if (response is RegisterResponseError) {
        CustomToast().showToast(
          context: context,
          message: response.error.errorMessage,
          isSuccess: false,
        );
        log("Registration failed");
        errorMessage(response.error.errorMessage);
      }
    } catch (e) {
      CustomToast().showToast(
        context: context,
        message: 'Failed to register user: $e',
        isSuccess: false,
      );
      errorMessage('Failed to register user: $e');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
