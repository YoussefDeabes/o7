import 'package:flutter/material.dart';
import 'package:o7therapy/util/lang/app_localization.dart';

/// u can use this values like: context.width
extension MediaQueryValues on BuildContext {
  String Function(String key) get translate =>
      AppLocalizations.of(this).translate;

  bool get isArabic =>
      AppLocalizations.of(this).locale.languageCode.toLowerCase() == "ar";

  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double get toPadding => MediaQuery.of(this).viewPadding.top;
  double get bottom => MediaQuery.of(this).viewInsets.bottom;
}
