import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/dashboard/controller/dashboard_controller.dart';
import 'package:experta/presentation/search_screen/controller/search_controller.dart';
import 'package:experta/presentation/search_screen/models/search_model.dart';
import 'package:experta/presentation/search_screen/widgets/search_item_widget.dart';
import 'package:experta/widgets/animated_hint_searchview.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchPageController controller = Get.put(SearchPageController());
  final DashboardController dashController = Get.find<DashboardController>();
  final List<String> hintTexts = [
    "lbl_influencer".tr,
    "Search Users",
    "Find Friends",
    "Find Cunsultants",
    "Search Categories",
    "Search Interested Positions"
  ];

  @override
  void initState() {
    final dynamic arguments = dashController.pageArguments;
    print('Arguments: $arguments');
    if (arguments != "") {
      if (arguments['searchResults'] != null &&
          arguments['searchQuery'] != null) {
        controller.searchResults.value = List<SearchResult>.from(
          arguments['searchResults'].map((item) => SearchResult.fromJson(item)),
        );
        controller.searchPageController.text = arguments['searchQuery'];
      } else {
        print('Arguments are missing searchResults or searchQuery');
      }
    } else {
      print('Arguments are null');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 25),
                  child: Row(
                    children: [
                      CustomAnimatedSearchView(
                        width: MediaQuery.of(context).size.width * 0.73,
                        controller: controller.searchPageController,
                        hintTextDuration: const Duration(seconds: 2),
                        hintTexts: hintTexts,
                        onChanged: (value) {
                          controller.fetchUsersBySearch(value);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.h),
                        child: TextButton(
                          onPressed: () =>
                              controller.searchPageController.clear(),
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

  Widget _buildSearch() {
    return Expanded(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(left: 16.h),
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              // ignore: invalid_use_of_protected_member
              if (controller.searchResults.value.isEmpty) {
                return const Center(child: Text("No results found"
                ));
              }
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 1.v);
                },
                // ignore: invalid_use_of_protected_member
                itemCount: controller.searchResults.value.length,
                itemBuilder: (context, index) {
                  // ignore: invalid_use_of_protected_member
                  SearchResult model = controller.searchResults.value[index];
                  return SearchItemWidget(model);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
