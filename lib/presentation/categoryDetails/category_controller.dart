import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryDetailController extends GetxController {
  var users = <User>[].obs;
  var usersByIndustry = <String, List<User>>{}.obs;
  var isLoading = false.obs;

  void fetchUsersByIndustry(String industryId) async {
    isLoading.value = true; // Set isLoading to true before fetching data
    try {
      final response = await http.get(Uri.parse(
          'http://3.110.252.174:8080/api/user/by-industry/$industryId'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'] as List;
        print(
            'Users data for industry $industryId: $data'); // Add this line to log the data
        usersByIndustry[industryId] =
            data.map((json) => User.fromJson(json)).toList();
      } else {
        print(
            'Failed to load users for industry $industryId: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false; // Set isLoading to false after fetching data
    }
  }
}
