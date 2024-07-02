import 'dart:developer';
import 'package:experta/core/app_export.dart';
import 'package:experta/data/apiClient/api_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SetPricingController extends GetxController {
  TextEditingController textField1 = TextEditingController();
  TextEditingController textField2 = TextEditingController();
  FocusNode focus1 = FocusNode();
  FocusNode focus2 = FocusNode();
  FocusNode focus3 = FocusNode();
  ApiService apiServices = ApiService();

  // List to keep track of dynamically added text fields
  var additionalTextFields = <TextEditingController>[].obs;
  var showAddButton = true.obs;
  var loading = false.obs; // Add this line

  Future<void> savePricing() async {
    loading.value = true; // Set loading to true when the save process starts
    final audioCallPrice = int.tryParse(textField1.text) ?? 0;
    final videoCallPrice = int.tryParse(textField2.text) ?? 0;
    final messagePrice = additionalTextFields.isNotEmpty
        ? int.tryParse(additionalTextFields.first.text) ?? 0
        : 0;

    final body = {
      "audioCallPrice": audioCallPrice,
      "videoCallPrice": videoCallPrice,
      "messagePrice": messagePrice,
    };

    try {
      final responseData = await apiServices.createUserPricing(body);
      log("pricing response === $responseData");
      if (responseData['status'] == 'success') {
        Get.offAndToNamed(AppRoutes.editProfileSetting);
        Get.snackbar('Success', 'Pricing saved successfully');
      } else {
        Get.snackbar('Error', 'Failed to save pricing');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save pricing');
    } finally {
      loading.value = false; // Set loading to false when the save process ends
    }
  }
}
