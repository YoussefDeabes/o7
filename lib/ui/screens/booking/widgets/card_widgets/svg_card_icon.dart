import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgCardIcon extends StatelessWidget {
  final String assetPath;
  const SvgCardIcon({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OrientationBuilder(builder: (context, orientation) {
      return SvgPicture.asset(
        assetPath,
        width: orientation == Orientation.portrait
            ? 0.04 * size.width
            : 0.04 * size.height,
        // allowDrawingOutsideViewBox: true,
      );
    });
  }
}
