import 'package:flutter/material.dart';
import 'package:o7therapy/_base/global_loader_overlay.dart';

///Just a extension to make it cleaner to show or hide the overlay
extension OverlayControllerWidgetExtension on BuildContext {
  void showLoader() => GlobalLoaderOverlay.of(this)?.showOverlayLoader(this);
  void hideLoader() => GlobalLoaderOverlay.of(this)?.hideOverlayLoader();
}
