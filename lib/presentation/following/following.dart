import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/followers/controller/followers_controller.dart';
import 'package:experta/presentation/followers/models/followers_model.dart';
import 'package:flutter_svg/flutter_svg.dart';


class FollowingPage extends StatelessWidget {
  final FollowersAndFollowingController controller = Get.put(FollowersAndFollowingController());

  FollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundBlur(),
          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const CustomSearchView(
                        hintText: "Search Following",
                      ),
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return ListView.builder(
                            itemCount: controller.following.length,
                            itemBuilder: (context, index) {
                              return FollowerTile(follower: controller.following[index]);
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
      title: AppbarSubtitleSix(text: "Following"),
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
        imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
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
  final FollowersAndFollowingController controller = Get.find();

   FollowerTile({super.key, required this.follower});

  bool _isSvg(String url) {
    return url.toLowerCase().endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: SizedBox(
          width: 40.0,
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
      subtitle: Text(follower.industry),
      trailing: ElevatedButton(
        onPressed: () async {
          await controller.removeConnection(follower.id,"unfollow");
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          backgroundColor: Colors.white,
          minimumSize: const Size(100, 50),
        ),
        child: const Text(
          'Unfollow',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

