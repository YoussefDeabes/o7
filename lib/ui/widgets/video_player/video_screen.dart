import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/mental_health_video.dart';

class VideoScreen extends StatefulWidget {
  static const routeName = '/video-screen';

  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  String? videoUrl;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    videoUrl = args['videoUrl']!;
    return Dismissible(
      key: const Key('dismiss'),
      direction: DismissDirection.down,
      onDismissed: (_) => Navigator.pop(context),
      child: Scaffold(
          backgroundColor: ConstColors.appBlack,
          body: Center(child: MentalHealthVideo(videoUrl: videoUrl!))),
    );
  }
}
