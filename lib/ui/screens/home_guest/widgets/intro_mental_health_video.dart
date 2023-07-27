import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/header_text_widget.dart';
import 'package:o7therapy/ui/widgets/video_player/video_screen.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/screen_controller.dart';

import 'mental_health_video.dart';

class IntroMentalHealthVideo extends StatelessWidget {
  const IntroMentalHealthVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: HeaderWidget(
            text: context.translate(LangKeys.introToMentalHealthTitle),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(VideoScreen.routeName, arguments: {
              "videoUrl": _getHomePageMentalHealthVideoUrl(context)
            }).whenComplete(() {
              exitFullScreen();
              WidgetsFlutterBinding.ensureInitialized();
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
            });
          },
          child: AbsorbPointer(
            child: MentalHealthVideo(
                videoUrl: _getHomePageMentalHealthVideoUrl(context)),
          ),
        ),
      ],
    );
  }

  String _getHomePageMentalHealthVideoUrl(BuildContext context) {
    if (AppLocalizations.of(context).locale.languageCode == 'ar') {
      return "https://www.youtube.com/watch?v=VulbzY7CcPo";
    }
    return 'https://www.youtube.com/watch?v=KdJgiZnYNeg';
  }
}
