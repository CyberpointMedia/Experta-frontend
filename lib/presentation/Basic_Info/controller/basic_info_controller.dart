import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Basic_Info/models/basic_model.dart';
import 'package:flutter/material.dart';

class BasicProfileInfoController extends GetxController {
  Rx<BasicProfileInfoModel> basicInfoModelObj = BasicProfileInfoModel().obs;
  TextEditingController textField1 = TextEditingController();
  TextEditingController textField2 = TextEditingController();
  TextEditingController textField3 = TextEditingController();
  TextEditingController textField4 = TextEditingController();
  FocusNode focus1 = FocusNode();
  FocusNode focus2 = FocusNode();
  FocusNode focus3 = FocusNode();
  FocusNode focus4 = FocusNode();
}
