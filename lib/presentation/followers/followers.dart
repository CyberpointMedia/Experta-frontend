// followers_page.dart

import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/followers/controller/followers_controller.dart';
import 'package:experta/presentation/followers/models/followers_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FollowersPage extends StatefulWidget {
  const FollowersPage({super.key});

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  final String id = Get.arguments['id'];
  final String userProfile = Get.arguments["userProfile"];
  final FollowersAndFollowingController controller =
      Get.put(FollowersAndFollowingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundBlur(),
          Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 15),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const CustomSearchView(
                        hintText: "Search Followers",
                      ),
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return ListView.builder(
                            itemCount: controller.followers.length,
                            itemBuilder: (context, index) {
                              return FollowerTile(
                                  follower: controller.followers[index]);
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
      title: AppbarSubtitleSix(text: "Followers"),
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

class FollowerTile extends StatelessWidget {
  final Follow follower;

  FollowerTile({super.key, required this.follower});
  final FollowersAndFollowingController controller = Get.find();

  bool _isSvg(String url) {
    return url.toLowerCase().endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: SizedBox(
          width: 40.0, // Adjust the size as needed
          height: 40.0,
          child: _isSvg(follower.profilePic)
              ? SvgPicture.network(
                  follower.profilePic,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  follower.profilePic,
                  fit: BoxFit.cover,
                ),
        ),
      ),
      title: Text(follower.displayName),
      subtitle: Text("${follower.industry} | ${follower.occupation}"),
      trailing: (controller.userProfile == "userProfile")
          ? ElevatedButton(
              onPressed: () async {
                await controller.removeConnection(
                    follower.id, "removeFollower");
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0), // Rectangular shape
                ),
                backgroundColor: Colors.white,
                minimumSize: const Size(100, 50), // Set width and height
              ),
              child: const Text(
                'Remove',
                style: TextStyle(
                  color: Colors.black, // Text color black
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
