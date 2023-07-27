part of 'download_file_bloc.dart';

abstract class DownloadFileEvent extends Equatable {
  const DownloadFileEvent();

  @override
  List<Object> get props => [];
}

class StartDownloadFileEvent extends DownloadFileEvent {
  final String url;
  final String fileName;
  const StartDownloadFileEvent({required this.url, required this.fileName});

  @override
  List<Object> get props => [];
}

class CancelDownloadFileEvent extends DownloadFileEvent {
  final String url;
  const CancelDownloadFileEvent(this.url);

  @override
  List<Object> get props => [];
}
