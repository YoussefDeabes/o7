import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/res/assets_path.dart';

class RasselBanner extends StatelessWidget {
  static const ValueKey _valueKeyRasselBanner = ValueKey("RasselBanner");
  const RasselBanner({super.key = _valueKeyRasselBanner});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(AssPath.rasselBanner);
  }
}
