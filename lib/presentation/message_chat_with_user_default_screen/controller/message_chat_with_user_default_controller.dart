import '../../../core/app_export.dart';import '../models/message_chat_with_user_default_model.dart';import 'package:flutter/material.dart';/// A controller class for the MessageChatWithUserDefaultScreen.
///
/// This class manages the state of the MessageChatWithUserDefaultScreen, including the
/// current messageChatWithUserDefaultModelObj
class MessageChatWithUserDefaultController extends GetxController {TextEditingController messageController = TextEditingController();

Rx<MessageChatWithUserDefaultModel> messageChatWithUserDefaultModelObj = MessageChatWithUserDefaultModel().obs;

@override void onClose() { super.onClose(); messageController.dispose(); } 
 }
