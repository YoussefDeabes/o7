part of 'download_file_bloc.dart';

abstract class DownloadFileState extends Equatable {
  const DownloadFileState();

  @override
  List<Object> get props => [];
}

class DownloadFileInitial extends DownloadFileState {
  const DownloadFileInitial();
}

class DownloadingPercentage extends DownloadFileState {
  final int percentage;
  const DownloadingPercentage(this.percentage);

  @override
  List<Object> get props => [percentage];
}

class DownloadCanceled extends DownloadFileState {
  const DownloadCanceled();
}

class DownloadCompleted extends DownloadFileState {
  final File file;
  const DownloadCompleted(this.file);
}

class DownloadExceptionError extends DownloadFileState {
  const DownloadExceptionError();
}
