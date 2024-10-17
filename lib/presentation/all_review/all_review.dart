import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/userProfile/models/profile_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AllReviewsPage extends StatelessWidget {
  final List<Review> reviews;

  const AllReviewsPage({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Positioned(
              left: 270.adaptSize,
              top: 50.adaptSize,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 60.adaptSize,
                  sigmaY: 60.adaptSize,
                ),
                child: Align(
                  child: SizedBox(
                    width: 252.adaptSize,
                    height: 252.adaptSize,
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
              children: [
                Expanded(
                  child: reviews.isEmpty
                      ? Center(
                          child: Text(
                            "No reviews yet",
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: appTheme.gray900),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            var review = reviews[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CustomImageView(
                                          imagePath: review.profilePic,
                                          height: 50.adaptSize,
                                          width: 50.adaptSize,
                                          radius: BorderRadius.circular(50),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              review.reviewer.toString(),
                                              style: theme.textTheme.headlineLarge
                                                  ?.copyWith(fontSize: 14.fSize),
                                            ),
                                            SizedBox(height: 1.v),
                                            Text(
                                              review.formattedDate.toString(),
                                              style: theme.textTheme.titleSmall!,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 9.v),
                                    Row(
                                      children: [
                                        RatingBar.builder(
                                          initialRating:
                                              review.rating!.toDouble(),
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: false,
                                          itemSize: 22,
                                          onRatingUpdate: (rating) {},
                                          itemBuilder: (context, _) {
                                            return Icon(
                                              Icons.star,
                                              color: appTheme.deepYello,
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          review.rating.toString(),
                                          style: theme.textTheme.headlineLarge
                                              ?.copyWith(fontSize: 16.fSize),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.v),
                                    Container(
                                      width: 304.adaptSize,
                                      margin: const EdgeInsets.only(right: 31),
                                      child: Text(
                                        review.review.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(color: appTheme.gray900),
                                      ),
                                    ),
                                    SizedBox(height: 8.v),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 70.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapArrowLeft();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "All Reviews"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
