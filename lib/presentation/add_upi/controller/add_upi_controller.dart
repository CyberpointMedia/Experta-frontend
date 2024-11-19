import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/add_upi/model/add_upi_model.dart';
import 'package:flutter/material.dart';

class AddUpiController extends GetxController {
  Rx<AddUpiModel> acountSettingModelObject = AddUpiModel().obs;
  final upiController = TextEditingController();
  ApiService apiService = ApiService();
  final focus1 = FocusNode();
  final isLoading = false.obs;

  String? validateUpiId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter UPI ID';
    }

    // Basic UPI ID validation pattern
    final upiPattern = RegExp(r'^[\w\.\-_]{3,}@[a-zA-Z]{3,}$');
    if (!upiPattern.hasMatch(value)) {
      return 'Please enter a valid UPI ID';
    }
    return null;
  }

  Future<void> saveUpiId() async {
    final upiId = upiController.text.trim();
    final validation = validateUpiId(upiId);

    if (validation != null) {
      Get.snackbar('Error', validation,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final response = await apiService.saveUpiId(upiId);

      if (response['status'] == 'success') {
        Get.back();
        Get.snackbar('Success', 'UPI ID saved successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save UPI ID',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    upiController.dispose();
    focus1.dispose();
    super.onClose();
  }
}
