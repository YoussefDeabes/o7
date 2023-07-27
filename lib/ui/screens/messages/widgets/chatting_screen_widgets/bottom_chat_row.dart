import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/messages/blocs/record_audio_bloc/record_audio_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/reply_message_bloc/reply_message_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_messages_bloc/sb_messages_bloc.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/messages_models.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/attachment_modal_widget.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/message_reply_preview.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/wave.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/record_icon_button.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/send_icon_button.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class BottomChatRow extends StatefulWidget {
  final ScrollController scrollController;

  const BottomChatRow({super.key, required this.scrollController});

  @override
  State<BottomChatRow> createState() => _BottomChatRowState();
}

class _BottomChatRowState extends State<BottomChatRow> with Translator {
  Duration _recordDuration = const Duration(seconds: 0);
  Timer? _timer;
  final TextEditingController textEditingController = TextEditingController();

  // bool _isTextFormEmpty = true;

  @override
  void initState() {
    _stop();
    textEditingController.addListener(_textEditingControllerListener);
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    return Column(
      children: [
        BlocBuilder<ReplyMessageBloc, ReplyMessageState>(
          builder: (context, state) {
            if (state.customMessage != null) {
              return MessageReplyPreview(customMessage: state.customMessage!);
            }
            return const SizedBox.shrink();
          },
        ),
        BlocBuilder<RecordAudioBloc, RecordAudioState>(
          builder: (context, state) {
            Widget showRow = _getTextFieldTypingRow();
            // log("$state  ");
            // if (state is RecordingState && state.isRecording) {
            //   showRow = _getRecordingRow();
            //   _start();
            // } else {
            //   showRow = _getTextFieldTypingRow();
            //   _stop();
            // }
            return Ink(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Row(
                  children: <Widget>[
                    showRow,
                    SendIconButton(
                      controller: textEditingController,
                      scrollController: widget.scrollController,
                    )
                    // _isTextFormEmpty
                    // ? RecordIconButton(
                    //     scrollController: widget.scrollController,
                    //   )
                    // : SendIconButton(
                    //     controller: textEditingController,
                    //     scrollController: widget.scrollController,
                    //   )
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

  void _getFile() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      barrierColor: Colors.transparent,
      builder: (context) {
        return AttachmentModalWidget(sendFileMessage: _sendFileMessage);
      },
    );
  }

  void _sendFileMessage(File file, CustomMessageType type) {
    final int? parentMessageId =
        ReplyMessageBloc.bloc(context).state.customMessage?.messageId;
    SBMessagesBloc.bloc(context).add(SendFileMessageEvent(
      file,
      type,
      parentMessageId: parentMessageId,
    ));
  }

  _textEditingControllerListener() {
    // setState(() => _isTextFormEmpty = textEditingController.text.isEmpty);
  }

  Widget _getTextFieldTypingRow() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 2.0),
            //   child: IconButton(
            //     visualDensity: const VisualDensity(
            //         horizontal: VisualDensity.minimumDensity,
            //         vertical: VisualDensity.minimumDensity),
            //     onPressed: _getFile,
            //     icon: SvgPicture.asset(AssPath.paperClipIcon),
            //   ),
            // ),
            Expanded(
              child: TextField(
                maxLines: 5,
                minLines: 1,
                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  filled: true,
                  hintText: translate(LangKeys.typeMessage),
                  fillColor: ConstColors.disabled,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getRecordingRow() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white38,
                    width: 2.0,
                  )),
              height: 20,
              width: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                "$minutes:$seconds",
                style: const TextStyle(
                  fontSize: 20,
                  color: ConstColors.accentColor,
                ),
              ),
            ),
            const SizedBox(width: 40),
            const SizedBox(
              width: 100,
              child: WaveVisualizer(
                columnWidth: 6,
                isPaused: false,
                isBarVisible: false,
                color: ConstColors.app,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String strDigits(int n) => n.toString().padLeft(2, '0');

  String get minutes => strDigits(_recordDuration.inMinutes.remainder(60));

  String get seconds => strDigits(_recordDuration.inSeconds.remainder(60));

  /// init timer and start to count down
  void _start() {
    if (_recordDuration.inSeconds > 0) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        final seconds = _recordDuration.inSeconds + 1;
        _recordDuration = Duration(seconds: seconds);
      });
    });
  }

  // To Stop the timer from counting
  void _stop() {
    _recordDuration = const Duration(seconds: 0);
    _timer?.cancel();
  }
}
