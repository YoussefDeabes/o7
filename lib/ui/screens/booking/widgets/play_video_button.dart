import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/ui/widgets/video_player/video_screen.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/ui/screen_controller.dart';

/// get the play icon image that will play the intro video of the therapist
class PlayVideoButton extends StatelessWidget {
  final String videoUrl;
  const PlayVideoButton({required this.videoUrl, super.key});

  @override
  Widget build(BuildContext context) {
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
                        arguments: {"videoUrl": videoUrl}).whenComplete(() {
                      exitFullScreen();
                      WidgetsFlutterBinding.ensureInitialized();
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]);
                    });
                    // showDialog(
                    //   useSafeArea: true,
                    //   context: context,
                    //   builder: (_) {
                    //     return Dialog(
                    //       insetPadding: EdgeInsets.zero,
                    //       backgroundColor: Colors.transparent,
                    //       child: SizedBox(
                    //         width: double.infinity,
                    //         child: VideoPlayer(url: videoUrl, autoPlay: true),
                    //       ),
                    //     );
                    //   },
                    // );
                  },
                  child: Ink(
                    width: 0.145 * context.width,
                    height: 0.145 * context.width,
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
