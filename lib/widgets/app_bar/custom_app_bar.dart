import 'package:experta/core/app_export.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.height,
    this.styleType,
    this.leadingWidth,
    this.leading,
    this.title,
    this.centerTitle,
    this.actions,
    this.backgroundColor,
  });

  final double? height;

  final Styled? styleType;

  final double? leadingWidth;

  final Widget? leading;

  final Color? backgroundColor;

  final Widget? title;

  final bool? centerTitle;

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: height ?? 24.v,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? Colors.transparent,
      flexibleSpace: _getStyle(),
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
        SizeUtils.width,
        height ?? 24.v,
      );
  _getStyle() {
    switch (styleType) {
      case Styled.bgGradientnameblack90001opacity0nameblack90001opacity06:
        return Container(
          height: 126.v,
          width: double.maxFinite,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(0.5, 0),
              end: const Alignment(0.5, 1),
              colors: [
                appTheme.black90001.withOpacity(0),
                appTheme.black90001.withOpacity(0.6),
              ],
            ),
          ),
        );
      case Styled.bgFill_1:
        return Stack(
          children: [
            Container(
              height: 3.v,
              width: double.maxFinite,
              margin: EdgeInsets.only(top: 40.v),
              decoration: BoxDecoration(
                color: appTheme.gray10001,
              ),
            ),
            Container(
              height: 3.v,
              width: 328.h,
              margin: EdgeInsets.only(
                top: 40.v,
                right: 47.h,
              ),
              decoration: BoxDecoration(
                color: appTheme.green400,
              ),
            ),
          ],
        );
      case Styled.bgFill_2:
        return Stack(
          children: [
            Container(
              height: 3.v,
              width: double.maxFinite,
              margin: EdgeInsets.only(top: 40.v),
              decoration: BoxDecoration(
                color: appTheme.gray10001,
              ),
            ),
            Container(
              height: 3.v,
              width: double.maxFinite,
              margin: EdgeInsets.only(top: 40.v),
              decoration: BoxDecoration(
                color: appTheme.green400,
              ),
            ),
          ],
        );
      case Styled.bgFill_3:
        return Container(
          height: 56.v,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
          ),
        );
      case Styled.bgFill:
        return Container(
          height: 3.v,
          width: double.maxFinite,
          margin: EdgeInsets.only(top: 40.v),
          decoration: BoxDecoration(
            color: appTheme.gray10001,
          ),
        );
      default:
        return null;
    }
  }
}

enum Styled {
  bgGradientnameblack90001opacity0nameblack90001opacity06,
  bgFill_1,
  bgFill_2,
  bgFill_3,
  bgFill,
}
