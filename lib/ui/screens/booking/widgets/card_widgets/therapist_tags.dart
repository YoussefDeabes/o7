import 'package:flutter/material.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/widgets/card_widgets/svg_card_icon.dart';

class TherapistTags extends StatelessWidget {
  final List<String>? tags;
  const TherapistTags({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        const SvgCardIcon(assetPath: AssPath.tagIcon),
        SizedBox(width: 0.016 * width),
        SizedBox(
          width: 0.45 * width,
          child: Text(
            getTherapistTagsString(),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 13.0,
                color: ConstColors.text,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  /// get the Therapist Skills String from list
  String getTherapistTagsString() {
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < tags!.length; i++) {
      if (i != tags!.length - 1) {
        buffer.write("${tags![i]}, ");
      } else {
        buffer.write(tags![i]);
      }
    }
    return buffer.toString();
  }
}
