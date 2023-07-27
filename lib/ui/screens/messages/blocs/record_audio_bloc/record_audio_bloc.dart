import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

part 'record_audio_event.dart';
part 'record_audio_state.dart';

class RecordAudioBloc extends Bloc<RecordAudioEvent, RecordAudioState> {
  RecordAudioBloc() : super(const RecordAudioInitial()) {
    on<StartRecordingAudio>(_onStartRecordingAudio);
    on<StopRecordingAudio>(_onStopRecordingAudio);
  }

  static RecordAudioBloc bloc(BuildContext context) =>
      context.read<RecordAudioBloc>();
  final _audioRecorder = Record();

  _onStartRecordingAudio(StartRecordingAudio event, emit) async {
    try {
      if (await _requestPermission(Permission.microphone)) {
        if (await _audioRecorder.hasPermission()) {
          await _audioRecorder.start();
          bool isRecording = await _audioRecorder.isRecording();
          emit(RecordingState(isRecording: isRecording));
        } else {
          emit(const RecordingState(isRecording: false));
        }
      } else {
        emit(const RecordingState(isRecording: false));
      }
    } catch (e) {
      emit(const RecordingState(isRecording: false));
    }
  }

  _onStopRecordingAudio(StopRecordingAudio event, emit) async {
    try {
      emit(const RecordingState(isRecording: false));
      final String? path = await _audioRecorder.stop();
      log(path ?? "path");
      emit(RecordedFilePathState(path: path));
    } catch (e) {
      emit(const RecordingState(isRecording: false));
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
