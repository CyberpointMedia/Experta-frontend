import 'package:flutter/material.dart';
import 'package:experta/core/app_export.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlack => BoxDecoration(
        color: appTheme.black90001.withOpacity(0.9),
      );
  static BoxDecoration get fillBlack90001 => BoxDecoration(
        color: appTheme.black90001,
      );
  static BoxDecoration get fillBlueGray => BoxDecoration(
        color: appTheme.blueGray100,
      );
  static BoxDecoration get fillDeepPurple => BoxDecoration(
        color: appTheme.deepPurple300.withOpacity(0.12),
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray20002,
      );
  static BoxDecoration get fillGray10001 => BoxDecoration(
        color: appTheme.gray10001,
      );
  static BoxDecoration get fillGray300 => BoxDecoration(
        color: appTheme.gray300,
      );
  static BoxDecoration get fillGray80001 => BoxDecoration(
        color: appTheme.gray80001,
      );
  static BoxDecoration get fillGray900 => BoxDecoration(
        color: appTheme.gray900.withOpacity(0.3),
      );
  static BoxDecoration get fillGray9001 => BoxDecoration(
        color: appTheme.gray900,
      );
  static BoxDecoration get fillGray9002 => BoxDecoration(
        color: appTheme.gray900.withOpacity(0.12),
      );
  static BoxDecoration get fillGrayEa => BoxDecoration(
        color: appTheme.gray50Ea,
      );
  static BoxDecoration get fillGreen => BoxDecoration(
        color: appTheme.green400,
      );
  static BoxDecoration get fillGreen400 => BoxDecoration(
        color: appTheme.green400.withOpacity(0.12),
      );
  static BoxDecoration get fillOnPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary,
      );
  static BoxDecoration get fillOnPrimaryContainer => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static BoxDecoration get fillPrimary => BoxDecoration(
        color: theme.colorScheme.primary,
      );
  static BoxDecoration get fillPrimaryContainer => BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.12),
      );
  static BoxDecoration get fillYellow => BoxDecoration(
        color: appTheme.yellow900.withOpacity(0.12),
      );

  // Gradient decorations
  static BoxDecoration get gradientBlackToBlack => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 0.79),
          colors: [
            appTheme.black90001.withOpacity(0),
            appTheme.black90001.withOpacity(0.6),
          ],
        ),
      );
  static BoxDecoration get gradientBlackToBlack90001 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.black90001.withOpacity(0),
            appTheme.black90001,
          ],
        ),
      );
  static BoxDecoration get gradientGrayToGray => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.gray20002.withOpacity(0),
            appTheme.gray20002,
          ],
        ),
      );
  static BoxDecoration get gradientGrayToGray20002 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0.12),
          end: Alignment(0.5, 0.61),
          colors: [
            appTheme.gray20002.withOpacity(0),
            appTheme.gray20002,
          ],
        ),
      );
  static BoxDecoration get gradientOnPrimaryContainerToOnPrimaryContainer =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.17, 0.29),
          end: Alignment(0.17, 0.01),
          colors: [
            theme.colorScheme.onPrimaryContainer.withOpacity(1),
            theme.colorScheme.onPrimaryContainer.withOpacity(0),
          ],
        ),
      );

  // Outline decorations
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: appTheme.black90001.withOpacity(0.05),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              30,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack90001 => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: appTheme.black90001.withOpacity(0.5),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              2,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineGray => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        border: Border.all(
          color: appTheme.gray30001,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGray30001 => BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray30001,
            width: 1.h,
          ),
        ),
      );
  static BoxDecoration get outlineGray300011 => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray30001,
            width: 1.h,
          ),
        ),
      );
  static BoxDecoration get outlineGray300012 => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static BoxDecoration get outlineOnPrimaryContainer => BoxDecoration(
        color: appTheme.gray40001,
        border: Border.all(
          color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
          width: 2.h,
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.black9001e,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              4,
            ),
          ),
        ],
      );
  static BoxDecoration get outlinePrimary => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlinePrimary1 => BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 1.h,
        ),
      );
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder23 => BorderRadius.circular(
        23.h,
      );
  static BorderRadius get circleBorder29 => BorderRadius.circular(
        29.h,
      );
  static BorderRadius get circleBorder37 => BorderRadius.circular(
        37.h,
      );
  static BorderRadius get circleBorder40 => BorderRadius.circular(
        40.h,
      );
  static BorderRadius get circleBorder46 => BorderRadius.circular(
        46.h,
      );
  static BorderRadius get circleBorder50 => BorderRadius.circular(
        50.h,
      );
  static BorderRadius get circleBorder60 => BorderRadius.circular(
        60.h,
      );
  static BorderRadius get circleBorder70 => BorderRadius.circular(
        70.h,
      );
  static BorderRadius get circleBorder80 => BorderRadius.circular(
        80.h,
      );

  // Custom borders
  static BorderRadius get customBorderL20 => BorderRadius.vertical(
        bottom: Radius.circular(20.h),
      );
  static BorderRadius get customBorderBL20 => BorderRadius.vertical(
        top: Radius.circular(20.h),
      );
  static BorderRadius get customBorderBL24 => BorderRadius.vertical(
        bottom: Radius.circular(24.h),
      );
  static BorderRadius get customBorderTL14 => BorderRadius.vertical(
        top: Radius.circular(14.h),
      );
  static BorderRadius get customBorderTL20 => BorderRadius.only(
        topLeft: Radius.circular(20.h),
        topRight: Radius.circular(20.h),
        bottomRight: Radius.circular(20.h),
      );
  static BorderRadius get customBorderTL201 => BorderRadius.only(
        topLeft: Radius.circular(20.h),
        topRight: Radius.circular(20.h),
        bottomLeft: Radius.circular(20.h),
      );
  static BorderRadius get customBorderTL202 => BorderRadius.vertical(
        top: Radius.circular(20.h),
      );
  static BorderRadius get customBorderTL24 => BorderRadius.vertical(
        top: Radius.circular(24.h),
      );

  // Rounded borders
  static BorderRadius get roundedBorder1 => BorderRadius.circular(
        1.h,
      );
  static BorderRadius get roundedBorder10 => BorderRadius.circular(
        10.h,
      );
  static BorderRadius get roundedBorder15 => BorderRadius.circular(
        15.h,
      );
  static BorderRadius get roundedBorder20 => BorderRadius.circular(
        20.h,
      );
  static BorderRadius get roundedBorder5 => BorderRadius.circular(
        5.h,
      );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
    