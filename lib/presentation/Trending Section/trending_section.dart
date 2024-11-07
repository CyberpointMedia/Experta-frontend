import 'package:experta/widgets/dashed_border.dart';
import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_icon_button.dart';

import '../categoryDetails/category_details_screen.dart';

class TrendingPeoplePage extends StatelessWidget {
  const TrendingPeoplePage({super.key});

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
      title: AppbarSubtitleSix(text: "Trending"),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.notification);
            },
            padding: const EdgeInsets.only(right: 5),
            icon: Container(
              width: 40.0,
              height: 45.0,
              padding: const EdgeInsets.all(5),
              decoration: IconButtonStyleHelper.outline.copyWith(
                color: appTheme.whiteA700.withOpacity(0.6),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
              child: CustomImageView(
                imagePath: ImageConstant.imgBell02,
                height: 8.0,
                width: 8.0,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.adaptSize),
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: 3,
          itemBuilder: (context, index) {
            return ProfileCard();
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Message"),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: "Feeds"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
      // padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
        color: Colors.white, // Light grey background
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.orange,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/images/profile.jpg'),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 2,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
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
                            "Taranvir Kaur",
                            style: TextStyle(
                              fontSize: 16.fSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.verified, color: Colors.deepPurple, size: 16),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.orange, width: 1),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.star, color: Colors.orange, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  "5.0",
                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "UI/UX Designer | Graphic Designer",
                        style: TextStyle(
                          fontSize: 12.fSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "English, Hindi, Punjabi",
                        style: TextStyle(
                          fontSize: 12.fSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding:  const EdgeInsets.only(left: 20, right: 20, top: 0),
            child: CustomPaint(
              painter: DashedBorderPainter(
                color: Colors.grey,
                strokeWidth: 1.0,
                dashWidth: 5.0,
                dashSpace: 3.0,
                topGap: 7.0,
                bottomGap: 0.0, // Removed bottom gap here
              ),
              child: Container(height: 1),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding:  const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                _buildChip("Visual design"),
                _buildChip("Information architecture"),
                _buildChip("Interaction design"),
                _buildChip("+3 more"),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Colors.grey[300]!.withOpacity(0.5),
      Colors.grey[300]!.withOpacity(0.5),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
),

            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.video_call, "488/min", Colors.red),
                _buildActionButton(Icons.phone, "250/min", Colors.green),
                _buildActionButton(Icons.message, "99/msg", Colors.yellow[700]!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(60),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.adaptSize, vertical: 6.adaptSize),
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

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
         SizedBox(width: 4.adaptSize),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

