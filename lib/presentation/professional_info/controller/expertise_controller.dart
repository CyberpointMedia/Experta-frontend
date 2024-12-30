import 'dart:developer';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';

class ExpertiseController extends GetxController {
  var isLoading = true.obs;
  var filteredItems = <ExpertiseItem>[].obs;
  var selectedItems = <ExpertiseItem>[].obs;
  var expertiseList = <ExpertiseItem>[].obs;
  final ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    log("onInit called");
    loadItems();
  }

  void initializeSelectedItems(List<ExpertiseItem> items) {
    log("initializeSelectedItems called with items: $items");
    selectedItems
      ..clear()
      ..addAll(items);
    // Ensure items are loaded before marking selected items
    if (filteredItems.isNotEmpty) {
      markSelectedItems();
    }
  }

  Future<void> loadItems() async {
    try {
      log("loadItems called");
      isLoading(true);
      var allItems = await getAllExpertiseItems();
      log("Items loaded: $allItems");
      filteredItems.assignAll(allItems);
      // Mark selected items after loading all items
      markSelectedItems();
    } catch (e) {
      log("Error loading items: $e");
    } finally {
      isLoading(false);
    }
  }

  void filterItems(String query) {
    log("filterItems called with query: $query");
    if (query.isEmpty) {
      loadItems();
    } else {
      filteredItems.assignAll(
        filteredItems
            .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  void toggleSelection(ExpertiseItem item) {
    log("toggleSelection called with item: $item");
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
  }

  Future<List<ExpertiseItem>> getAllExpertiseItems() async {
    try {
      log("getAllExpertiseItems called");
      final expertise = await apiService.fetchExpertiseItems();
      return expertise
          .map((e) => ExpertiseItem(id: e.id, name: e.name))
          .toList();
    } catch (e) {
      log("Error fetching expertise items: $e");
      return [];
    }
  }

  Future<void> saveSelectedExpertise() async {
    try {
      log("saveSelectedExpertise called");
      isLoading(true);
      List<String> expertiseIds =
          selectedItems.map((item) => item.id).toSet().toList();
      log("The selected items are: $selectedItems");
      log("The Expertise IDs are: $expertiseIds");
      var response = await apiService.saveExpertiseItems(expertiseIds);
      log("Saved IDs from API are: ${response['data']['_id']}");
      String savedId = response['data']['_id'];
      Get.back();
    } catch (e) {
      log("Error saving expertise: $e");
    } finally {
      isLoading(false);
    }
  }

  void markSelectedItems() {
    log("markSelectedItems called");
    final selectedIds = Set<String>.from(selectedItems.map((item) => item.id));
    final newlySelectedItems =
        filteredItems.where((item) => selectedIds.contains(item.id)).toList();
    selectedItems.assignAll(newlySelectedItems);
    log("Selected items after marking: $selectedItems");
  }

  void updateExpertiseList(List<ExpertiseItem> items) {
    log("updateExpertiseList called with items: $items");
    expertiseList.assignAll(items);
  }
}
