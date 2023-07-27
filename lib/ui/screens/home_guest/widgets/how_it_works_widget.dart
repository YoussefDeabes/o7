import 'package:flutter/material.dart';

class HowItWorks extends StatelessWidget {
  static const valueKey = ValueKey("HowItWorks");
  final Image assetImage;

  const HowItWorks({required this.assetImage}) : super(key: valueKey);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: assetImage,
      ),
    );
  }
}
