import '../../../core/app_export.dart';
import '../models/settings_log_out_model.dart';

/// A controller class for the SettingsLogOutDialog.
///
/// This class manages the state of the SettingsLogOutDialog, including the
/// current settingsLogOutModelObj
class SettingsLogOutController extends GetxController {
  Rx<SettingsLogOutModel> settingsLogOutModelObj = SettingsLogOutModel().obs;
  Future<void> logoutUser() async {
    // Clear user data, tokens, etc.
    // For example:
    // await authService.logout();
    // await storageService.clearUserData();
  }
}
