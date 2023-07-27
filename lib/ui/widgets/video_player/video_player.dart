import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/ui/screen_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, required this.url, this.autoPlay = false});

  final String url;
  final bool autoPlay;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer>
    with AutomaticKeepAliveClientMixin {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url) ?? "",
      flags: YoutubePlayerFlags(
        mute: false,
        controlsVisibleAtStart: true,
        autoPlay: widget.autoPlay,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        exitFullScreen();
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      },
      onEnterFullScreen: () {
        // SystemChrome.setPreferredOrientations(
        //     [DeviceOrientation.landscapeLeft]);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        // aspectRatio: MediaQuery.of(context).devicePixelRatio,
        progressIndicatorColor: ConstColors.app,
        liveUIColor: ConstColors.app,
        bottomActions: [
          const SizedBox(width: 10.0),
          CurrentPosition(),
          const SizedBox(width: 10.0),
          ProgressBar(isExpanded: true),
          const SizedBox(width: 10.0),
          RemainingDuration(),
          FullScreenButton(),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (context, player) => player,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
