import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/change_gender/models/change_gender_model.dart';
import 'package:flutter/material.dart';

class ChangeGenderController extends GetxController{

  Rx<ChangeGenderModel> acountSettingModelObject = ChangeGenderModel().obs;
TextEditingController textField1 = TextEditingController();
FocusNode focus1 = FocusNode();

}