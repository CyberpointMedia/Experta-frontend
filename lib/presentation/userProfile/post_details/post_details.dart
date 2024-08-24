// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:experta/presentation/feeds_active_screen/models/feeds_active_model.dart';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/userProfile/post_details/controller/post_details_controller.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:experta/widgets/report.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostDetailsPage extends StatefulWidget {
  final int initialIndex;
  final String userId;
  const PostDetailsPage(
      {super.key, required this.initialIndex, required this.userId});

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  PostDetailsPageController controller = Get.put(PostDetailsPageController());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double itemHeight = 100.0;
      double scrollPosition = widget.initialIndex * itemHeight;
      _scrollController.jumpTo(scrollPosition);
    });
    controller.fetchFeeds(widget.userId); // Ensure this line is added
  }

  void _onRefresh() async {
    await controller.fetchFeeds(widget.userId);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(),
          body: Obx(() {
            if (controller.isLoading.value) {
              return Padding(
                padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                child: _buildShimmerEffect(),
              );
            } else {
              return SmartRefresher(
                header: WaterDropHeader(
                  waterDropColor: theme.primaryColor,
                  complete: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, color: Colors.green),
                      SizedBox(width: 5),
                      Text("Refreshed Successfully!",
                          style: TextStyle(color: Colors.green)),
                    ],
                  ),
                  failed: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      SizedBox(width: 5),
                      Text("Refresh Failed",
                          style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  refresh: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(width: 5),
                      Text("Refreshing...",
                          style: TextStyle(color: theme.primaryColor)),
                    ],
                  ),
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: controller.feeds.length,
                  itemBuilder: (context, index) {
                    int reverseIndex = controller.feeds.length - 1 - index;
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: FeedItem(
                        feed: controller.feeds[reverseIndex],
                        userId: widget.userId,
                      ),
                    );
                  },
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}

Widget _buildShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 48.adaptSize,
                    height: 48.adaptSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48),
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 10.h, top: 15.v, bottom: 10.v),
                    child: Container(
                      width: 100,
                      height: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 2.h, top: 19.v, bottom: 13.v),
                      child: Text("lbl2".tr,
                          style: CustomTextStyles.bodySmallBluegray300)),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 2.h, top: 19.v, bottom: 13.v),
                      child: Text("0 days ago",
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
                      color:
                          theme.colorScheme.onPrimaryContainer.withOpacity(1),
                      borderRadius: BorderRadius.circular(3.h))),
              SizedBox(height: 2.v),
              Container(
                  height: 16.adaptSize,
                  width: 16.adaptSize,
                  margin: EdgeInsets.only(left: 10.h),
                  decoration: BoxDecoration(
                      color:
                          theme.colorScheme.onPrimaryContainer.withOpacity(1),
                      borderRadius: BorderRadius.circular(8.h))),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  decoration: BoxDecoration(
                      color:
                          theme.colorScheme.onPrimaryContainer.withOpacity(1),
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.h),
                          bottom: Radius.circular(20.h))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.v, top: 20.v, bottom: 10.v, right: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8),
                        child: CustomImageView(
                            height: 200,
                            radius: BorderRadius.circular(20.h),
                            alignment: Alignment.center),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.h, vertical: 10),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.h, vertical: 15.v),
                        decoration: AppDecoration.fillGray10001.copyWith(
                            borderRadius: BorderRadiusStyle.customBorderBL20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgNavFeeds,
                                  color: appTheme.black900,
                                  height: 24.adaptSize,
                                  width: 24.adaptSize,
                                  onTap: () async {},
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 4.h, top: 3.v, bottom: 3.v),
                                    child: Text("0",
                                        style: theme.textTheme.titleSmall)),
                                CustomImageView(
                                  imagePath: ImageConstant.imgInbox2,
                                  color: appTheme.gray600,
                                  height: 24.adaptSize,
                                  width: 24.adaptSize,
                                  margin: EdgeInsets.only(left: 10.h),
                                  onTap: () {},
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 4.h, top: 3.v, bottom: 3.v),
                                    child: Text("0",
                                        style: theme.textTheme.titleSmall)),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildBottomSheetContent(BuildContext context, Comment? comment) {
  final controller = Get.find<PostDetailsPageController>();
  final String? userAddress = PrefUtils().getaddress();
  Datum? feed;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 5,
          width: 20,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomImageView(
              imagePath: ImageConstant.cross,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ),
        if (comment != null && comment.user.id == userAddress ||
            feed!.postedBy.id == userAddress)
          _buildBottomSheetOption(
            context,
            icon: Icons.delete,
            label: 'Delete this comment',
          ),
        controller.isComment == false.obs
            ? _buildBottomSheetOption(
                context,
                icon: Icons.flag_outlined,
                label: 'Report this post',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => ReportReasonSheet(
                      itemId: comment?.id ?? '',
                      itemType: 'Post',
                    ),
                  );
                },
              )
            : _buildBottomSheetOption(
                context,
                icon: Icons.flag_outlined,
                label: 'Report this comment',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => ReportReasonSheet(
                      itemId: comment?.id ?? '',
                      itemType: 'Comment',
                    ),
                  );
                },
              ),
        _buildBottomSheetOption(
          context,
          icon: Icons.block_outlined,
          label: 'Block user',
          onTap: () {
            // Handle block user action
          },
        ),
        const SizedBox(height: 10.0),
      ],
    ),
  );
}

