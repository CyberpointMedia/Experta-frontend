import 'package:experta/presentation/wallet/wallet.dart';
import 'package:experta/widgets/custom_outlined_button.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:experta/core/app_export.dart';

// ignore: must_be_immutable
class AppbarTrailingButtonOne extends StatelessWidget {
  final int balance;

  AppbarTrailingButtonOne({
    super.key,
    this.margin,
    this.onTap,
    required this.balance, // Make balance a required parameter
  });

  EdgeInsetsGeometry? margin;
  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const Wallet()));
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: OutlineGradientButton(
          padding: EdgeInsets.only(
            left: 1.h,
            top: 1.v,
            right: 1.h,
            bottom: 1.v,
          ),
          strokeWidth: 1.h,
          gradient: LinearGradient(
            begin: const Alignment(0.09, -0.08),
            end: const Alignment(0.75, 1.1),
            colors: [
              theme.colorScheme.onPrimaryContainer.withOpacity(1),
              theme.colorScheme.onPrimaryContainer.withOpacity(0),
              theme.colorScheme.onPrimaryContainer.withOpacity(1),
            ],
          ),
          corners: const Corners(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: CustomOutlinedButton(
            height: 40.v,
            width: 78.h,
            text: "$balance", // Use the balance here
            leftIcon: Container(
              margin: EdgeInsets.only(right: 6.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgLayer1,
                height: 16.adaptSize,
                width: 16.adaptSize,
              ),
            ),
            buttonStyle: CustomButtonStyles.outlineTL20,
            buttonTextStyle: CustomTextStyles.titleSmallGray900SemiBold,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const Wallet()));
            },
          ),
        ),
      ),
    );
  }
}
