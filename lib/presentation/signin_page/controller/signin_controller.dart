import 'dart:developer';

import 'package:experta/data/models/request/login_request_model.dart';
import 'package:experta/data/models/request/register_request_model.dart';
import 'package:experta/data/models/response/login_response_model.dart';
import 'package:experta/widgets/custom_toast_message.dart';

import '../../../core/app_export.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';

import '../../../core/utils/validation_functions.dart';

class SigninController extends GetxController {
  var phoneNumberController = TextEditingController();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var isEmailValid = false.obs;
  var isPasswordValid = false.obs;
  var isTextValid = false.obs;
  var otpController = TextEditingController();
  var isShowPassword = false.obs;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final ApiService _apiService = ApiService();
  PrefUtils prefUtils = PrefUtils();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isPhoneNumberValid = false.obs;
  Rx<Country> selectedCountry =
      CountryPickerUtils.getCountryByPhoneCode('91').obs;
  @override
  void onInit() {
    super.onInit();
    nameController.addListener(_validateName);
    emailController.addListener(_validateEmail);
    passwordController.addListener(_validatePassword);
    phoneNumberController.addListener(_validatePhoneNumber);
  }

  void _validatePhoneNumber() {
    isPhoneNumberValid.value =
        isValidPhone(phoneNumberController.text, isRequired: true);
  }

  void _validateEmail() {
    isEmailValid.value = isValidEmail(emailController.text, isRequired: true);
  }

  void _validateName() {
    isTextValid.value = isText(nameController.text, isRequired: true);
  }

  void _validatePassword() {
    isPasswordValid.value =
        isValidPassword(passwordController.text, isRequired: true);
  }

  void loginUser(BuildContext context) async {
    isLoading(true);
    // Concatenate country code with phone number
    String fullPhoneNumber = phoneNumberController.text;
    // '+${selectedCountry.value.phoneCode}${phoneNumberController.text}';
    log(fullPhoneNumber);
    LoginRequestModel requestModel = LoginRequestModel(
      phoneNo: fullPhoneNumber,
    );

    try {
      LoginResponseModel? response =
          await _apiService.loginUser(requestModel, context);
      if (response != null && response.status == "success") {
        CustomToast().showToast(
          context: context,
          message: 'OTP sent successfully to your phone number.',
          isSuccess: true,
        );
        await prefUtils.setEmail(response.data.phoneNo ?? "");
        Get.toNamed(AppRoutes.verifynumberScreen,
            arguments: [phoneNumberController]);
      } else {
        CustomToast().showToast(
          context: context,
          message: "Please check the country code and phone number",
          isSuccess: false,
        );
        print("Login failed");
      }
    } catch (e) {
      CustomToast().showToast(
        context: context,
        message:
            "Oops! Something didn't go as planned. Please try again later.",
        isSuccess: false,
      );
      print("Exception occurred: $e");
    } finally {
      isLoading(false);
    }
  }

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
      log('Response received: ${response.toString()}');

      if (response is RegisterResponseSuccess) {
        log('Registration successful: ${response.data.toString()}');
        CustomToast().showToast(
          context: context,
          message: 'Otp Sent Sucessfully',
          isSuccess: true,
        );
        Get.toNamed(
          AppRoutes.verifynumberScreen,
          arguments: [phoneNumberController],
        );
      } else if (response is RegisterResponseError) {
        log("Registration failed: ${response.error.errorMessage}");
        CustomToast().showToast(
          context: context,
          message: response.error.errorMessage,
          isSuccess: false,
        );
        errorMessage(response.error.errorMessage);
      } else {
        log('Unexpected response type: ${response.runtimeType}');
        CustomToast().showToast(
          context: context,
          message: 'Unexpected response from server',
          isSuccess: false,
        );
        errorMessage('Unexpected response from server');
      }
    } catch (e) {
      log('Failed to register user: $e');
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
    emailController.clear();
    passwordController.clear();
    phoneNumberController.clear();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