Widget _buildBottomSheetOption(BuildContext context,
    {required IconData icon, required String label, VoidCallback? onTap}) {
  return ListTile(
    leading: Icon(icon, size: 24, color: Colors.black),
    title: Text(
      label,
      style: const TextStyle(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
    ),
    onTap: onTap ?? () => Navigator.pop(context),
  );
}

class FeedItem extends StatelessWidget {
  final Datum feed;
  final String userId;

  FeedItem({super.key, required this.feed, required this.userId});
  final String? address = PrefUtils().getaddress();
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostDetailsPageController>();
    final isLiked = feed.likes.contains(address);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomImageView(
              imagePath: feed.postedBy.profilePic ?? '',
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
              margin: EdgeInsets.only(top: 12.v, bottom: 10.v),
              onTap: () {
                controller.isComment = false.obs;
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.0),
                    ),
                  ),
                  builder: (context) {
                    return _buildBottomSheetContent(context, null);
                  },
                );
              },
            ),
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
                        imagePath: feed.image ?? '',
                        radius: BorderRadius.circular(20.h),
                        alignment: Alignment.center),
                  ),
                Container(
                  width: MediaQuery.of(context).size.width,
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
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10, bottom: 10),
                                    child: CommentInputField(feed: feed),
                                  );
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
                            ...feed.comments.reversed.take(2).map((comment) {
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
                                              const Spacer(),
                                              CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgMoreHorizontalBlueGray300,
                                                height: 15.adaptSize,
                                                width: 15.adaptSize,
                                                margin: EdgeInsets.only(
                                                    top: 12.v, bottom: 10.v),
                                                onTap: () {
                                                  controller.isComment =
                                                      true.obs;
                                                  showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.white,
                                                    context: context,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            16.0),
                                                      ),
                                                    ),
                                                    builder: (context) {
                                                      return _buildBottomSheetContent(
                                                          context, comment);
                                                    },
                                                  );
                                                },
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
                                    () => CommentsPage(
                                      feed: feed,
                                      userId: userId,
                                    ),
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
  final String userId;

  const CommentsPage({super.key, required this.feed, required this.userId});

  @override
  Widget build(BuildContext context) {
    final RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    void _onRefresh() async {
      Get.find<PostDetailsPageController>().fetchFeeds(userId);
      _refreshController.refreshCompleted();
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: SmartRefresher(
        header: WaterDropHeader(
          waterDropColor: theme.primaryColor,
          complete: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check, color: Colors.green),
              SizedBox(width: 5),
              Text("Refreshed Successfully!",
                  style: TextStyle(color: Colors.green)),
            ],
          ),
          failed: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 5),
              Text("Refresh Failed", style: TextStyle(color: Colors.red)),
            ],
          ),
          refresh: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 5),
              Text("Refreshing...",
                  style: TextStyle(color: theme.primaryColor)),
            ],
          ),
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView.builder(
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
        onTap: () {
          onTapArrowLeft();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Comments"),
    );
  }
}

onTapBtnBellTwo() {
  Get.toNamed(
    AppRoutes.notification,
  );
}

PreferredSizeWidget _buildAppBar() {
  return CustomAppBar(
    height: 60.h,
    leadingWidth: 40.h,
    leading: AppbarLeadingImage(
      imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
      margin: EdgeInsets.only(left: 16.h),
      onTap: () {
        onTapArrowLeft();
      },
    ),
    centerTitle: true,
    title: AppbarSubtitleSix(text: "Posts".tr),
  );
}

void onTapArrowLeft() {
  Get.back();
}

class CommentInputField extends StatefulWidget {
  final Datum feed;

  const CommentInputField({super.key, required this.feed});

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final TextEditingController _commentController = TextEditingController();
  final PostDetailsPageController _controller =
      Get.find<PostDetailsPageController>();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _commentController.removeListener(_onTextChanged);
    _commentController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _isButtonEnabled.value = _commentController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                width: MediaQuery.of(context).size.width,
                controller: _commentController,
                hintText: 'Write a comment...',
                hintStyle: CustomTextStyles.titleMediumBluegray300,
                textInputType: TextInputType.text,
                focusNode: FocusNode(),
                autofocus: false,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _isButtonEnabled,
              builder: (context, isEnabled, child) {
                return IconButton(
                  icon: Icon(
                    Icons.send,
                    color:
                        isEnabled ? theme.primaryColor : appTheme.blueGray100,
                  ),
                  onPressed: isEnabled
                      ? () async {
                          await _controller.postComment(
                              widget.feed.id, _commentController.text);
                          _commentController.clear();
                          Navigator.pop(context); // Close the bottom sheet
                        }
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
