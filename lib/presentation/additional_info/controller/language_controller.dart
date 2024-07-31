import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/additional_info/model/interest_model.dart';

class LanguageController extends GetxController {
  var languages = <Language>[].obs;
  var filteredLanguages = <Language>[].obs;
  var selectedLanguages = <Language>{}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLanguages();
  }

  Future<void> fetchLanguages() async {
    try {
      isLoading(true);
      var response = await ApiService().fetchAllLanguages();
      var fetchedLanguages = (response['data'] as List)
          .map((json) => Language.fromJson(json))
          .toList();
      languages.assignAll(fetchedLanguages);
      filteredLanguages.assignAll(fetchedLanguages);
    } catch (e) {
      debugPrint("Error fetching languages: $e");
    } finally {
      isLoading(false);
    }
  }

  void setInitialSelectedLanguages(List<Language> initialSelectedLanguages) {
    selectedLanguages.addAll(initialSelectedLanguages);
  }

  void filterLanguages(String query) {
    if (query.isEmpty) {
      resetLanguages();
    } else {
      filteredLanguages.value = languages.where((language) {
        return language.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  void resetLanguages() {
    filteredLanguages.assignAll(languages);
  }

  void toggleSelection(Language language) {
    if (selectedLanguages.contains(language)) {
      selectedLanguages.remove(language);
    } else {
      selectedLanguages.add(language);
    }
    debugPrint("Selected languages: ${selectedLanguages.toList()}");
  }

  Future<void> saveSelectedLanguages() async {
    try {
      var languageIds = selectedLanguages.map((lang) => lang.id).toList();
      var response = await ApiService().postSelectedLanguages(languageIds);
      if (response["status"] == "success") {
        Get.offAndToNamed(AppRoutes.editProfileSetting);
      }
      debugPrint("API Response: $response");
    } catch (e) {
      debugPrint("Error saving selected languages: $e");
    }
  }
}
