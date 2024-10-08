import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/work_experience/controller/experience_controller.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_image.dart';
import 'package:experta/widgets/shimmer.dart';
import 'package:experta/widgets/work_experience_widget.dart';

class WorkExperiencePage extends StatefulWidget {
  const WorkExperiencePage({super.key});

  @override
  State<WorkExperiencePage> createState() => _WorkExperiencePageState();
}

class _WorkExperiencePageState extends State<WorkExperiencePage> {
  final WorkExperienceController controller =
      Get.put(WorkExperienceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
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
                      color: appTheme.deepOrangeA20.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildAppBar(), _buildBody()],
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
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: onTapArrowLeft,
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Work Experience"),
      actions: [
        AppbarTrailingImage(
          margin: const EdgeInsets.only(right: 20),
          imagePath: ImageConstant.plus,
          onTap: () {
            Get.toNamed(AppRoutes.editExperience);
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.setLoading.value) {
        return Expanded(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const ShimmerLoadingEffect(),
                  childCount: 10,
                ),
              ),
            ],
          ),
        );
      } else if (controller.workExperienceList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No work experience available.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Get.toNamed(AppRoutes.editExperience);
                },
                child: const Text('Add Work Experience'),
              ),
            ],
          ),
        );
      } else {
        return Expanded(
          child: ListView.builder(
            itemCount: controller.workExperienceList.length,
            itemBuilder: (context, index) {
              final workExperience = controller.workExperienceList[index];
              return WorkExperienceWidget(
                workExperience: workExperience,
                edit: true,
                onEdit: () {
                  // var result = Get.toNamed(AppRoutes.editExperience,
                  //     arguments: workExperience);

                  // if (result != null) {
                  //   controller.fetchData();
                  // }
                },
              );
            },
          ),
        );
      }
    });
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
