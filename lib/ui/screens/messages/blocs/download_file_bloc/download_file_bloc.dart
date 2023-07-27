import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:permission_handler/permission_handler.dart';

part 'download_file_event.dart';
part 'download_file_state.dart';

class DownloadFileBloc extends Bloc<DownloadFileEvent, DownloadFileState> {
  static Directory? directory;
  CancelToken? cancelToken;
  DownloadFileBloc() : super(const DownloadFileInitial()) {
    on<StartDownloadFileEvent>(_onStartDownloadFileEvent);
    on<CancelDownloadFileEvent>(_onCancelDownloadFileEvent);
  }
  static DownloadFileBloc bloc(BuildContext context) =>
      context.read<DownloadFileBloc>();

  FutureOr<void> _onStartDownloadFileEvent(
    StartDownloadFileEvent event,
    Emitter<DownloadFileState> emit,
  ) async {
    try {
      String fileSavePath = await _getPath(event.fileName);
      await Dio().download(
        event.url,
        fileSavePath,
        cancelToken: cancelToken,
        onReceiveProgress: (int received, int total) {
          if (total != -1) {
            emit(DownloadingPercentage((received / total * 100).round()));
          }
        },
      );

      File file = File(fileSavePath);
      cancelToken = null;
      emit(DownloadCompleted(file));
    } catch (e) {
      debugPrint("$e");
      emit(const DownloadExceptionError());
    }
  }

  FutureOr<void> _onCancelDownloadFileEvent(
    CancelDownloadFileEvent event,
    Emitter<DownloadFileState> emit,
  ) {
    cancelToken?.cancel();
    cancelToken == null;
    emit(const DownloadCanceled());
  }

  Future<String> _getPath(String fileName) async {
    if (Platform.isAndroid) {
      if (await _requestPermission(Permission.storage)) {
        // return _saveFileOnAndroidPermanently(fileName);
        return _saveFileOnAndroidOrIosTemporary(fileName);
      } else {
        throw Exception("Permission Denied");
      }
    } else {
      //! IOS
      if (await _requestPermission(Permission.storage)) {
        return _saveFileOnAndroidOrIosTemporary(fileName);
      } else {
        throw Exception("Permission Denied");
      }
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

  Future<String> _saveFileOnAndroidPermanently(String fileName) async {
    directory = await path.getExternalStorageDirectory();
    String folderPath = "";
    if (directory != null) {
      List<String> paths = directory!.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          folderPath += "/$folder";
        } else {
          break;
        }
      }
      folderPath = "$folderPath/O7 Therapy/messages/documents";
      Directory savePathDirectory = Directory(folderPath);
      bool isExisted = await savePathDirectory.exists();
      if (!isExisted) {
        await savePathDirectory.create(recursive: true);
      }

      String fileSavePath = "${savePathDirectory.path}/$fileName";
      debugPrint("fileSavePath: $fileSavePath");
      return fileSavePath;
    }
    throw Exception("Oops.. Something went wrong!");
  }

  Future<String> _saveFileOnAndroidOrIosTemporary(String fileName) async {
    directory = await path.getTemporaryDirectory();

    if (directory != null) {
      String fileCachePath = "${directory!.path}/$fileName";
      debugPrint("fileCachePath: $fileCachePath");
      return fileCachePath;
    }
    throw Exception("Oops.. Something went wrong!");
  }
}
