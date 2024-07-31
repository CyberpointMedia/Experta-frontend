import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/call_settings/model/call_setting_model.dart';

class CallSettingsController extends GetxController {
  Rx<CallSettingModel> settingModelObj = CallSettingModel().obs;
}
