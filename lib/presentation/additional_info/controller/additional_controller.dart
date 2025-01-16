import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/additional_info/model/additional_model.dart';

import '../model/interest_model.dart';

class AdditionalInfoController extends GetxController {
  Rx<LanguageResponseModel> languageData =
      LanguageResponseModel(status: '', data: Data(languages: [])).obs;
  Rx<InterestResponseModel> interestData =
      InterestResponseModel(status: '', interests: []).obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLanguageData();
    fetchInterestData();
  }


 Future<void> saveSelectedLanguages(List<Language> languaged) async {
    try {
      var languageIds = languaged.map((lang) => lang.id).toList();
      var response = await ApiService().postSelectedLanguages(languageIds);
      if (response["status"] == "success") {
       // Get.offAndToNamed(AppRoutes.editProfileSetting);
      }
      debugPrint("API Response: $response");
    } catch (e) {
      debugPrint("Error saving selected languages: $e");
    }
  }


  void fetchLanguageData() async {
    isLoading(true);
    languageData.value = await ApiService().fetchLanguages();
    isLoading(false);
  }

  void fetchInterestData() async {
    isLoading(true);
    interestData.value = await ApiService().fetchInterests();
    isLoading(false);
  }
}
