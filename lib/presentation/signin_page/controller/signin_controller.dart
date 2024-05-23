import 'dart:developer';

import 'package:experta/data/apiClient/api_service.dart';
import 'package:experta/data/models/request/login_request_model.dart';
import 'package:experta/data/models/request/register_request_model.dart';
import 'package:experta/data/models/response/login_response_model.dart';
import 'package:experta/data/models/response/register_response_model.dart';

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
  var otpController = TextEditingController(); // Add OTP controller
  var isShowPassword = false.obs;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final ApiService _apiService = ApiService();

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
    if (phoneNumberController.text.length == 10) {
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

  void loginUser() async {
    LoginRequestModel requestModel = LoginRequestModel(
      phoneNo: phoneNumberController.text,
    );

    try {
      LoginResponseModel? response = await _apiService.loginUser(requestModel);
      if (response != null && response.status == "success") {
        log('hi the otp is ${response.data!.otp}');
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

  void registerUser() async {
    RegisterRequestModel requestModel = RegisterRequestModel(
      email: emailController.text,
      firstName: nameController.text,
      lastName: passwordController.text,
      phoneNo: phoneNumberController.text,
    );

    try {
      RegisterResponseModel? response =
          await _apiService.registerUser(requestModel);

      if (response != null && response.status == "success") {
        Get.toNamed(AppRoutes.verifynumberScreen);
      } else {
        print("Registration failed");
      }
    } catch (e) {
      print("Exception occurred: $e");
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
