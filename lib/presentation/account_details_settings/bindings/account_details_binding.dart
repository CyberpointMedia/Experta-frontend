// bindings/settings_binding.dart
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/change_date_of_birth/controller/change_date_of_birth_controller.dart';
import 'package:experta/presentation/change_gender/controller/change_gender_controller.dart';
import 'package:experta/presentation/change_user_name/controller/change_user_name_controller.dart';
import 'package:experta/presentation/phone_number/controller/phone_number_controller.dart';

import '../../change_email/controller/change_email_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangeUserNameController>(() => ChangeUserNameController());
    Get.lazyPut<ChangeGenderController>(() => ChangeGenderController());
    Get.lazyPut<ChangeDateOfBirthController>(() => ChangeDateOfBirthController());
    Get.lazyPut<ChangeEmailController>(() => ChangeEmailController());
    Get.lazyPut<PhoneNumberController>(() => PhoneNumberController());
  }
}
