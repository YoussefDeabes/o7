import 'package:flutter/material.dart';
import 'package:o7therapy/ui/widgets/video_player/video_player.dart';

class MentalHealthVideo extends StatelessWidget {
  final String videoUrl;
  const MentalHealthVideo({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: VideoPlayer(url: videoUrl),
      ),
    );
  }
}
