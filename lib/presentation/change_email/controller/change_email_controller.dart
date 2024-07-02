
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/change_email/models/change_email_model.dart';
import 'package:flutter/material.dart';

class ChangeEmailController extends GetxController {
  Rx<ChangeEmailModel> changeEmailModelObject =ChangeEmailModel().obs;

  TextEditingController textField1 = TextEditingController();
  FocusNode focus1 = FocusNode();
  
}