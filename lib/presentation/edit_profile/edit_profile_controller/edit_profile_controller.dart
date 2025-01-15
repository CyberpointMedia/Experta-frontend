import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:get/get.dart';
import '../../../core/app_export.dart';
import 'package:experta/presentation/edit_profile/models/edit_profile_model.dart';

class EditSettingController extends GetxController {
  Rx<EditProfileSettingModel> settingModelObj = EditProfileSettingModel().obs;
  ProfileCompletion? profileCompletion;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is ProfileCompletion) {
      profileCompletion = Get.arguments as ProfileCompletion;
    }
  }
}
