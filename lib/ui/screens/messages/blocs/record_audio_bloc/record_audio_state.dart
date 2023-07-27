part of 'record_audio_bloc.dart';

abstract class RecordAudioState extends Equatable {
  const RecordAudioState();

  @override
  List<Object> get props => [];
}

class RecordAudioInitial extends RecordAudioState {
  const RecordAudioInitial();
}

class RecordingState extends RecordAudioState {
  final bool isRecording;
  const RecordingState({required this.isRecording});
}

class RecordedFilePathState extends RecordAudioState {
  final String? path;
  const RecordedFilePathState({required this.path});
}
