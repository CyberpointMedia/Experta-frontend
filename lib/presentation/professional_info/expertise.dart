import 'dart:ui';

import 'package:experta/presentation/professional_info/controller/expertise_controller.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';

import '../../core/app_export.dart';

class ExpertiseView extends StatelessWidget {
  final ExpertiseController controller = Get.put(ExpertiseController());
  final TextEditingController searchController = TextEditingController();
  final List<ExpertiseItem> selectedItems;

  ExpertiseView({super.key, required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    // Initialize selected items
    controller.initializeSelectedItems(selectedItems);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Positioned(
            left: 270,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                  tileMode: TileMode.decal, sigmaX: 60, sigmaY: 60),
              child: Align(
                child: SizedBox(
                  width: 252,
                  height: 252,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(126),
                      color: appTheme.deepOrangeA20.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchView(
                  controller: searchController,
                  hintText: "Search Your Interest",
                  onChanged: (value) {
                    controller.filterItems(value);
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.filteredItems.isEmpty) {
                    return const Center(
                        child: Text('No expertise items available'));
                  } else {
                    return ListView.builder(
                      itemCount: controller.filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.filteredItems[index];
                        return Obx(() {
                          final isSelected =
                              controller.selectedItems.contains(item);
                          return ListTile(
                            title: Text(item.name),
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged: (bool? value) {
                                controller.toggleSelection(item);
                              },
                            ),
                          );
                        });
                      },
                    );
                  }
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomElevatedButton(
                  onPressed: () {
                    controller.saveSelectedExpertise();
                  },
                  text: "Save",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.cross,
        margin: EdgeInsets.only(left: 16.h),
        onTap: onTapArrowLeft,
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Add Expertise"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
