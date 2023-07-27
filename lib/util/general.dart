import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// Difference between debug and release and profile mode
/// https://github.com/flutter/flutter/wiki/Flutter%27s-modes

bool isDebugMode() => kDebugMode;
bool isReleaseMode() => kReleaseMode;
bool isProfileMode() => kProfileMode;

String getCurrencyNameByContext(BuildContext context, String? currencyName) =>
    _getCurrencyName(currencyName, AppLocalizations.of(context).translate);

String getCurrencyNameByAppLocal(
        AppLocalizations appLocale, String? currencyName) =>
    _getCurrencyName(currencyName, appLocale.translate);

String _getCurrencyName(
  String? currency,
  final String Function(String) translate,
) {
  if (currency == null) {
    return "";
  }
  final String currencyName = currency.toLowerCase().trim();
  if (currencyName == "egp") {
    return translate(LangKeys.egp);
  } else if (currencyName == "usd") {
    return translate(LangKeys.usd);
  } else if (currencyName == "kwd") {
    return translate(LangKeys.kwd);
  } else {
    return currency;
  }
}

String getRasselCurrency(BuildContext context, num currency) {
  String Function(String key) translate =
      AppLocalizations.of(context).translate;
  switch (currency) {
    case 1:
      return translate(LangKeys.egp);
    case 2:
      return translate(LangKeys.usd);
    case 5:
      return translate(LangKeys.kwd);
    default:
      return translate(LangKeys.egp);
  }
}

DateTime getUtcDateTimeFromBackEndString(String stringDateTime) {
  String dateWithT =
      '${stringDateTime.substring(0, 8)}T${stringDateTime.substring(8)}Z';

  return DateTime.parse(dateWithT).toUtc();
}

DateTime getUtcDateTimeFromBackEndLocalTimeString(String stringDateTime) {
  int year = int.parse(stringDateTime.substring(0, 4));
  int month = int.parse(stringDateTime.substring(4, 6));
  int day = int.parse(stringDateTime.substring(6, 8));
  int hour = int.parse(stringDateTime.substring(8, 10));
  int minute = int.parse(stringDateTime.substring(10, 12));
  int second = int.parse(stringDateTime.substring(12, 14));
  // String dateWithT =
  //     '${stringDateTime.substring(0, 8)}T${stringDateTime.substring(8)}Z';
  final DateTime localDateTime =
      DateTime(year, month, day, hour, minute, second);
  log(localDateTime.toIso8601String());
  final DateTime utcDateTime = localDateTime.toUtc();
  log(utcDateTime.toIso8601String());
  return utcDateTime;
}
