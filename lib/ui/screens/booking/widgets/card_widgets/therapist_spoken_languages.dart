import 'package:flutter/material.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/widgets/card_widgets/svg_card_icon.dart';

/// Therapist Spoken Languages
class TherapistSpokenLanguages extends StatelessWidget {
  final List<String>? spokenLanguages;
  const TherapistSpokenLanguages({
    super.key,
    required this.spokenLanguages,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: 0.2 * width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SvgCardIcon(assetPath: AssPath.speakIcon),
          // Image.asset(AssPath.languageTherapistCanSpeakIcon,
          //     width: 0.04 * width),
          SizedBox(width: 0.016 * width),
          SizedBox(
            width: 0.14 * width,
            child: Text(
              getTherapistSpokenLanguagesString(),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: const TextStyle(
                  fontSize: 13.0,
                  color: ConstColors.text,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  /// get the Therapist Spoken Languages String from list
  String getTherapistSpokenLanguagesString() {
    final StringBuffer buffer = StringBuffer();
    if (spokenLanguages != null) {
      final List<String> languages = spokenLanguages!;
      for (int i = 0; i < languages.length; i++) {
        /// the next line to get the first 2 chars of languages only
        final String language = "${languages[i][0]}${languages[i][1]}";
        if (i != languages.length - 1) {
          buffer.write("$language, ");
        } else {
          buffer.write(language);
        }
      }
    }
    return buffer.toString();
  }
}
