import 'dart:ui';

import 'package:flutter/services.dart';

void exitFullScreen() async {
  /// to show status and navigation bar again
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top, // Shows Status bar
      SystemUiOverlay.bottom // show hides Navigation bar
    ],
  );
}

void enterFullScreen() async {
  /// to make screen -> full
  /// hidden status bar in splash screen
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
}

void changeStatusBarColor(Color color) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: color,
  ));
}
