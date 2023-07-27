part of 'record_audio_bloc.dart';

abstract class RecordAudioEvent extends Equatable {
  const RecordAudioEvent();

  @override
  List<Object> get props => [];
}

class StartRecordingAudio extends RecordAudioEvent {
  const StartRecordingAudio();
}

class StopRecordingAudio extends RecordAudioEvent {
  const StopRecordingAudio();
}
