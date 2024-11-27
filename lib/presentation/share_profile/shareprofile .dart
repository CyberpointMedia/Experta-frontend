import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'controller/share_profile_controller.dart';

class ShareProfilePage extends StatelessWidget {
  final ShareProfileController controller = Get.put(ShareProfileController());
  final screenshotController = ScreenshotController();

  ShareProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profileData = controller.profileData.value?.data!.profileData;
        final qrCode = controller.profileData.value!.data!.qrCode;

        if (profileData == null || qrCode == null) {
          return const Center(child: Text('No data available'));
        }

        return Screenshot(
          controller: screenshotController,
          child: Stack(
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
                    child: Container(
                      width: 252.adaptSize,
                      height: 252.adaptSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(126),
                        color: appTheme.deepOrangeA20,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildAppBar(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 100.h, horizontal: 26.v),
                    child: Container(
                      height: 400.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: appTheme.whiteA700.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 40.h),
                          Text(
                            profileData.name.toString(),
                            style: theme.textTheme.titleLarge!.copyWith(
                              fontSize: 18.fSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            profileData.occupation.toString(),
                            style: theme.textTheme.titleSmall!.copyWith(
                              fontSize: 16.fSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.h),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: _buildQRCode(qrCode),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildShareButton(context),
                  SizedBox(height: 20.h),
                ],
              ),
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: appTheme.whiteA700,
                    radius: 43.adaptSize,
                    child: CircleAvatar(
                      backgroundColor: appTheme.whiteA700,
                      radius: 40.adaptSize,
                      backgroundImage:
                          NetworkImage(profileData.profilePic.toString()),
                      onBackgroundImageError: (exception, stackTrace) {
                        print('Error loading profile image: $exception');
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQRCode(String qrCode) {
    try {
      final qrImageData = base64Decode(qrCode.split(',')[1]);
      return Image.memory(
        qrImageData,
        width: 100.adaptSize,
        height: 100.adaptSize,
        fit: BoxFit.contain,
      );
    } catch (e) {
      return const Center(child: Text('Invalid QR Code'));
    }
  }

  Future<void> _shareProfile(BuildContext context) async {
    try {
      // Get profile data from controller
      final profileData = controller.profileData.value!.data!.profileData;
      final qrCode = controller.profileData.value!.data!.qrCode;

      if (profileData == null || qrCode == null) {
        Get.snackbar('Error', 'Profile data not available');
        return;
      }

      final Uint8List imageBytes = await screenshotController.captureFromWidget(
        Material(
          child: MediaQuery(
            data: const MediaQueryData(),
            child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 100.h,
                          horizontal: 26.h,
                        ),
                        child: Container(
                          height: 400.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: appTheme.whiteA700.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 40.h),
                              Text(
                                profileData.name.toString(),
                                style: theme.textTheme.titleLarge!.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                profileData.occupation.toString(),
                                style: theme.textTheme.titleSmall!.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: _buildQRCode(qrCode),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 140,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: appTheme.whiteA700,
                        radius: 43,
                        child: CircleAvatar(
                          backgroundColor: appTheme.whiteA700,
                          radius: 40,
                          backgroundImage:
                              NetworkImage(profileData.profilePic.toString()),
                          onBackgroundImageError: (_, __) {},
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    right: 0,
                    left: 0,
                    child: CustomImageView(
                      imagePath: ImageConstant.dashboard,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        pixelRatio: 3.0,
        // targetSize: const Size(1080, 1920),
      );

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/profile_card.png').create();
      await file.writeAsBytes(imageBytes, flush: true);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Check out my profile: https://your-profile-link.com',
      );
    } catch (e) {
      print('Error sharing profile: $e');
      Get.snackbar('Error', 'Failed to share profile');
    }
  }

  Widget _buildShareButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _shareProfile(context),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50.h,
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            "Share My QR",
            style: TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
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
        onTap: () => Get.back(),
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Share Profile"),
    );
  }
}
