import 'package:experta/core/app_export.dart';
import 'package:flutter/material.dart';

class ReferAndEarnPage extends StatefulWidget {
  const ReferAndEarnPage({super.key});

  @override
  State<ReferAndEarnPage> createState() => _ReferAndEarnPageState();
}

class _ReferAndEarnPageState extends State<ReferAndEarnPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  color: theme.primaryColor,
                  child: CustomImageView(
                    imagePath: 'assets/images/bookings/sunrays.svg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 130,
                  child: CustomImageView(
                    imagePath: 'assets/images/bookings/gift.svg',
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 270,
                  child: Text(
                    "Refer & Earn Rewards",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontSize: 24.0,
                      color: appTheme.black900,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 305,
                  child: Text(
                    "Share Experta with your friends and earn\nrewards",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontSize: 14.0,
                      color: appTheme.black900,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: _buildAppBar(),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header for "How it works?"
                  Row(
                    children: [
                      Icon(Icons.info_outline, 
                      color: appTheme.gray400),
                      const SizedBox(width: 8),
                      Text(
                        "How it works?",
                        style: theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Steps
                  buildStep(
                    stepNumber: "1",
                    title: "Share Your Link",
                    description: "Share your unique referral link with friends. The more, the merrier!",
                    theme: theme,
                  ),
                  const SizedBox(height: 20),
                  buildStep(
                    stepNumber: "2",
                    title: "Friend Registers",
                    description: "When your friend registers on [App Name], you both win!",
                    theme: theme,
                  ),
                  const SizedBox(height: 20),
                  buildStep(
                    stepNumber: "3",
                    title: "First Call Bonus",
                    description: "Earn tokens when your referred friend makes their first call.",
                    theme: theme,
                  ),
                  const Spacer(),

                  // Bottom Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        const CustomElevatedButton(
                        height: 56,
                        width: 300,
                        leftIcon: Icon(
                          Icons.wechat
                        ),
                        text: 'Share via WhatsApp'),
                    const SizedBox(width: 10,),
                      CircleAvatar(
                        radius: 23,
                        backgroundColor: Colors.grey.shade200,
                        child: IconButton(
                          onPressed: () {
                            // Add your share functionality here
                          },
                          icon: const Icon(Icons.share_outlined,size: 24, color: Colors.black),
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
      title: AppbarSubtitleSix(text: "Refer & Earn"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }

  // Function to build each step
  // Function to build each step
Widget buildStep({
  required String stepNumber,
  required String title,
  required String description,
  required ThemeData theme,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(4), // Space between the border and CircleAvatar
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 2), // Grey border
        ),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: appTheme.gray400.withOpacity(0.2),
          child: Text(
            stepNumber,
            style: TextStyle(color: appTheme.gray400, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                title,
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16.fSize,
                color: appTheme.black900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
               description,
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
}