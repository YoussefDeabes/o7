/// SRC: https://pub.dev/packages/loader_overlay

import 'package:flutter/material.dart';
import 'package:o7therapy/_base/custom_loading_widget.dart';

class GlobalLoaderOverlay extends InheritedWidget {
  const GlobalLoaderOverlay({super.key, required super.child});

  static OverlayEntry? _overlayEntry;

  showOverlayLoader(BuildContext context) {
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(builder: (_) => const CustomLoadingWidget());
    overlay.insert(_overlayEntry!);
  }

  hideOverlayLoader() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static GlobalLoaderOverlay? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlobalLoaderOverlay>();
  }

  @override
  bool updateShouldNotify(GlobalLoaderOverlay oldWidget) => true;
}
