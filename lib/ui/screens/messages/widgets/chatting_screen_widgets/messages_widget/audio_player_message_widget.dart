import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/messages_models.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/messages_widget/message_time_and_status.dart';

class AudioPlayerMessageWidget extends StatefulWidget {
  const AudioPlayerMessageWidget({
    Key? key,
    required this.audioMessage,
    required this.messageTimeAndStatusWidget,
  }) : super(key: key);

  final MessageTimeAndStatus messageTimeAndStatusWidget;
  final AudioMessage audioMessage;

  @override
  AudioPlayerMessageWidgetState createState() =>
      AudioPlayerMessageWidgetState();
}

class AudioPlayerMessageWidgetState extends State<AudioPlayerMessageWidget>
    with WidgetsBindingObserver {
  final _audioPlayer = AudioPlayer();
  late StreamSubscription<PlayerState> _playerStateChangedSubscription;

  late Future<Duration?> futureDuration;
  late final AudioSource audioSource;

  @override
  void initState() {
    super.initState();
    audioSource = widget.audioMessage.audioSource;

    _playerStateChangedSubscription =
        _audioPlayer.playerStateStream.listen(playerStateListener);

    futureDuration = _audioPlayer.setAudioSource(audioSource);
  }

  void playerStateListener(PlayerState state) async {
    if (state.processingState == ProcessingState.completed) {
      await reset();
    }
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  ///As recording/playing media is resource heavy task,
  ///you don't want any resources to stay allocated even after
  ///app is killed. So it is recommended that if app is directly killed then
  ///this still will be called and we can free up resouces.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _playerStateChangedSubscription.cancel();
      _audioPlayer.dispose();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Duration?>(
      future: futureDuration,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _controlButtons(),
                    _slider(snapshot.data),
                  ],
                ),
                widget.messageTimeAndStatusWidget
              ],
            ),
          );
        }
        return const AudioLoadingMessage();
      },
    );
  }

  Widget _controlButtons() {
    return StreamBuilder<bool>(
      stream: _audioPlayer.playingStream,
      builder: (context, _) {
        final color =
            _audioPlayer.playerState.playing ? Colors.red : Colors.white;
        final icon =
            _audioPlayer.playerState.playing ? Icons.pause : Icons.play_arrow;
        return Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: GestureDetector(
            onTap: () {
              if (_audioPlayer.playerState.playing) {
                pause();
              } else {
                play();
              }
            },
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(icon, color: color, size: 30),
            ),
          ),
        );
      },
    );
  }

  Widget _slider(Duration? duration) {
    return StreamBuilder<Duration>(
      stream: _audioPlayer.positionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && duration != null) {
          return CupertinoSlider(
            value: snapshot.data!.inMicroseconds / duration.inMicroseconds,
            onChanged: (val) {
              _audioPlayer.seek(duration * val);
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> play() {
    return _audioPlayer.play();
  }

  Future<void> pause() {
    return _audioPlayer.pause();
  }

  Future<void> reset() async {
    await _audioPlayer.stop();
    return _audioPlayer.seek(const Duration(milliseconds: 0));
  }
}

class AudioLoadingMessage extends StatelessWidget {
  const AudioLoadingMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 5,
            width: MediaQuery.of(context).size.width * 0.6,
            child: const LinearProgressIndicator(backgroundColor: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child:
                CircleAvatar(child: SvgPicture.asset(AssPath.microphoneIcon)),
          ),
        ],
      ),
    );
  }
}
