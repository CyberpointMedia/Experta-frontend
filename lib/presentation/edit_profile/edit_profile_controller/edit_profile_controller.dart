import 'package:experta/presentation/edit_profile/models/edit_profile_model.dart';

import '../../../core/app_export.dart';

/// A controller class for the SettingScreen.
///
/// This class manages the state of the SettingScreen, including the
/// current settingModelObj
class EditSettingController extends GetxController {
  Rx<EditProfileSettingModel> settingModelObj = EditProfileSettingModel().obs;
}
