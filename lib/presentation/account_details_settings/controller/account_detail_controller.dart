import 'package:experta/core/app_export.dart';
// For JSON encoding
import 'package:http/http.dart' as http;


class AccountDetailsController extends GetxController {
   String? email = PrefUtils().getEmail();
  String? name = PrefUtils().getProfileName();
  String? mob = PrefUtils().getbasic();
  final TextEditingController textField1 = TextEditingController();
  final TextEditingController textField2 = TextEditingController();
  final TextEditingController textField3 = TextEditingController();
  final TextEditingController textField4 = TextEditingController();
  final TextEditingController textField5 = TextEditingController();

  final RxString selectedGender = ''.obs;

  final FocusNode focus1 = FocusNode();
  final FocusNode focus2 = FocusNode();
  final FocusNode focus3 = FocusNode();
  final FocusNode focus4 = FocusNode();
  final FocusNode focus5 = FocusNode();

  // Set gender
  void setGender(String gender) {
    selectedGender.value = gender;
  }
  // Update account settings API call
  Future<void> updateAccountSettings(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('http://3.110.252.174:8080/api/account-setting'),
      body: data,
    );

    if (response.statusCode == 200) {
      // Handle success
      print('Account settings updated successfully');
    } else {
      // Handle failure
      print('Failed to update account settings');
    }
  }
}