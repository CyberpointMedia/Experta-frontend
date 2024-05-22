import '../../../core/app_export.dart';import '../models/message_model.dart';import 'package:flutter/material.dart';/// A controller class for the MessageScreen.
///
/// This class manages the state of the MessageScreen, including the
/// current messageModelObj
class MessageController extends GetxController {TextEditingController searchController = TextEditingController();

Rx<MessageModel> messageModelObj = MessageModel().obs;

@override void onClose() { super.onClose(); searchController.dispose(); } 
 }
