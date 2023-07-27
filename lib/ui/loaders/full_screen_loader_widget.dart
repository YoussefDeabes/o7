import 'package:flutter/material.dart';

import 'flash_in_out_loading_widget.dart';

class FullScreenLoaderWidget extends StatelessWidget {
  final String? message;

  const FullScreenLoaderWidget({this.message});

  factory FullScreenLoaderWidget.onlyAnimation() {
    return const FullScreenLoaderWidget();
  }

  factory FullScreenLoaderWidget.message(String message) {
    return FullScreenLoaderWidget(message: message);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      color: theme.primaryColor.withOpacity(0.5),
      height: 10,
      width: 10,
      child: Center(
          child: message != null
              ? txtWithLoading(theme.cardColor)
              : flashLoading(theme.cardColor)),
    );
  }

  Widget flashLoading(Color color) => FlashInOutLoadingWidget(color: color);

  Widget txtWithLoading(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // flashLoading(color),
        const SizedBox(width: 20),
        Text(message!, style: TextStyle(fontSize: 25, color: color))
      ],
    );
  }
}
