import 'package:flutter/material.dart';
import 'package:o7therapy/_base/platform_manager.dart';
import 'package:o7therapy/_base/screen_sizer.dart';
import 'package:o7therapy/_base/themer.dart';
import 'package:o7therapy/_base/translator.dart';

// ignore: must_be_immutable
abstract class BaseStatelessWidget extends StatelessWidget
    with Translator, ScreenSizer, Themer, PlatformManager {
  BaseStatelessWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    initScreenSizer(context);
    initThemer(context);
    return baseBuild(context);
  }

  Widget baseBuild(BuildContext context);
}
