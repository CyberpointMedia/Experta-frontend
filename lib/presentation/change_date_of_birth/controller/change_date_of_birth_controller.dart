import 'package:experta/presentation/change_date_of_birth/models/change_date_of_birth_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ChangeDateOfBirthController extends GetxController {
  Rx<ChangeDateOfBirthModel> changeUserNameModelObject = ChangeDateOfBirthModel().obs;

  TextEditingController textField1 = TextEditingController();
  FocusNode focus1 = FocusNode();
}