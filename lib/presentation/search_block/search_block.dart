import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/animated_hint_searchview.dart'; // Your custom search view widget

// ignore: unused_import
import '../search_screen/widgets/search_item_widget.dart';

class ProfileBlockPage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  ProfileBlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background Blur Circle
            Positioned(
              left: 270,
              top: 50,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  tileMode: TileMode.decal,
                  sigmaX: 60,
                  sigmaY: 60,
                ),
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
            // Main Content
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 25),
                  child: Row(
                    children: [
                      // Search Bar on the left side of Cancel Button
                      Expanded(
                        child: CustomAnimatedSearchView(
                          // controller: searchController,
                          hintTexts: const ['Search users'], // Example hints
                          onChanged: (value) {
                            // Logic to perform search, e.g. controller.fetchUsersBySearch(value);
                          },
                          suffix: _buildClearIcon(), // Add cross icon
                        ),
                      ),
                      // Cancel Button on the right side
                      Padding(
                        padding:
                            EdgeInsets.only(left: 8.h), // Reduce the gap here
                        child: TextButton(
                          onPressed: () {
                            searchController.clear(); // Clear search text
                            // Optionally, add logic to close the search
                          },
                          child: Text(
                            "lbl_cancel".tr,
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: appTheme.gray900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Remaining content (e.g., search results)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearch(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Builds the clear icon with increased size
  Widget _buildClearIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 8.0), // Add padding around the icon
      child: IconButton(
        icon: Icon(
          Icons.clear,
          color: appTheme.gray900,
          size: 35, // Increase icon size here
        ),
        onPressed: () {
          searchController.clear(); // Clear the search text
        },
      ),
    );
  }

  // Search widget (list or search results)
  Widget _buildSearch() {
    return Expanded(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(left: 16.h),
          // Uncomment and modify this to display search results
          // child: Obx(
          //   () {
          //     if (controller.isLoading.value) {
          //       return const Center(child: CircularProgressIndicator());
          //     }
          //     if (controller.searchResults.value.isEmpty) {
          //       return const Center(child: Text("No results found"));
          //     }
          //     return ListView.separated(
          //       physics: const BouncingScrollPhysics(),
          //       shrinkWrap: true,
          //       separatorBuilder: (context, index) {
          //         return SizedBox(height: 1.v);
          //       },
          //       itemCount: controller.searchResults.value.length,
          //       itemBuilder: (context, index) {
          //         SearchResult model = controller.searchResults.value[index];
          //         return SearchItemWidget(model);
          //       },
          //     );
          //   },
          // ),
        ),
      ),
    );
  }
}
