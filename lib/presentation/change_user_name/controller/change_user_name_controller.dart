import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/change_user_name/models/change_user_name_model.dart';


class ChangeUserNameController extends GetxController {
  Rx<ChangeUserNameModel> changeUserNameModelObject = ChangeUserNameModel().obs;

  TextEditingController textField1 = TextEditingController();
  FocusNode focus1 = FocusNode();
}