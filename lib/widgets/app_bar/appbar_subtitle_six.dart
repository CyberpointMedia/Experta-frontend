import 'package:experta/core/app_export.dart';

// ignore: must_be_immutable
class AppbarSubtitleSix extends StatelessWidget {
  AppbarSubtitleSix({
    super.key,
    required this.text,
    this.margin,
    this.onTap,
    this.textColor,
  });

  String text;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Text(
          text,
          style: theme.textTheme.titleMedium!.copyWith(
            color: textColor ?? appTheme.gray900,
          ),
        ),
      ),
    );
  }
}
