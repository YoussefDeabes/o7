import 'dart:math';

import 'package:flutter/material.dart';

class ConstColors {
  static final MaterialColor primarySwatch = generateMaterialColors(app);

  static const app = Color(0xff2D5D63);
  static const secondary = Color(0xff6AB4A9);
  static const accentColor = Color(0xffD5B582);

  static const _appBlack = Colors.black;
  static const appWhite = Colors.white;
  static const appGrey = Color(0xffA0A0A0);
  static const appBlack = _appBlack;
  static const success = Color(0xff009A7E);
  static const info = Color(0xff6AB4A9);
  static const warning = Color(0xffFEBF62);
  static const error = Color(0xffC54127);
  static const disabled = Color(0xffEBEBEB);
  static const solid = Color(0xffD9D9D9);
  static const other = Color(0xffD46E5B);

  static const _appSliverChalice = Color(0xffA0A0A0);
  static const _appMercury = Color(0xffE5E5E5);
  static const _appFlamingo = Color(0xffEF5B11);
  static const _appDark = Color(0xff025682);
  static const appTitle = app;
  static const txtButton = secondary;
  static const accent = accentColor;
  static const text = Color(0xff373737);
  static const textGrey = Color(0xffA0A0A0);
  static const textSecondary = Color(0xff626262);
  static const textDisabled = Color(0xffA0A0A0);
  static const counterColor = Color(0xFF429F91);

  static const toastBackground = _appBlack;
  static const scaffoldBackgroundSpindle = _appMercury;
  static const toastText = appWhite;

  static const bannerBackground = secondary;
  static const bannerText = appWhite;
  static const bannerIcon = secondary;

  static const divider = appGrey;
  static const scaffoldBackground = Color(0xffFAFAFA);
  static const drawerBackground = app;
  static const drawerSelected = appGrey;

  static const bottomNavBackground = appWhite;
  static const bottomNavItemSelected = _appDark;
  static const bottomNavSelected = appWhite;
  static const bottomNavNotSelected = textDisabled;

  static const filterButton = appWhite;

  static const authHint = _appSliverChalice;
  static const authTxt = _appBlack;
  static const authPrimary = app;
  static const authSecondary = secondary;
  static const authAction = appWhite;
  static const authUnderline = _appMercury;
  static const authDisable = _appSliverChalice;
  static const authObscure = _appSliverChalice;
  static const authDropdownArrow = _appSliverChalice;
  static const authSendCode = _appFlamingo;
}

MaterialColor generateMaterialColors(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);

/**
    Hexadecimal opacity values
    100% — FF
    95% — F2
    90% — E6
    85% — D9
    80% — CC
    75% — BF
    70% — B3
    65% — A6
    60% — 99
    55% — 8C
    50% — 80
    45% — 73
    40% — 66
    35% — 59
    30% — 4D
    25% — 40
    20% — 33
    15% — 26
    10% — 1A
    5% — 0D
    0% — 00
 */
