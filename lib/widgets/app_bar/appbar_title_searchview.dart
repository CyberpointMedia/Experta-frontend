import 'package:experta/core/app_export.dart';

// ignore: must_be_immutable
class AppbarTitleSearchview extends StatelessWidget {
  AppbarTitleSearchview({
    super.key,
    this.hintText,
    this.controller,
    this.margin,
  });

  String? hintText;

  TextEditingController? controller;

  EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: CustomSearchView(
        width: 279.h,
        controller: controller,
        hintText: "lbl_influencer".tr,
      ),
    );
  }
}
