import 'package:experta/presentation/message_chat_with_user_default_screen/controller/message_chat_with_user_default_controller.dart';
import 'package:get/get.dart';

/// A binding class for the MessageChatWithUserDefaultScreen.
///
/// This class ensures that the MessageChatWithUserDefaultController is created when the
/// MessageChatWithUserDefaultScreen is first loaded.
class MessageChatWithUserDefaultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageChatWithUserDefaultController());
  }
}
