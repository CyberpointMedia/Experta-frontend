import 'package:flutter/material.dart';
import '../core/app_export.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.alignment,
    this.height,
    this.width,
    this.padding,
    this.decoration,
    this.child,
    this.onTap,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;

  final Widget? child;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: iconButtonWidget,
          )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Container(
            height: height ?? 0,
            width: width ?? 0,
            padding: padding ?? EdgeInsets.zero,
            decoration: decoration ??
                BoxDecoration(
                  color: appTheme.green400.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(22.h),
                ),
            child: child,
          ),
          onPressed: onTap,
        ),
      );
}

/// Extension on [CustomIconButton] to facilitate inclusion of all types of border style etc
extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get fillPrimary => BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(30.h),
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray10001,
        borderRadius: BorderRadius.circular(30.h),
      );
  static BoxDecoration get outlineOnPrimaryContainer => BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(21.h),
        border: Border.all(
          color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
          width: 3.h,
        ),
      );
  static BoxDecoration get outline => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(0.35),
        borderRadius: BorderRadius.circular(20.h),
      );
  static BoxDecoration get fillGreen => BoxDecoration(
        color: appTheme.green400,
        borderRadius: BorderRadius.circular(24.h),
      );
  static BoxDecoration get fillPrimaryContainer => BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24.h),
      );
  static BoxDecoration get fillPrimaryTL24 => BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24.h),
      );
  static BoxDecoration get fillPrimaryTL21 => BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(21.h),
      );
  static BoxDecoration get fillPrimaryContainerTL21 => BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(21.h),
      );
  static BoxDecoration get fillOnPrimaryContainer => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(26.h),
      );
  static BoxDecoration get outlineGray => BoxDecoration(
        color: appTheme.gray800,
        borderRadius: BorderRadius.circular(16.h),
        border: Border.all(
          color: appTheme.gray700,
          width: 1.h,
        ),
      );
  static BoxDecoration get fillYellowE => BoxDecoration(
        color: appTheme.yellow6001e,
        borderRadius: BorderRadius.circular(22.h),
      );
  static BoxDecoration get fillGrayTL22 => BoxDecoration(
        color: appTheme.gray900.withOpacity(0.12),
        borderRadius: BorderRadius.circular(22.h),
      );
  static BoxDecoration get fillDeepPurple => BoxDecoration(
        color: appTheme.deepPurple300.withOpacity(0.12),
        borderRadius: BorderRadius.circular(22.h),
      );
  static BoxDecoration get fillPrimaryContainerTL22 => BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.12),
        borderRadius: BorderRadius.circular(22.h),
      );
  static BoxDecoration get outlineGrayTL22 => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        borderRadius: BorderRadius.circular(22.h),
        border: Border.all(
          color: appTheme.gray30001,
          width: 1.h,
        ),
      );
  static BoxDecoration get fillGreenTL24 => BoxDecoration(
        color: appTheme.green100,
        borderRadius: BorderRadius.circular(24.h),
      );
  static BoxDecoration get outlineGrayTL28 => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        borderRadius: BorderRadius.circular(28.h),
        border: Border.all(
          color: appTheme.gray30001,
          width: 1.h,
        ),
      );
  static BoxDecoration get fillBlack => BoxDecoration(
        color: appTheme.black90001.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.h),
      );
}
