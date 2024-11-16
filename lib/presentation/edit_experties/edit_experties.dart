import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/professional_info/expertise.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class EditExpertisePage extends StatefulWidget {
  final List<ExpertiseItem> selectedItems;
  const EditExpertisePage({super.key, required this.selectedItems});

  @override
  State<EditExpertisePage> createState() => _EditExpertisePageState();
}

class _EditExpertisePageState extends State<EditExpertisePage> {
  late List<ExpertiseItem> expertise;

  final ApiService apiService = ApiService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    expertise = List.from(widget.selectedItems);
  }

  // Method to delete expertise
  void _deleteExpertise(ExpertiseItem item) {
    setState(() {
      expertise.remove(item);
    });
  }

  // Method to add new expertise
  void _addExpertise() {
    Navigator.pushReplacement(
      context,
      PageTransition(
        child: ExpertiseView(selectedItems: expertise),
        type: PageTransitionType.leftToRight,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Future<void> _saveExpertise() async {
    try {
      setState(() {
        isLoading = true;
      });

      // First fetch all expertise items to get their IDs
      List<ExpertiseItem> allExpertiseItems =
          await apiService.fetchExpertiseItems();

      // Match selected expertise names with fetched items to get their IDs
      List<String> expertiseIds = [];
      for (var selectedItem in expertise) {
        var matchingItem = allExpertiseItems.firstWhere(
          (item) => item.name.toLowerCase() == selectedItem.name.toLowerCase(),
          orElse: () =>
              throw Exception('Expertise "${selectedItem.name}" not found'),
        );
        expertiseIds.add(matchingItem.id);
      }

      // Save the expertise IDs
      await apiService.saveExpertiseItems(expertiseIds);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expertise saved successfully')),
      );

      Get.offAndToNamed(AppRoutes.professionalInfo);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save expertise: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expertise',
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              "Show your top expertise - add up to 5 skills you want to be known for. They'll also appear in your expertise section.",
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Wrap(
              children: expertise.map((item) {
                return Chip(
                  label: Text(
                    item.name,
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    _deleteExpertise(item);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.transparent),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _addExpertise,
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 8),
                        Text(
                          '+ Add Expertise',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: (isLoading)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CustomElevatedButton(
                      onPressed: _saveExpertise,
                      text: 'Save',
                    ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 60.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapArrowLeft();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Edit Expertise"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
