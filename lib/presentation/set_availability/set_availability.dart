import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/set_availability/controller/set_availability_controller.dart';
import 'package:experta/presentation/set_availability/model/set_availability_model.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_image.dart';
import 'package:intl/intl.dart';

class SetAvailability extends StatefulWidget {
  const SetAvailability({super.key});

  @override
  State<SetAvailability> createState() => _SetAvailabilityState();
}

class _SetAvailabilityState extends State<SetAvailability> {
  final SetAvailabilityController controller =
      Get.put(SetAvailabilityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundBlur(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAppBar(),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return _buildShimmerEffect();
                  } else {
                    return ListView.builder(
                      itemCount: controller.availabilityList.length,
                      itemBuilder: (context, index) {
                        final availability = controller.availabilityList[index];
                        return GestureDetector(
                          onTap: () {
                            Get.offAndToNamed(AppRoutes.editSetAvail,
                                arguments: availability);
                          },
                          child:
                              _buildAvailabilityCard(availability, index + 1),
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        );
      },
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
                color: appTheme.deepOrangeA20.withOpacity(0.6),
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
      title: AppbarSubtitleSix(text: "Set Availability"),
      actions: [
        AppbarTrailingImage(
          margin: const EdgeInsets.only(right: 20),
          imagePath: ImageConstant.plus,
          onTap: () {
            Get.offAndToNamed(AppRoutes.editSetAvail);
          },
        ),
      ],
    );
  }

  Widget _buildAvailabilityCard(SetAvailabilityModel availability, int index) {
    return Dismissible(
      key: Key(availability.id),
      direction: DismissDirection.endToStart,
      background: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Card(
          color: Colors.red,
          child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 25),
                child: Icon(Icons.delete, color: Colors.white),
              )),
        ),
      ),
      onDismissed: (direction) {
        controller.deleteAvailability(availability.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0,),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Slot number with grey color
                  Text(
                    'Slot $index',
                    style: CustomTextStyles.bodyLargeBlack90001.copyWith(
                      color: Colors.grey, // Change slot text to grey
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${convertTo12HourFormat(availability.startTime)} - ${convertTo12HourFormat(availability.endTime)}',
                        style: CustomTextStyles.labelBigBlack900.copyWith(
                          color: Colors.black, // Change the time text to dark black
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.editSetAvail,
                              arguments: availability);
                        },
                        child: const Text(
                          'Edit',
                          // Optionally: you can add a custom style for Edit text here
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18.0),
                  // Selected day text with grey color
                  Text(
                    availability.isEveryday
                        ? 'Everyday'
                        : availability.weeklyRepeat
                            .join('  '), // Joining the days with spaces
                    style: CustomTextStyles.bodyLargeBlack90001.copyWith(
                      color: Colors.grey, // Change day text to grey
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String convertTo12HourFormat(String time24) {
    final DateFormat inputFormat = DateFormat('HH:mm');
    final DateFormat outputFormat = DateFormat('hh:mm a');
    final DateTime dateTime = inputFormat.parse(time24);
    return outputFormat.format(dateTime);
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
