import 'package:experta/core/app_export.dart';

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
                  height: MediaQuery.of(context).size.height * 0.42,
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
                  top: MediaQuery.of(context).size.height * 0.1,
                  child: CustomImageView(
                    imagePath: 'assets/images/bookings/gift.svg',
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).size.height * 0.3,
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
                  top: MediaQuery.of(context).size.height * 0.34,
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
              height: MediaQuery.of(context).size.height * 0.58,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.i,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "How it works?",
                        style: theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  buildStepWithDivider(
                    stepNumber: "1",
                    title: "Share Your Link",
                    description:
                        "Share your unique referral link with friends. The more, the merrier!",
                    theme: theme,
                  ),
                  buildStepWithDivider(
                    stepNumber: "2",
                    title: "Friend Registers",
                    description:
                        "When your friend registers on Experta, you both win!",
                    theme: theme,
                  ),
                  buildStepWithDivider(
                    stepNumber: "3",
                    title: "First Call Bonus",
                    description:
                        "Earn tokens when your referred friend makes their first call.",
                    theme: theme,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomElevatedButton(
                        height: 56,
                        width: MediaQuery.of(context).size.width * 0.7,
                        leftIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomImageView(
                            imagePath: ImageConstant.whatsapp,
                          ),
                        ),
                        text: 'Share via WhatsApp',
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: appTheme.gray300, width: 0.5),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined,
                              size: 24, color: Colors.black),
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

  Widget buildStepWithDivider({
    required String stepNumber,
    required String title,
    required String description,
    required ThemeData theme,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: appTheme.gray300, width: 0.5),
                  ),
                  child: Center(
                    child: Text(
                      stepNumber,
                      style: TextStyle(
                        color: appTheme.black900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                if (stepNumber != "3")
                  Container(
                    height: 25,
                    child: CustomPaint(
                      painter: DottedLinePainter(
                        color: appTheme.gray400,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: appTheme.black900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      description,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Add this custom painter class
class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    double startY = 0;
    double endY = size.height;
    double dashHeight = 1;
    double gapHeight = 3;
    double currentY = startY;

    while (currentY < endY) {
      canvas.drawLine(
        Offset(0, currentY),
        Offset(0, currentY + dashHeight),
        paint,
      );
      currentY += dashHeight + gapHeight;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
