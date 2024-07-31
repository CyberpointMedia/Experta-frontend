
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/phone_number/models/phone_number_model.dart';

class PhoneNumberController extends GetxController {
  Rx<PhoneNumberModel> changeUserNameModelObject = PhoneNumberModel().obs;

  TextEditingController textField1 = TextEditingController();
  FocusNode focus1 = FocusNode();
}