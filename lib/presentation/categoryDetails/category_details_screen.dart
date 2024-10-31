import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:experta/presentation/categoryDetails/category_controller.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;

  const CategoryDetailScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final Industry industry = Get.arguments['industry'];
    final CategoryDetailController controller =
        Get.put(CategoryDetailController());

    // Fetch users for the selected industry
    controller.fetchUsersByIndustry(industry.id);

    return Scaffold(
      appBar:_buildAppBar(categoryName),
      body: Obx(() {
        if (controller.isLoading.value) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8, // Adjust as needed
            ),
            itemCount: 15,
            itemBuilder: (context, index) {
              return _buildShimmerEffect();
            },
          );
        }
        var users = controller.usersByIndustry[industry.id] ?? [];
        if (users.isEmpty) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8, // Adjust as needed
            ),
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildEmptyContainer();
            },
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8, // Adjust as needed
          ),
          itemCount: users.length,
          itemBuilder: (context, index) {
            User user = users[index];
            return UserProfileItemWidget(user: user);
          },
        );
      }),
    );
  }
}

Widget _buildShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: 80.adaptSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

Widget _buildEmptyContainer() {
  return SizedBox(
    height: 220.v,
    width: 156.adaptSize,
    child: Stack(
      alignment: Alignment.centerLeft,
      children: [
        Align(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: CustomImageView(
              imagePath: ImageConstant.imgWomanWithHeadsetVideoCall1,
              height: 220.v,
              width: 156.adaptSize,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 37),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildStatusContainer("Offline", appTheme.red500),
                    _buildRatingContainer("0"),
                  ],
                ),
                SizedBox(height: 126.v),
                Text(
                  "Not Found",
                  maxLines: 1,
                  style:
                      theme.textTheme.labelLarge?.copyWith(fontSize: 14.fSize),
                ),
                SizedBox(height: 2.v),
                Text(
                  "Not found",
                  style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0XFFFFFFFF), fontSize: 11.fSize),
                ),
                SizedBox(height: 6.v),
                Row(
                  children: [
                    SizedBox(
                        height: 14.v,
                        width: 14.adaptSize,
                        child: CustomImageView(
                            imagePath: "assets/images/img_layer_1.svg")),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "0", style: theme.textTheme.labelLarge!),
                            TextSpan(
                                text: "/min",
                                style: theme.textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w400)),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  PreferredSizeWidget _buildAppBar(String text) {
    return CustomAppBar(
      height: 40.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapArrowLeft();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: text),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }

class UserProfileItemWidget extends StatelessWidget {
  final User user;

  const UserProfileItemWidget({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    print("hey the user is ${user.profilePic}/ ${user.displayName}");
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.detailsPage, arguments: {"user": user});
      },
      child: SizedBox(
        height: 220.v,
        width: 156.adaptSize,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CustomImageView(
                  imagePath: user.profilePic,
                  height: 220.v,
                  width: 156.adaptSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 37),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildStatusContainer(
                            user.online ? "Online" : "Offline",
                            user.online ? appTheme.green400 : appTheme.red500),
                        _buildRatingContainer(
                            "${user.rating}"), // Assuming a static rating for now
                      ],
                    ),
                    SizedBox(height: 126.v),
                    Text(
                      user.displayName,
                      maxLines: 1,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(fontSize: 14.fSize),
                    ),
                    SizedBox(height: 2.v),
                    Text(
                      "${user.industry} | ${user.occupation}",
                      style: theme.textTheme.bodyLarge?.copyWith(
                          color: const Color(0XFFFFFFFF), fontSize: 11.fSize),
                    ),
                    SizedBox(height: 6.v),
                    Row(
                      children: [
                        SizedBox(
                            height: 14.v,
                            width: 14.adaptSize,
                            child: CustomImageView(
                                imagePath: "assets/images/img_layer_1.svg")),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "${user.pricing.videoCallPrice}",
                                    style: theme.textTheme.labelLarge!),
                                TextSpan(
                                    text: "/min",
                                    style: theme.textTheme.labelLarge?.copyWith(
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildStatusContainer(String text, Color color) {
  return Container(
    width: 44.adaptSize,
    padding: const EdgeInsets.symmetric(vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0X4C171717),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 4.v,
          width: 4.adaptSize,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(
          text,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: const Color(0XFFFFFFFF)),
        ),
      ],
    ),
  );
}

Widget _buildRatingContainer(String text) {
  return Container(
    width: 33.adaptSize,
    margin: const EdgeInsets.only(left: 2),
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0X4C171717),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: SizedBox(
            height: 10.v,
            width: 10.adaptSize,
            child: CustomImageView(imagePath: "assets/images/img_star.svg"),
          ),
        ),
        Text(
          text,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: const Color(0XFFFFFFFF)),
        ),
      ],
    ),
  );
}
