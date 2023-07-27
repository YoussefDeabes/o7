import 'package:flutter/material.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/ui/screens/booking/widgets/card_widgets/svg_card_icon.dart';

class TherapistRank extends StatelessWidget {
  final String? therapistRank;
  const TherapistRank({super.key, required this.therapistRank});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SvgCardIcon(assetPath: AssPath.starIcon),
        // SvgPicture.asset(AssPath.starIcon, width: 0.04 * width),
        // Image.asset(AssPath.starIcon, width: 0.04 * width),
        SizedBox(width: 0.01 * MediaQuery.of(context).size.width),
        const Text(
          "--", //therapistModel.rank.toStringAsFixed(1),
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
      ],
    );
  }
}
