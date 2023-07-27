import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/ui/screens/messages/blocs/record_audio_bloc/record_audio_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_messages_bloc/sb_messages_bloc.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/messages_models.dart';

typedef RecordCallback = void Function(String);

class RecordIconButton extends StatefulWidget {
  const RecordIconButton({
    super.key,
    required this.scrollController,
  });
  final ScrollController scrollController;

  @override
  State<RecordIconButton> createState() => _RecordIconButtonState();
}

class _RecordIconButtonState extends State<RecordIconButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onLongPressStart: (details) {
          RecordAudioBloc.bloc(context).add(const StartRecordingAudio());
          setState(() {});
        },
        onLongPressEnd: (details) {
          RecordAudioBloc.bloc(context).add(const StopRecordingAudio());
          scrollToBottom();
        },
        onLongPressCancel: () {
          RecordAudioBloc.bloc(context).add(const StopRecordingAudio());
          scrollToBottom();
        },
        onTap: () {
          RecordAudioBloc.bloc(context).add(const StopRecordingAudio());
          scrollToBottom();
        },
        child: BlocListener<RecordAudioBloc, RecordAudioState>(
          listener: (context, state) {
            if (state is RecordedFilePathState) {
              if (state.path != null) {
                _recordingFinished(state.path!);
              }
            }
          },
          child: IconButton(
            onPressed: null,
            icon: SvgPicture.asset(AssPath.microphoneIcon),
          ),
        ),
      ),
    );
  }

  scrollToBottom() {
    if (widget.scrollController.hasClients) {
      widget.scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _recordingFinished(String path) {
    File file = File(path);
    SBMessagesBloc.bloc(context)
        .add(SendFileMessageEvent(file, CustomMessageType.audio));
  }
}
