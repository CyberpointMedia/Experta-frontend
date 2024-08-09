import 'package:experta/presentation/feeds_active_screen/models/feeds_active_model.dart';
import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'controller/feeds_active_controller.dart';

class FeedsActiveScreen extends StatefulWidget {
  const FeedsActiveScreen({super.key});

  @override
  State<FeedsActiveScreen> createState() => _FeedsActiveScreenState();
}

class _FeedsActiveScreenState extends State<FeedsActiveScreen> {
  FeedsActiveController controller = Get.put(FeedsActiveController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: controller.feeds.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: FeedItem(feed: controller.feeds[index]),
                );
              },
            );
          }
        }),
      ),
    );
  }
}

class FeedItem extends StatelessWidget {
  final Datum feed;

  const FeedItem({super.key, required this.feed});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeedsActiveController>();
    final isLiked = feed.likes.contains('664ef83426880cc7d7f204f8');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomImageView(
              imagePath: feed.postedBy.profilePic,
              height: 48.adaptSize,
              width: 48.adaptSize,
              radius: BorderRadius.circular(48),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.h, top: 15.v, bottom: 10.v),
                child: Text(feed.postedBy.displayName,
                    style: CustomTextStyles.titleMediumSemiBold)),
            Padding(
                padding: EdgeInsets.only(left: 2.h, top: 19.v, bottom: 13.v),
                child: Text("lbl2".tr,
                    style: CustomTextStyles.bodySmallBluegray300)),
            Padding(
                padding: EdgeInsets.only(left: 2.h, top: 19.v, bottom: 13.v),
                child: Text(feed.formattedDate,
                    style: CustomTextStyles.bodySmallBluegray300)),
            const Spacer(),
            CustomImageView(
                imagePath: ImageConstant.imgMoreHorizontalBlueGray300,
                height: 24.adaptSize,
                width: 24.adaptSize,
                margin: EdgeInsets.only(top: 12.v, bottom: 10.v)),
          ],
        ),
        SizedBox(height: 2.v),
        Container(
            height: 6.adaptSize,
            width: 6.adaptSize,
            margin: EdgeInsets.only(left: 10.h),
            decoration: BoxDecoration(
                color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
                borderRadius: BorderRadius.circular(3.h))),
        SizedBox(height: 2.v),
        Container(
            height: 16.adaptSize,
            width: 16.adaptSize,
            margin: EdgeInsets.only(left: 10.h),
            decoration: BoxDecoration(
                color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
                borderRadius: BorderRadius.circular(8.h))),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Container(
            decoration: BoxDecoration(
                color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.h), bottom: Radius.circular(20.h))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 10.v, top: 20.v, bottom: 10.v, right: 10),
                  child: Text(feed.caption,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium),
                ),
                if (feed.image.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8),
                    child: CustomImageView(
                        imagePath: feed.image,
                        radius: BorderRadius.circular(20.h),
                        alignment: Alignment.center),
                  ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 15.v),
                  decoration: AppDecoration.fillGray10001.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderBL20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgNavFeeds,
                            color:
                                isLiked ? appTheme.black900 : appTheme.gray600,
                            height: 24.adaptSize,
                            width: 24.adaptSize,
                            onTap: () async {
                              await controller.likeUnlikePost(feed.id);
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 4.h, top: 3.v, bottom: 3.v),
                              child: Text(feed.totalLikes.toString(),
                                  style: theme.textTheme.titleSmall)),
                          CustomImageView(
                            imagePath: ImageConstant.imgInbox2,
                            color: appTheme.gray600,
                            height: 24.adaptSize,
                            width: 24.adaptSize,
                            margin: EdgeInsets.only(left: 10.h),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return CommentInputField(feed: feed);
                                },
                              );
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 4.h, top: 3.v, bottom: 3.v),
                              child: Text(feed.totalComments.toString(),
                                  style: theme.textTheme.titleSmall)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (feed.comments.isNotEmpty)
                        Column(
                          children: [
                            ...feed.comments.take(2).map((comment) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomImageView(
                                      imagePath: comment.user.profilePic,
                                      height: 38.adaptSize,
                                      width: 38.adaptSize,
                                      radius: BorderRadius.circular(38),
                                      margin: EdgeInsets.only(bottom: 3.v),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                comment.user.displayName,
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            appTheme.black900),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 2.h, top: 5.h),
                                                  child: Text("lbl2".tr,
                                                      style: CustomTextStyles
                                                          .bodySmallBluegray300)),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 2.h,
                                                  top: 4.v,
                                                ),
                                                child: Text(
                                                  comment.formattedDate,
                                                  style: CustomTextStyles
                                                      .bodySmallBluegray300,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            comment.comment,
                                            style: theme.textTheme.titleMedium!
                                                .copyWith(
                                                    color: appTheme.black90001,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            if (feed.comments.length > 2)
                              TextButton(
                                onPressed: () {
                                  Get.to(
                                    CommentsPage(feed: feed),
                                  );
                                },
                                child: const Text("View all comments"),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CommentsPage extends StatelessWidget {
  final Datum feed;

  const CommentsPage({super.key, required this.feed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
      ),
      body: ListView.builder(
        itemCount: feed.comments.length,
        itemBuilder: (context, index) {
          final comment = feed.comments[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(comment.user.profilePic),
                  radius: 15,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.user.displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(comment.comment),
                      Text(
                        comment.formattedDate,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Navigates to the notificationScreen when the action is triggered.
onTapBtnBellTwo() {
  Get.toNamed(
    AppRoutes.notification,
  );
}

PreferredSizeWidget _buildAppBar() {
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
    title: AppbarSubtitleSix(text: "lbl_feeds".tr),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: OutlineGradientButton(
            padding:
                EdgeInsets.only(left: 1.h, top: 1.v, right: 1.h, bottom: 1.v),
            strokeWidth: 1.h,
            gradient: LinearGradient(
                begin: const Alignment(0.09, -0.08),
                end: const Alignment(0.75, 1.1),
                colors: [
                  theme.colorScheme.onPrimaryContainer.withOpacity(1),
                  theme.colorScheme.onPrimaryContainer.withOpacity(0),
                  theme.colorScheme.onPrimaryContainer.withOpacity(1)
                ]),
            corners: const Corners(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            child: CustomIconButton(
                height: 40.adaptSize,
                width: 40.adaptSize,
                padding: EdgeInsets.all(8.h),
                decoration: IconButtonStyleHelper.outline,
                onTap: () {
                  onTapBtnBellTwo();
                },
                child: CustomImageView(imagePath: ImageConstant.imgBell02))),
      )
    ],
  );
}

void onTapArrowLeft() {
  Get.back();
}

class CommentInputField extends StatefulWidget {
  final Datum feed;

  const CommentInputField({super.key, required this.feed});

  @override
  _CommentInputFieldState createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final TextEditingController _commentController = TextEditingController();
  final FeedsActiveController _controller = Get.find<FeedsActiveController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              if (_commentController.text.isNotEmpty) {
                await _controller.postComment(
                    widget.feed.id, _commentController.text);
                _commentController.clear();
                Navigator.pop(context); // Close the bottom sheet
              }
            },
          ),
        ],
      ),
    );
  }
}
