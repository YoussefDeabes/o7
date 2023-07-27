import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization.dart';

class AppTheme {
  final Locale locale;
  const AppTheme(this.locale);

  ThemeData get themeDataLight {
    return ThemeData(
        primarySwatch: ConstColors.primarySwatch,
        fontFamily: locale.languageCode == codeAr ? "Vazirmatn" : 'Poppins',
        // useMaterial3: true,
        scaffoldBackgroundColor: ConstColors.scaffoldBackground);
  }
}
