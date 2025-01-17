import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// A controller class for the CategoryScreen.
///
/// This class manages the state of the CategoryScreen,
/// fetching and handling category data.
class CategoryController extends GetxController {
  var industries = <Industry>[].obs;
  var subIndustries = <Industry>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchIndustriesByLevel(1); // Fetch level 1 industries on init
  }

  /// Fetches industries from the API based on the given level.
  Future<void> fetchIndustriesByLevel(int level) async {
    final url =
        Uri.parse('http://3.110.252.174:8080/api/services/level/$level');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);
      final jsonData = json.decode(response.body);

      industries.value = (jsonData['data'] as List)
          .map((industry) => Industry.fromJson(industry))
          .toList();
    } else {
      throw Exception('Failed to load industries');
    }
  }

  /// Fetches sub-industries from the API based on the given parentId.
  Future<void> fetchIndustriesByParentId(String parentId, int level) async {
    final url = Uri.parse(
        'http://3.110.252.174:8080/api/services/level/$level?parentId=$parentId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);
      final jsonData = json.decode(response.body);
      subIndustries.value = (jsonData['data'] as List)
          .map((industry) => Industry.fromJson(industry))
          .toList();
    } else {
      throw Exception('Failed to load sub-industries');
    }
  }
}

/// A binding class for the CategoryScreen.
///
/// This class ensures that the CategoryController is created when the
/// CategoryScreen is first loaded.
class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryController());
  }
}
