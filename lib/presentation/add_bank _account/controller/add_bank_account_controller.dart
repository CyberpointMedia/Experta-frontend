
import 'package:experta/presentation/add_bank%20_account/models/add_bank_account_models.dart';
import 'package:flutter/material.dart';
import 'package:experta/core/app_export.dart';

class AddBankAccountController extends GetxController{

  Rx<AddBankAccountModel> acountSettingModelObject = AddBankAccountModel().obs;
TextEditingController textField1 = TextEditingController();
FocusNode focus1 = FocusNode();

}