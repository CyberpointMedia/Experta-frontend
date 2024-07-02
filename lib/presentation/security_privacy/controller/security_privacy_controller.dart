import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/setting_screen/models/setting_model.dart';

class SecurityPrivacyController extends GetxController {
  Rx<SettingModel> settingModelObj = SettingModel().obs;
}
