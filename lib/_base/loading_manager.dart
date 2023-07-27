import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/_base/custom_loading_widget.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/ui/loaders/full_screen_loader_widget.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

mixin LoadingManager {
  void runChangeState();

  Translator provideTranslate();

  late String message;
  bool isLoading = false;
  bool isLoadingWithMessage = false;

  void showLoading() async {
    if (!isLoading) {
      isLoading = true;
      runChangeState();
    }
  }

  void hideLoading() async {
    if (isLoading) {
      isLoading = false;
      runChangeState();
    }
  }

  void showMessageLoading(String? message) async {
    this.message = message ?? plzWaitMsg();
    if (!isLoadingWithMessage) {
      isLoadingWithMessage = true;
      runChangeState();
    }
  }

  void hideMessageLoading() async {
    if (isLoadingWithMessage) {
      isLoadingWithMessage = false;
      runChangeState();
    }
  }

  Widget loadingManagerWidget() {
    if (isLoading) {
      return customLoadingWidget();
    } else if (isLoadingWithMessage) {
      return customLoadingMessageWidget(message);
    } else {
      return getEmptyWidget();
    }
  }

  /// use this method if you want to change the default loading widget
  Widget customLoadingWidget() => const CustomLoadingWidget();

  /// use this method if you want to change the default loading widget with
  /// it's message
  /// [message] --> refer to the message that you want to display
  /// that already submitted using [showMessageLoading]
  Widget customLoadingMessageWidget(String message) {
    return FullScreenLoaderWidget.message(message);
  }

  String plzWaitMsg() => provideTranslate().translate(LangKeys.plzWait);
}
