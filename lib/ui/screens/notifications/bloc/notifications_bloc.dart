import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/notifications/notifications.dart';
import 'package:o7therapy/api/notifications_api_manager.dart';

part 'notifications_event.dart';

part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(const NotificationsInitial()) {
    on<GetNotifications>(_onGetNotifications);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<LoadingFileEvt>(_onLoadingFile);
    on<LoadedFileEvt>(_onLoadedFile);
  }

  static NotificationsBloc bloc(BuildContext context) =>
      context.read<NotificationsBloc>();

  _onGetNotifications(event, emit) async {
    // first show loading
    emit(const LoadingNotificationsState());
    late final NotificationsState state;
    await NotificationsApiManager.getNotifications(
      success: (NotificationsWrapper wrapper) {
        if (wrapper.data.isEmpty) {
          state = const EmptyNotificationsState();
        } else {
          state = LoadedNotificationsState(allNotifications: wrapper.data);
        }
      },
      fail: (NetworkExceptions detailsApiModel) {
        state =
            ExceptionNotificationsState(msg: detailsApiModel.errorMsg ?? "");
      },
    );
    emit(state);
  }

  _onMarkAllAsRead(event, emit) async {
    // first show loading
    emit(const LoadingNotificationsState());
    NotificationsState? state;
    await NotificationsApiManager.markAllAsRead(
      success: (NotificationsMarkAllAsReadWrapper wrapper) {},
      fail: (NetworkExceptions detailsApiModel) {
        state =
            ExceptionNotificationsState(msg: detailsApiModel.errorMsg ?? "");
      },
    );
    if (state == null) {
      add(const GetNotifications());
    } else {
      emit(state);
    }
  }

  _onLoadingFile(LoadingFileEvt event, emit) {
    emit(LoadingFileState(allNotifications: event.allNotifications));
  }

  _onLoadedFile(LoadedFileEvt event, emit) {
    emit(LoadedFileState(allNotifications: event.allNotifications));
  }
}
