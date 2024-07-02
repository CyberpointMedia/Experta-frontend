import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/add_upi/model/add_upi_model.dart';
import 'package:flutter/material.dart';


class AddUpiController extends GetxController{

  Rx<AddUpiModel> acountSettingModelObject = AddUpiModel().obs;
TextEditingController textField1 = TextEditingController();
FocusNode focus1 = FocusNode();

}