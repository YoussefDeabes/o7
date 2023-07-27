import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/ui/widgets/video_player/video_player.dart';
import 'package:o7therapy/ui/widgets/video_player/video_screen.dart';
import 'package:o7therapy/util/ui/screen_controller.dart';

/// get the play icon image that will play the intro video of the therapist
class GuestPlayVideoButton extends BaseStatelessWidget {
  final String videoUrl;
  GuestPlayVideoButton({required this.videoUrl, super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return !isValidYoutubeUrl(videoUrl)
        ? const SizedBox.shrink()
        : Align(
      alignment: AlignmentDirectional.bottomStart,
      child: ClipOval(
        child: Material(
          shadowColor: Colors.black54,
          child: InkWell(
            onTap: () {
              // Play the video of the therapist
              Navigator.of(context).pushNamed(VideoScreen.routeName,
                  arguments: {
                    "videoUrl": videoUrl
                  })
                  .whenComplete((){
                exitFullScreen();
                WidgetsFlutterBinding.ensureInitialized();
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
              });
            },
            child: Ink(
              width: height > width ? 0.145 * width : 0.145 * height,
              height: height > width ? 0.145 * width : 0.145 * height,
              child:
              SvgPicture.asset(AssPath.playCircle, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  /// check that string url is a valid youtube video
  bool isValidYoutubeUrl(String url) {
    final req = RegExp(
        r'^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube(-nocookie)?\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$');
    return req.hasMatch(url);
  }
}
