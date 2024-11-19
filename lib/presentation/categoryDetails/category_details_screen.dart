import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:experta/presentation/categoryDetails/category_controller.dart';
import 'package:experta/widgets/dashed_border.dart';

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
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 15,
            itemBuilder: (context, index) {
              return _buildShimmerEffect();
            },
          );
        }
        var users = controller.usersByIndustry[industry.id] ?? [];
        if (users.isEmpty) {
          return ListView.builder(
            // padding: const EdgeInsets.all(16),
            itemCount: 15,
            itemBuilder: (context, index) {
              return _buildEmptyContainer(context);
            },
          );
        }
        return ListView.builder(
          // padding: const EdgeInsets.all(16),
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


Widget _buildEmptyContainer(BuildContext context){
  return  Padding(
        padding: EdgeInsets.only(right: 16.adaptSize, bottom: 10.adaptSize, left: 16.adaptSize),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30.adaptSize,
                        right: 30.adaptSize,
                        top: 30.adaptSize),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 30.adaptSize,
                              backgroundColor: Colors.orange,
                              child: CircleAvatar(
                                radius: 28.adaptSize,
                                backgroundColor: Colors.white,
                                child: CustomImageView(
                                  height: 55,
                                  width: 55,
                                  radius: BorderRadius.circular(25),
                                  imagePath:ImageConstant.imgWomanWithHeadsetVideoCall1,
                                  placeHolder:  ImageConstant.imageNotFound,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 2,
                              child: Container(
                                height: 15.adaptSize,
                                width: 15.adaptSize,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text( "anonymous",
                                    style: TextStyle(
                                      fontSize: 16.fSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.verified,
                                      color: Colors.deepPurple, size: 16),
                                  const Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.adaptSize,
                                        vertical: 2.adaptSize),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: Colors.orange, width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.orange, size: 14),
                                        SizedBox(width: 4.adaptSize),
                                        Text("0",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.fSize),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text( "No data",
                                style: TextStyle(
                                  fontSize: 12.fSize,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  CustomImageView(
                                    height: 14.adaptSize,
                                    width: 14.adaptSize,
                                    imagePath: "assets/images/language.svg",
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text('No languages',
                                      style: TextStyle(
                                        fontSize: 12.fSize,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: CustomPaint(
                      painter: DashedDividerPainter(
                        color: appTheme.gray200, // or your desired color
                        dashWidth: 5.0, // length of each dash
                        dashSpace: 3.0, // space between dashes
                        strokeWidth: 1.0, // thickness of the line
                      ),
                      size: Size(MediaQuery.of(context).size.width * 0.8, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30.adaptSize,
                        right: 30.adaptSize,
                        top: 10.adaptSize),
                    child: Wrap(
                      spacing: 8.adaptSize,
                      runSpacing: 8.adaptSize,
                      children:[
                          _buildChip(
                                      'No Expertise found',
                                    ),
                      ]
                    ),
                  ),
                  SizedBox(height: 30.adaptSize),
                  Container(
                    decoration: BoxDecoration(
                      color: appTheme.gray100,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(24)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(
                            ImageConstant.videocam,
                            "0/min",
                            appTheme.red500,
                            () {}),
                        Container(
                          color: appTheme.gray300,
                          width: 0.5.adaptSize,
                          height: 50.adaptSize,
                        ),
                        _buildActionButton(
                            ImageConstant.call,
                            "0/min",
                            appTheme.green100,
                            () {}),
                        Container(
                          color: appTheme.gray300,
                          width: 0.5.adaptSize,
                          height: 50.adaptSize,
                        ),
                        _buildActionButton(
                            ImageConstant.msg,
                            "0/min",
                            appTheme.yellow900,
                            () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // "Top Rated" Ribbon
            Positioned(
              top: 55.adaptSize,
              left: -15.adaptSize,
              child: Transform.rotate(
                angle: -45 * (3.141592653589793 / 180),
                alignment: Alignment.topLeft,
                child: Container(
                  width: 100.adaptSize,
                  padding: EdgeInsets.symmetric(
                      vertical: 3.adaptSize, horizontal: 8.adaptSize),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageView(imagePath: "assets/images/verify.svg"),
                      SizedBox(width: 2.adaptSize),
                      const Text(
                        "Top Rated",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    
}

// Widget _buildEmptyContainer() {
//   return SizedBox(
//     height: 220.v,
//     width: 156.adaptSize,
//     child: Stack(
//       alignment: Alignment.centerLeft,
//       children: [
//         Align(
//           alignment: Alignment.center,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(24),
//             child: CustomImageView(
//               imagePath: ImageConstant.imgWomanWithHeadsetVideoCall1,
//               height: 220.v,
//               width: 156.adaptSize,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Padding(
//             padding: const EdgeInsets.only(left: 12, right: 37),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     // _buildStatusContainer("Offline", appTheme.red500),
//                     // _buildRatingContainer("0"),
//                   ],
//                 ),
//                 SizedBox(height: 126.v),
//                 Text(
//                   "Not Found",
//                   maxLines: 1,
//                   style:
//                       theme.textTheme.labelLarge?.copyWith(fontSize: 14.fSize),
//                 ),
//                 SizedBox(height: 2.v),
//                 Text(
//                   "Not found",
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                       color: const Color(0XFFFFFFFF), fontSize: 11.fSize),
//                 ),
//                 SizedBox(height: 6.v),
//                 Row(
//                   children: [
//                     SizedBox(
//                         height: 14.v,
//                         width: 14.adaptSize,
//                         child: CustomImageView(
//                             imagePath: "assets/images/img_layer_1.svg")),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 4),
//                       child: RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                                 text: "0", style: theme.textTheme.labelLarge!),
//                             TextSpan(
//                                 text: "/min",
//                                 style: theme.textTheme.labelLarge
//                                     ?.copyWith(fontWeight: FontWeight.w400)),
//                           ],
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

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

  const UserProfileItemWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.detailsPage, arguments: {"user": user});
      },
      child: Padding(
        padding: EdgeInsets.only(right: 16.adaptSize, bottom: 10.adaptSize, left: 16.adaptSize),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30.adaptSize,
                        right: 30.adaptSize,
                        top: 30.adaptSize),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 32.adaptSize,
                              backgroundColor: Colors.orange,
                              child: CircleAvatar(
                                radius: 30.adaptSize,
                                backgroundColor: Colors.white,
                                child: CustomImageView(
                                  height: 50.adaptSize,
                                  width: 50.adaptSize,
                                  radius: BorderRadius.circular(25),
                                  imagePath: user.profilePic.isNotEmpty
                                      ? user.profilePic
                                      : ImageConstant.imageNotFound,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 2,
                              child: Container(
                                height: 15.adaptSize,
                                width: 15.adaptSize,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user.displayName.isNotEmpty
                                        ? user.displayName
                                        : "anonymous",
                                    style: TextStyle(
                                      fontSize: 16.fSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.verified,
                                      color: Colors.deepPurple, size: 16),
                                  const Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.adaptSize,
                                        vertical: 2.adaptSize),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: Colors.orange, width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.orange, size: 14),
                                        SizedBox(width: 4.adaptSize),
                                        Text(
                                          user.rating.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.fSize),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                user.industry.isNotEmpty
                                    ? "${user.industry} | ${user.occupation}"
                                    : "No data",
                                style: TextStyle(
                                  fontSize: 12.fSize,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  CustomImageView(
                                    height: 14.adaptSize,
                                    width: 14.adaptSize,
                                    imagePath: "assets/images/language.svg",
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      (() {
                                        if (user.language != null &&
                                            user.language!.isNotEmpty) {
                                          final languages = user.language!
                                              .map((l) => l.name)
                                              .toList();

                                          if (languages.length > 3) {
                                            return '${languages.take(3).join(', ')} +${languages.length - 3} more';
                                          } else {
                                            return languages.join(', ');
                                          }
                                        } else {
                                          return 'No languages';
                                        }
                                      })(),
                                      style: TextStyle(
                                        fontSize: 12.fSize,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: CustomPaint(
                      painter: DashedDividerPainter(
                        color: appTheme.gray200, // or your desired color
                        dashWidth: 5.0, // length of each dash
                        dashSpace: 3.0, // space between dashes
                        strokeWidth: 1.0, // thickness of the line
                      ),
                      size: Size(MediaQuery.of(context).size.width * 0.8, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30.adaptSize,
                        right: 30.adaptSize,
                        top: 10.adaptSize),
                    child: Wrap(
                      spacing: 8.adaptSize,
                      runSpacing: 8.adaptSize,
                      children:
                          user.expertise == null || user.expertise!.isEmpty
                              ? [_buildChip('No expertise')]
                              : [
                                  ...user.expertise!
                                      .take(3)
                                      .map((e) => _buildChip(e.name)),
                                  if (user.expertise!.length > 3)
                                    _buildChip(
                                      '+${user.expertise!.length - 3}',
                                    ),
                                ],
                    ),
                  ),
                  SizedBox(height: 30.adaptSize),
                  Container(
                    decoration: BoxDecoration(
                      color: appTheme.gray100,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(24)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(
                            ImageConstant.videocam,
                            "${user.pricing.videoCallPrice}/min",
                            appTheme.red500,
                            () {}),
                        Container(
                          color: appTheme.gray300,
                          width: 0.5.adaptSize,
                          height: 50.adaptSize,
                        ),
                        _buildActionButton(
                            ImageConstant.call,
                            "${user.pricing.audioCallPrice}/min",
                            appTheme.green100,
                            () {}),
                        Container(
                          color: appTheme.gray300,
                          width: 0.5.adaptSize,
                          height: 50.adaptSize,
                        ),
                        _buildActionButton(
                            ImageConstant.msg,
                            "${user.pricing.messagePrice}/min",
                            appTheme.yellow900,
                            () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // "Top Rated" Ribbon
            Positioned(
              top: 55.adaptSize,
              left: -15.adaptSize,
              child: Transform.rotate(
                angle: -45 * (3.141592653589793 / 180),
                alignment: Alignment.topLeft,
                child: Container(
                  width: 100.adaptSize,
                  padding: EdgeInsets.symmetric(
                      vertical: 3.adaptSize, horizontal: 8.adaptSize),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageView(imagePath: "assets/images/verify.svg"),
                      SizedBox(width: 2.adaptSize),
                      const Text(
                        "Top Rated",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    
    );
  }
}

Widget _buildChip(String label) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(60),
    ),
    padding:
        EdgeInsets.symmetric(horizontal: 12.adaptSize, vertical: 6.adaptSize),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 12.fSize,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    ),
  );
}

Widget _buildActionButton(
    String img, String label, Color color, VoidCallback? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        CustomImageView(imagePath: img),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
