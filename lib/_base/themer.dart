import 'package:flutter/material.dart';

mixin Themer {
  late ThemeData themeData;
  late TextTheme textTheme;

  void initThemer(BuildContext context) {
    themeData = Theme.of(context);
    textTheme = themeData.textTheme;
  }

  Color primaryColor() => themeData.primaryColor;
}
