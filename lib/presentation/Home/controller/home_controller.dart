// home_controller.dart
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:experta/widgets/custom_toast_message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  var profileCompletion = Rxn<ProfileCompletion>();
  var industries = <Industry>[].obs;
  var usersByIndustry = <String, List<User>>{}.obs;
  var trendingPeople = <User>[].obs;
  var isLoading = false.obs;
  var searchResults = <SearchResult>[].obs;
  TextEditingController searchController = TextEditingController();
  final String? address = PrefUtils().getaddress();

  Future<void> refreshData(BuildContext context) async {
    try {
      isLoading.value = true;

      // Parallel execution of data fetching for better performance
      await Future.wait([
        _refreshTrendingPeople(),
      ]);

      // Clear search results when refreshing
      searchController.clear();
      searchResults.clear();
    } catch (e) {
      // Error handling
      debugPrint('Error refreshing data: $e');
      
      CustomToast().showToast(
        context: context,
        message: 'Failed to refresh data. Please try again.',
        isSuccess: false,
      );
      
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _refreshTrendingPeople() async {
    final updatedTrendingPeople = await fetchTrendingPeople();
    trendingPeople.value = updatedTrendingPeople;
  }

  Future<void> fetch() async {
    trendingPeople.value = await fetchTrendingPeople();
  }

  @override
  void onInit() {
    super.onInit();
    fetchIndustries();
    searchController.addListener(_onSearchChanged);
    fetchProfileCompletion(address.toString());
    fetch();
  }

  void _onSearchChanged() {
    if (searchController.text.isNotEmpty) {
      fetchUsersBySearch(searchController.text);
    } else {
      searchResults.clear();
    }
  }

  void fetchUsersBySearch(String query) async {
    isLoading.value = true;
    try {
      final response = await http.get(
          Uri.parse('http://3.110.252.174:8080/api/getUserBySearch/$query'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'] as List;
        searchResults.value =
            data.map((json) => SearchResult.fromJson(json)).toList();
      } else {
        print('Failed to load search results: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchIndustries() async {
    isLoading.value = true;
    try {
      final response =
          await http.get(Uri.parse('http://3.110.252.174:8080/api/industry'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'] as List;
        industries.value = data.map((json) => Industry.fromJson(json)).toList();
        fetchUsersForIndustries();
      } else {
        print('Failed to load industries: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchUsersForIndustries() {
    for (var industry in industries) {
      fetchUsersByIndustry(industry.id);
    }
  }

  void fetchUsersByIndustry(String industryId) async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          'http://3.110.252.174:8080/api/user/by-industry/$industryId'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'] as List;
        usersByIndustry[industryId] =
            data.map((json) => User.fromJson(json)).toList();
      } else {
        print(
            'Failed to load users for industry $industryId: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

// Modify your API call function to return Future<List<User>>
  Future<List<User>> fetchTrendingPeople() async {
    try {
      final response =
          await http.get(Uri.parse('http://3.110.252.174:8080/api/trending'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'] as List;
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load trending people: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void fetchProfileCompletion(String userId) async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          'http://3.110.252.174:8080/api/profile-completion/$userId'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        profileCompletion.value = ProfileCompletion.fromJson(data);
      } else {
        print('Failed to load profile completion data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // @override
  // void onClose() {
  //   searchController.dispose();
  //   super.onClose();
  // }
}