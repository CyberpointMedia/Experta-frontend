import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:experta/presentation/search_screen/models/search_model.dart';

class SearchPageController extends GetxController {
  TextEditingController searchPageController = TextEditingController();
  RxList<SearchResult> searchResults = <SearchResult>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    searchPageController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (searchPageController.text.isNotEmpty) {
      fetchUsersBySearch(searchPageController.text);
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

  @override
  void onClose() {
    searchPageController.clear();
    super.onClose();
  }
}
