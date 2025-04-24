import 'package:flutter/material.dart';

// Mapping for old TextTheme names to new ones
extension TextThemeExtension on TextTheme {
  TextStyle? get headline1 => displayLarge;
  TextStyle? get headline2 => displayMedium;
  TextStyle? get headline3 => displaySmall;
  TextStyle? get headline4 => headlineMedium;
  TextStyle? get headline5 => headlineSmall;
  TextStyle? get headline6 => titleLarge;
  TextStyle? get subtitle1 => titleMedium;
  TextStyle? get subtitle2 => titleSmall;
  TextStyle? get bodyText1 => bodyLarge;
  TextStyle? get bodyText2 => bodyMedium;
  TextStyle? get caption => bodySmall;
  TextStyle? get button => labelLarge;
  TextStyle? get overline => labelSmall;
} 