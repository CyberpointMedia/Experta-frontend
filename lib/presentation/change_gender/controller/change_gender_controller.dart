import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/change_gender/model/change_gender_model.dart';

class ChangeGenderController extends GetxController{

  Rx<ChangeGenderModel> acountSettingModelObject = ChangeGenderModel().obs;
TextEditingController textField1 = TextEditingController();
FocusNode focus1 = FocusNode();

  get selectedGender => null;

}