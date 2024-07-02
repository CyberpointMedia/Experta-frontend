import 'package:experta/core/app_export.dart';
import 'package:experta/data/apiClient/api_service.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';
import 'package:get/get.dart';

class EducationController extends GetxController {
  var educationList = <Education>[].obs;
  final ApiService apiService = ApiService();
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEducation();
  }

  Future<void> fetchEducation() async {
    isLoading(true);
    try {
      final educationData = await apiService.fetchEducation();
      educationList.value = educationData;
    } catch (e) {
      throw Exception('Failed to load education: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> saveEducation(Education education) async {
    isLoading(true);
    try {
      await apiService.saveEducation(education);
      fetchEducation();
    } catch (e) {
      throw Exception('Failed to save education: $e');
    } finally {
      isLoading(false);
    }
  }

  @override
  void dispose() {
    fetchEducation();
    super.dispose();
  }
}
