import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';

/// the icon used in the booking screen
// ignore: must_be_immutable
class BookingScreenIcon extends BaseStatelessWidget {
  BookingScreenIcon({required this.assetPath, required this.onTap, Key? key})
      : super(key: key);

  final void Function()? onTap;
  final String assetPath;

  @override
  Widget baseBuild(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              assetPath,
              width: 0.06 * width,
            ),
          ),
        ),
      ),
    );
  }
}
