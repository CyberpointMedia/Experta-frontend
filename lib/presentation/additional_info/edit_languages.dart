import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/additional_info/model/interest_model.dart';
import 'package:experta/presentation/additional_info/controller/language_controller.dart';

class EditLanguagePage extends StatelessWidget {
  final List<Language> initialSelectedLanguages;

  const EditLanguagePage({super.key, required this.initialSelectedLanguages});

  @override
  Widget build(BuildContext context) {
    final LanguageController controller = Get.put(LanguageController());

    controller.setInitialSelectedLanguages(initialSelectedLanguages);

    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundBlur(),
          Obx(() {
            if (controller.isLoading.value) {
              return _buildShimmerEffect(context, controller);
            } else {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildAppBar()),
                  SliverToBoxAdapter(
                    child: _bodyWidget(context, controller),
                  ),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildBackgroundBlur() {
    return Positioned(
      left: 270,
      top: 50,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Align(
          child: SizedBox(
            width: 252,
            height: 252,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(126),
                color: Colors.deepOrange.withOpacity(0.2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: onTapArrowLeft,
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Edit Languages"),
    );
  }

  Widget _bodyWidget(BuildContext context, LanguageController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          CustomSearchView(
            hintText: "Search your language",
            onChanged: (query) {
              if (query.isEmpty) {
                controller.resetLanguages();
              } else {
                controller.filterLanguages(query);
              }
            },
          ),
          const SizedBox(height: 10),
          _buildLanguageList(controller, context),
          const SizedBox(height: 10),
          _buildSaveButton(controller),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "What’s your language?",
            style: CustomTextStyles.titleMediumBlack90001,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Pick your favorite languages to find groups and events related to them",
            style: CustomTextStyles.bodyMediumLight,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageList(
      LanguageController controller, BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        child: ListView.builder(
          itemCount: controller.filteredLanguages.length,
          itemBuilder: (context, index) {
            final language = controller.filteredLanguages[index];
            return Obx(() {
              final isSelected =
                  controller.selectedLanguages.contains(language);
              return Column(
                children: [
                  Container(
                    color: isSelected
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    child: ListTile(
                      title: Text(
                        language.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check,
                              color: appTheme.black900,
                            )
                          : null,
                      onTap: () {
                        controller.toggleSelection(language);
                      },
                    ),
                  ),
                  const Divider(),
                ],
              );
            });
          },
        ),
      );
    });
  }

  Widget _buildSaveButton(LanguageController controller) {
    return Obx(() {
      return CustomElevatedButton(
        onPressed: controller.selectedLanguages.isNotEmpty
            ? () async {
                await controller.saveSelectedLanguages();
              }
            : () {
                Get.snackbar('Error', 'Failed to save User Language');
              },
        text: "Save",
      );
    });
  }

  void onTapArrowLeft() {
    Get.back();
  }

  Widget _buildShimmerEffect(
      BuildContext context, LanguageController controller) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(),
          _bodyWidget(context, controller),
        ],
      ),
    );
  }
}
