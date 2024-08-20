// home_controller.dart
import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  var industries = <Industry>[].obs;
  var usersByIndustry = <String, List<User>>{}.obs;
  var trendingPeople = <User>[].obs;
  var isLoading = false.obs;
  var searchResults = <SearchResult>[].obs; // Update this line
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchIndustries();
    fetchTrendingPeople();
    searchController.addListener(_onSearchChanged);
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

  void fetchTrendingPeople() async {
    isLoading.value = true;
    try {
      final response =
          await http.get(Uri.parse('http://3.110.252.174:8080/api/trending'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'] as List;
        trendingPeople.value = data.map((json) => User.fromJson(json)).toList();
      } else {
        print('Failed to load trending people: ${response.statusCode}');
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
