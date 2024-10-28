import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/blocked/controller/blocked_controller.dart';
import 'package:experta/presentation/blocked/models/blocked_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockedPage extends StatefulWidget {
  const BlockedPage({super.key});

  @override
  State<BlockedPage> createState() => _BlockedPageState();
}

class _BlockedPageState extends State<BlockedPage> {
  final BlockedController controller = Get.put(BlockedController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundBlur(),
          Column(
            children: [
              _buildAppBar(),
              // Add a gap of 70 between AppBar and Search Bar
              const SizedBox(height: 15),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Padding to match the AppBar
                  child: Column(
                    children: [
                      const CustomSearchView(
                        hintText: "Search user",
                      ),
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (controller.blockedUsers.isEmpty) {
                            return const Center(
                                child: Text('No blocked users'));
                          }
                          return ListView.builder(
                            itemCount: controller.blockedUsers.length,
                            itemBuilder: (context, index) {
                              final user = controller.blockedUsers[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical:
                                        8.0), // Optional vertical padding between items
                                child: UserTile(
                                  user: user,
                                  onUnblock: () {
                                    controller.unblockUser(user);
                                  },
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
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
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: onTapArrowLeft,
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Blocked"),
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: Colors.black),
          onPressed: () {
            Get.toNamed(AppRoutes.blocksearch);
            // Define what should happen when the plus icon is pressed
            print("Plus icon pressed");
          },
        ),
      ],
    );
  }

  void onTapArrowLeft() {
    Get.back();
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
                color: appTheme.deepOrangeA20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final BlockedUser user;
  final VoidCallback onUnblock;

  const UserTile({super.key, required this.user, required this.onUnblock});

  bool _isSvg(String url) {
    return url.toLowerCase().endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Add padding to match the AppBar
      leading: ClipOval(
        child: SizedBox(
          width: 40.0, // Adjust the size as needed
          height: 40.0,
          child: _isSvg(user.profilePic)
              ? SvgPicture.network(
                  user.profilePic,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  user.profilePic,
                  fit: BoxFit.cover,
                ),
        ),
      ),
      title: Row(
        children: [
          Text(user.displayName.isNotEmpty ? user.displayName : 'Anonymous'),
          if (user.isVerified) ...[
            const SizedBox(width: 4),
            const Icon(Icons.verified, color: Colors.blue, size: 16),
          ],
        ],
      ),
      subtitle: Text(user.industry.isNotEmpty ? user.industry : 'No industry'),
      trailing: ElevatedButton(
        onPressed: onUnblock,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0), // Rectangular shape
          ),
          backgroundColor: Colors.white,
          minimumSize: const Size(100, 50), // Set width and height
        ),
        child: const Text(
          'Unblock',
          style: TextStyle(
            color: Colors.black, // Text color black
          ),
        ),
      ),
    );
  }
}
