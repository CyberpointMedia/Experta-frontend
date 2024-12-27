import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/set_availability/edit_set_avail/controller/edit_set_avail_controller.dart';
import 'package:experta/presentation/set_availability/model/set_availability_model.dart';
import 'package:experta/widgets/custom_text_form_field.dart';

class EditSetAvailability extends StatefulWidget {
  const EditSetAvailability({super.key});

  @override
  State<EditSetAvailability> createState() => _EditSetAvailabilityState();
}

class _EditSetAvailabilityState extends State<EditSetAvailability> {
  SetAvailabilityModel? availability;
  EditSetAvailableController controller = Get.put(EditSetAvailableController());
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    availability = Get.arguments as SetAvailabilityModel?;
    if (availability != null) {
      controller.textField1.text = availability!.startTime;
      controller.textField2.text = availability!.endTime;
      controller.setInitialSelectedDays(availability!.weeklyRepeat);
    }
    // Simulate a delay for loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundBlur(),
          isLoading
              ? _buildShimmerEffect()
              : Column(
                  children: [
                    _buildAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildBody(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 30, left: 16, right: 16),
                      child: CustomElevatedButton(
                        text: "Save",
                        onPressed: () async {
                          setState(() {
                            isSaving = true;
                          });
                          await controller.saveAvailability(availability);
                          setState(() {
                            isSaving = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
          if (isSaving) _buildCircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildBackgroundBlur() {
    return Positioned(
      left: 270,
      top: 50,
      child: ImageFiltered(
        imageFilter:
            ImageFilter.blur(tileMode: TileMode.decal, sigmaX: 60, sigmaY: 60),
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
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAppBar(),
        Expanded(
          child: _buildBody(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
          child: CustomElevatedButton(
            text: "Save",
            onPressed: () async {
              setState(() {
                isSaving = true;
              });
              await controller.saveAvailability(availability);
              setState(() {
                isSaving = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCircularProgressIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(),
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
      title: AppbarSubtitleSix(
        text: availability == null ? 'Add Slot' : 'Edit Slot',
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Time Duration",
            style: CustomTextStyles.labelMediumBlack900,
          ),
          _formFields(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Weekly Repeat",
              style: CustomTextStyles.labelMediumBlack900,
            ),
          ),
          _buildWeeklyRepeat(),
        ],
      ),
    );
  }

  Widget _formFields() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 0.v),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              "Start Time",
              style: CustomTextStyles.labelMediumGray900,
              textAlign: TextAlign.start,
            ),
          ),
          GestureDetector(
            onTap: () => controller.selectTime(context, controller.textField1),
            child: AbsorbPointer(
              child: CustomTextFormField(
                width: MediaQuery.of(context).size.width,
                controller: controller.textField1,
                focusNode: controller.focus1,
                hintText: "Select Time".tr,
                hintStyle: CustomTextStyles.titleMediumBluegray300,
                textInputType: TextInputType.datetime,
                suffix: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CustomImageView(
                    imagePath: ImageConstant.clock,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 10),
            child: Text(
              "End Time",
              style: CustomTextStyles.labelMediumGray900,
              textAlign: TextAlign.start,
            ),
          ),
          GestureDetector(
            onTap: () => controller.selectTime(context, controller.textField2),
            child: AbsorbPointer(
              child: CustomTextFormField(
                controller: controller.textField2,
                focusNode: controller.focus2,
                width: MediaQuery.of(context).size.width,
                hintText: "Select Time".tr,
                hintStyle: CustomTextStyles.titleMediumBluegray300,
                textInputType: TextInputType.datetime,
                suffix: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CustomImageView(
                    imagePath: ImageConstant.clock,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyRepeat() {
    List<String> days = ["S", "M", "T", "W", "T", "F", "S"];
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days.asMap().entries.map((entry) {
            int idx = entry.key;
            String day = entry.value;

            return GestureDetector(
              onTap: () {
                controller.updateSelectedDayIndex(idx);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: appTheme.whiteA700,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: controller.selectedDays[idx]
                          ? Colors.yellow
                          : Colors.grey),
                ),
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: controller.selectedDays[idx]
                          ? Colors.black
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ));
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
