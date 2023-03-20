import 'package:flutter/material.dart';

abstract class Insets {
  static const double xs = 5;
  static const double sm = 10;
  static const double med = 15;
  static const double lg = 20;
  static const double xl = 30;

  /// The offset of every page from the border of the device.
  static const double offset = 15;
}

abstract class Corners {
  static const double sm = 5;
  static const Radius smRadius = Radius.circular(sm);
  static const BorderRadius smBorderRadius = BorderRadius.all(smRadius);

  static const double med = 10;
  static const Radius medRadius = Radius.circular(med);
  static const BorderRadius medBorderRadius = BorderRadius.all(medRadius);

  static const double lg = 20;
  static const Radius lgRadius = Radius.circular(lg);
  static const BorderRadius lgBorderRadius = BorderRadius.all(lgRadius);
}

/// The duration used for all animations.
abstract class Timings {
  static const Duration short = Duration(milliseconds: 150);
  static const Duration med = Duration(milliseconds: 300);
}

/// Fonts - A list of Font Families, used by the TextStyles class to create
/// concrete styles.
abstract class Fonts {}

/// TextStyles - All core text styles for the app are be declared here.
/// Every variant in the app is not declared here; just the high level ones.
/// More specific variants are created on the fly using `style.copyWith()`
/// Ex: newStyle = TextStyles.body1.copyWith(lineHeight: 2, color: Colors.red)
abstract class TextStyles {
  static const TextStyle h1 = TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
  static const TextStyle h2 = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  static const TextStyle title1 = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle body1 = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
  static const TextStyle body2 = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
  //TODO: make AppColors.neutralContent the default color
  static const TextStyle caption = TextStyle(fontSize: 12, fontWeight: FontWeight.normal);
}
