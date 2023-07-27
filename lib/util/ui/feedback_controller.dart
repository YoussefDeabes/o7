import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:o7therapy/api/send_bird_manager.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/rassel/model/fresh_chat_helper.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage.dart';

void showToast(String message,
    [Color toastBgColor = Colors.black, Color customTextColor = Colors.white]) {
  /// reference
  /// https://pub.dev/packages/fluttertoast
  ///
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: toastBgColor,
      // textColor: ConstColors.error,
      textColor: customTextColor,
      fontSize: 16.0);
}

SnackBar createSnackBar(String message) {
  return SnackBar(
    duration: const Duration(seconds: 3),
    content: Text(message),
  );
}

void showSnackBarWithContext(SnackBar snackBar, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void clearData() async {
  SendBirdManager.logout();
  await PrefManager.setLoggedIn(value: false);
  await SecureStorage.setLoggedIn(value: false);

  /// Should be used when user logs out of the application
  FreshChatHelper.instance.reset();
}

/// references
/// https://pub.dev/packages/fluttertoast
/// https://www.youtube.com/watch?v=UkudAgCEhBI
/// https://www.youtube.com/watch?v=_jRnmwno668
