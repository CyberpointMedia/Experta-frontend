// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillGrayEa => ElevatedButton.styleFrom(
        backgroundColor: appTheme.gray50Ea,
      );
  static ButtonStyle get fillGrayEaBL14 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.gray50Ea,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(
              14.h,
            ),
          ),
        ),
      );
  static ButtonStyle get fillWhite => ElevatedButton.styleFrom(
        backgroundColor: appTheme.whiteA700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            14.h,
          ),
        ),
      );
  static ButtonStyle get fillGreen => ElevatedButton.styleFrom(
        backgroundColor: appTheme.green100,
        shape: RoundedRectangleBorder(
          //yellow900
          borderRadius: BorderRadius.circular(17.h),
        ),
      );

  static ButtonStyle get yellow900 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.yellow900,
        shape: RoundedRectangleBorder(
          //yellow900
          borderRadius: BorderRadius.circular(17.h),
        ),
      );
  static ButtonStyle get fillOnError => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.onError,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.h),
        ),
      );

  static ButtonStyle get fillOnError2 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.gray600,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.h),
        ),
      );

  static ButtonStyle get fillOnPrimaryContainer => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.h),
        ),
      );
  static ButtonStyle get fillOnPrimaryContainer1 => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static ButtonStyle get fillPrimaryTL10 => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.h),
        ),
      );
  static ButtonStyle get fillPrimaryTL23 => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23.h),
        ),
      );

  // Outline button style
  static ButtonStyle get outline => OutlinedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.h),
        ),
      );
  static ButtonStyle get outlineGray => OutlinedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        side: BorderSide(
          color: appTheme.gray30001,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26.h),
        ),
      );
  static ButtonStyle get outlineGrayB => OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: appTheme.gray8005b,
          width: 1,
        ),
        shape: const RoundedRectangleBorder(),
      );
  static ButtonStyle get outlineGrayTL10 => OutlinedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        side: BorderSide(
          color: appTheme.gray30001,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.h),
        ),
      );
  static ButtonStyle get outlineGrayTL21 => OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: appTheme.gray30001,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(21.h),
        ),
      );
  static ButtonStyle get outlineGrayTL23 => OutlinedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        side: BorderSide(
          color: appTheme.gray600,
          width: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26.h),
        ),
      );
  static ButtonStyle get outlineGray1 => OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: appTheme.gray20002,
          width: 1,
        ),
        shape: const RoundedRectangleBorder(),
      );
  static ButtonStyle get outlineLightGreen => OutlinedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        side: BorderSide(
          color: appTheme.lightGreen40001,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.h),
        ),
      );
  static ButtonStyle get outlinePrimary => OutlinedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        side: BorderSide(
          color: theme.colorScheme.primary,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23.h),
        ),
      );
  static ButtonStyle get outlinePrimaryTL10 => OutlinedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        side: BorderSide(
          color: theme.colorScheme.primary,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.h),
        ),
      );
  static ButtonStyle get outlineTL20 => OutlinedButton.styleFrom(
        backgroundColor: appTheme.black90001.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.h),
        ),
      );
  // text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(0),
      );
}
