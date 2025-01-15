import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/additional_info/model/additional_model.dart';

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
