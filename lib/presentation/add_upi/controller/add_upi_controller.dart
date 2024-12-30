import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/add_upi/model/add_upi_model.dart';
import 'package:experta/widgets/custom_toast_message.dart';

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

  Future<void> saveUpiId(BuildContext context) async {
    final upiId = upiController.text.trim();
    final validation = validateUpiId(upiId);

    if (validation != null) {
      CustomToast().showToast(
        context: context,
        message: validation,
        isSuccess: false,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await apiService.saveUpiId(upiId);

      if (response['status'] == 'success') {
        Get.back();

        CustomToast().showToast(
          context: context,
          message: 'UPI ID saved successfully',
          isSuccess: true,
        );
      }
    } catch (e) {
      CustomToast().showToast(
        context: context,
        message: 'Failed to save UPI ID',
        isSuccess: false,
      );
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
