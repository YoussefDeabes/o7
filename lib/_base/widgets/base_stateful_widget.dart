import 'package:flutter/material.dart';
import 'package:o7therapy/_base/loading_manager.dart';
import 'package:o7therapy/_base/platform_manager.dart';
import 'package:o7therapy/_base/screen_sizer.dart';
import 'package:o7therapy/_base/themer.dart';
import 'package:o7therapy/_base/translator.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  final Color? backGroundColor;

  const BaseStatefulWidget({
    this.backGroundColor,
    Key? key,
  }) : super(key: key);

  @override
  BaseState createState() {
    return baseCreateState();
  }

  BaseState baseCreateState();
}

abstract class BaseState<W extends BaseStatefulWidget> extends State<W>
    with Translator, ScreenSizer, Themer, LoadingManager, PlatformManager {
  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    initScreenSizer(context);
    initThemer(context);
    return baseWidget();
  }

  Widget baseWidget() {
    return Material(
      color: widget.backGroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          baseBuild(context),
          loadingManagerWidget()
        ],
      ),
    );
  }

  void changeState() {
    setState(() {});
  }

  @override
  void runChangeState() {
    changeState();
  }

  @override
  BaseState provideTranslate() {
    return this;
  }

  Widget baseBuild(BuildContext context);
}
