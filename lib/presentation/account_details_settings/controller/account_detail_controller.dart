// controllers/change_user_name_controller.dart
import 'package:experta/core/app_export.dart';

class ChangeUserNameController extends GetxController {
  final TextEditingController textField1 = TextEditingController();
}

// controllers/change_gender_controller.dart
class ChangeGenderController extends GetxController {
  final RxString selectedGender = ''.obs;

  void setGender(String gender) {
    selectedGender.value = gender;
  }
}

// controllers/change_date_of_birth_controller.dart
class ChangeDateOfBirthController extends GetxController {
  final TextEditingController textField1 = TextEditingController();
}

// controllers/change_email_controller.dart
class ChangeEmailController extends GetxController {
  final TextEditingController textField1 = TextEditingController();
}

// controllers/phone_number_controller.dart
class PhoneNumberController extends GetxController {
  final TextEditingController textField1 = TextEditingController();
}
