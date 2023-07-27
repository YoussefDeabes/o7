import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/api/models/notifications/unread_notifications_count/unread_notifications_count_model.dart';
import 'package:o7therapy/api/notifications_api_manager.dart';

import '../../../../../api/errors/network_exceptions.dart';

part 'home_main_logged_in_notification_event.dart';

part 'home_main_logged_in_notification_state.dart';

class HomeMainLoggedInNotificationBloc extends Bloc<
    HomeMainLoggedInNotificationEvent, HomeMainLoggedInNotificationState> {
  HomeMainLoggedInNotificationBloc()
      : super(HomeMainLoggedInNotificationInitial()) {
    on<GetUnreadNotificationsCountEvent>(_onGetUnreadNotificationsCountEvent);
  }

  static HomeMainLoggedInNotificationBloc bloc(BuildContext context) =>
      context.read<HomeMainLoggedInNotificationBloc>();

  _onGetUnreadNotificationsCountEvent(
      GetUnreadNotificationsCountEvent event, emit) async {
    emit(const LoadingHomeMainLoggedInNotificationState());
    late final HomeMainLoggedInNotificationState state;
    await NotificationsApiManager.getUnreadNotificationsCount(
      success: (UnreadNotificationCountModel wrapper) {
        if (wrapper.data == 0) {
          state = const NoHomeMainLoggedInNotificationState();
        } else {
          FlutterAppBadger.updateBadgeCount(wrapper.data!);
          state = LoadedHomeMainLoggedInNotificationState(
              unreadNotificationsCount: wrapper.data!);
        }
      },
      fail: (NetworkExceptions unreadNotificationsCount) {
        state = ExceptionHomeMainLoggedInNotificationState(
            unreadNotificationsCount.errorMsg ?? "");
      },
    );
    emit(state);
  }
}
