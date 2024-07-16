import 'package:flutter/material.dart';
import 'package:experta/core/utils/size_utils.dart';
import 'package:experta/theme/theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLargeBlack90001 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black90001,
      );
  static get bodyLargeBlack => theme.textTheme.bodyLarge!
      .copyWith(color: appTheme.black90001, fontSize: 32);
  static get bodyLargeGray900 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray900,
      );
  static get bodyLargeGray90001 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray90001,
      );
  static get bodyLargeOnPrimaryContainer => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 18.fSize,
      );
  static get bodyLargeSFProTextBlueA400 =>
      theme.textTheme.bodyLarge!.sFProText.copyWith(
        color: appTheme.blueA400,
        fontSize: 17.fSize,
      );
  static get bodyLargeSFProTextLightblueA700 =>
      theme.textTheme.bodyLarge!.sFProText.copyWith(
        color: appTheme.lightBlueA700,
        fontSize: 17.fSize,
      );
  static get bodyLargeff171717 => theme.textTheme.bodyLarge!.copyWith(
        color: const Color(0XFF171717),
      );
  static get bodyLargeff95a4b7 => theme.textTheme.bodyLarge!.copyWith(
        color: const Color(0XFF95A4B7),
      );
  static get bodyMediumBlack90001 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.black90001,
      );
  static get bodyMediumGray900 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray900,
      );
  static get bodyMediumInterBlack90001 =>
      theme.textTheme.bodyMedium!.inter.copyWith(
        color: appTheme.black90001,
      );
  static get bodyMediumLight => theme.textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.w300,
      );
  static get bodyMediumff171717 => theme.textTheme.bodyMedium!.copyWith(
        color: const Color(0XFF171717),
      );
  static get bodyMediumff95a4b7 => theme.textTheme.bodyMedium!.copyWith(
        color: const Color(0XFF95A4B7),
      );
  static get bodySmall11 => theme.textTheme.bodySmall!.copyWith(
        fontSize: 11.fSize,
      );
  static get bodySmallBluegray300 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray300,
        fontSize: 12.fSize,
      );
  static get bodySmallLightgreen40001 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.lightGreen40001,
        fontSize: 12.fSize,
      );
  static get bodySmallSFProTextGray900 =>
      theme.textTheme.bodySmall!.sFProText.copyWith(
        color: appTheme.gray900,
        fontSize: 12.fSize,
        fontWeight: FontWeight.w300,
      );
  static get bodySmallffffffff => theme.textTheme.titleMedium!.copyWith(
        color: const Color(0XFFFFFFFF),
        fontSize: 12.fSize,
      );
  // Display text style
  static get displaySmallff171717 => theme.textTheme.displaySmall!.copyWith(
        color: const Color(0XFF171717),
      );
  static get displaySmallff95a4b7 => theme.textTheme.displaySmall!.copyWith(
        color: const Color(0XFF95A4B7),
      );
  // Headline text style
  static get headlineLargeMedium => theme.textTheme.headlineLarge!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get headlineSmallBold => theme.textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get headlineSmallOnPrimaryContainer =>
      theme.textTheme.headlineSmall!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  // Label text style
  static get labelLargeBluegray300 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray300.withOpacity(0.56),
        fontWeight: FontWeight.w700,
      );
  static get labelLargeBluegray300Medium =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray300,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeGray900 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray900,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeGray900Medium => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray900,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeGray900_1 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray900,
      );
  static get labelLargeGray700 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray700,
      );
  static get labelLargeOnPrimaryContainer =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontWeight: FontWeight.w500,
      );
  static get labelLargeSFProTextBlack90001 =>
      theme.textTheme.labelLarge!.sFProText.copyWith(
        color: appTheme.black90001,
        fontSize: 13.fSize,
        fontWeight: FontWeight.w500,
      );

  static get textButton => theme.textTheme.labelLarge!.sFProText.copyWith(
        color: appTheme.deepOrangeA200,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeff171717 => theme.textTheme.labelLarge!.copyWith(
        color: const Color(0XFF171717),
        fontWeight: FontWeight.w500,
      );
  static get labelLargeff95a4b7 => theme.textTheme.labelLarge!.copyWith(
        color: const Color(0XFF95A4B7),
        fontWeight: FontWeight.w500,
      );
  static get labelMediumErrorContainer => theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.errorContainer,
      );
  static get labelMediumGray900 => theme.textTheme.labelMedium!.copyWith(
        color: appTheme.gray400,
        fontSize: 14,
      );
  static get labelMediumGreen400 => theme.textTheme.labelMedium!.copyWith(
        color: appTheme.green400,
        fontWeight: FontWeight.w500,
      );
  static get labelMediumBlack900 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.bold,
      );
  static get labelBigBlack900 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 21,
        color: appTheme.black900,
        fontWeight: FontWeight.bold,
      );
  // Title text style
  static get titleLargeMedium => theme.textTheme.titleLarge!.copyWith(
        fontSize: 20.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleLargeOnPrimaryContainer =>
      theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 20.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleLargeSemiBold => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static get titleMedium18 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.fSize,
      );
  static get titleMediumBlack90001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black90001,
      );
  static get titleMediumBluegray300 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray300,
      );
  static get titleMediumBluegray30018 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray300,
        fontSize: 18.fSize,
      );
  static get titleMediumBold => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumBold_1 => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get titleMediumDeeporangeA200 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.deepOrangeA200,
      );
  static get titleMediumErrorContainer => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.errorContainer,
      );
  static get titleMediumGilroy => theme.textTheme.titleMedium!.gilroy;
  static get titleMediumGilroyBluegray300 =>
      theme.textTheme.titleMedium!.gilroy.copyWith(
        color: appTheme.blueGray300,
      );
  static get titleMediumGilroyOnPrimaryContainer =>
      theme.textTheme.titleMedium!.gilroy.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static get titleMediumGray400 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray400,
      );
  static get titleMediumGray90001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray90001,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumInterBlack90001 =>
      theme.textTheme.titleMedium!.inter.copyWith(
        color: appTheme.black90001,
        fontSize: 18.fSize,
      );
  static get titleMediumInterLightblueA700 =>
      theme.textTheme.titleMedium!.inter.copyWith(
        color: appTheme.lightBlueA700,
      );
  static get titleMediumOnPrimaryContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static get titleMediumOnPrimaryContainerBold =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumOnPrimaryContainer_1 =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get titleMediumSFProText => theme.textTheme.titleMedium!.sFProText;

  static get titleMediumSFProTextBlack90001 =>
      theme.textTheme.titleMedium!.sFProText.copyWith(
        color: appTheme.black90001,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumSemiBold => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumSemiBold_1 => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static get titleMediumff171717 => theme.textTheme.titleMedium!.copyWith(
        color: const Color(0XFF171717),
        fontWeight: FontWeight.w600,
      );
  static get titleMediumff171717_1 => theme.textTheme.titleMedium!.copyWith(
        color: const Color(0XFF171717),
      );
  static get titleSmallDeeporange500 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.deepOrange500,
      );
  static get titleSmallDeeporangeA200 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.deepOrangeA200,
      );
  static get titleSmallGilroyErrorContainer =>
      theme.textTheme.titleSmall!.gilroy.copyWith(
        color: theme.colorScheme.errorContainer,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallGilroyff171717 =>
      theme.textTheme.titleSmall!.gilroy.copyWith(
        color: const Color(0XFF171717),
        fontWeight: FontWeight.w600,
      );
  static get titleSmallGilroyff95a4b7 =>
      theme.textTheme.titleSmall!.gilroy.copyWith(
        color: const Color(0XFF95A4B7),
        fontWeight: FontWeight.w600,
      );
  static get titleSmallGray800 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray800,
      );
  static get titleSmallGray900 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray900,
      );
  static get titleSmallGray900SemiBold => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray900,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallGreen400 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.green400,
      );
  static get titleSmallOnPrimaryContainer =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get titleSmallOnPrimaryContainerSemiBold =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static get titleSmallPrimary => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get titleSmallPrimaryContainer => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primaryContainer,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallff171717 => theme.textTheme.titleSmall!.copyWith(
        color: const Color(0XFF171717),
      );
  static get titleSmallff171717SemiBold => theme.textTheme.titleSmall!.copyWith(
        color: const Color(0XFF171717),
        fontWeight: FontWeight.w600,
      );
  static get titleSmallff64c361 => theme.textTheme.titleSmall!.copyWith(
        color: const Color(0XFF64C361),
        fontWeight: FontWeight.w600,
      );
  static get titleSmallffec1313 => theme.textTheme.titleSmall!.copyWith(
        color: const Color(0XFFEC1313),
        fontWeight: FontWeight.w600,
      );
}

extension on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get gilroy {
    return copyWith(
      fontFamily: 'Gilroy',
    );
  }

  TextStyle get sFProDisplay {
    return copyWith(
      fontFamily: 'SF Pro Display',
    );
  }

  TextStyle get sFProText {
    return copyWith(
      fontFamily: 'SF Pro Text',
    );
  }
}
