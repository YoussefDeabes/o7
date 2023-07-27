part of 'home_main_logged_in_notification_bloc.dart';

abstract class HomeMainLoggedInNotificationState extends Equatable {
  const HomeMainLoggedInNotificationState();

  @override
  List<Object?> get props => [];
}

class HomeMainLoggedInNotificationInitial
    extends HomeMainLoggedInNotificationState {}

class LoadingHomeMainLoggedInNotificationState
    extends HomeMainLoggedInNotificationState {
  const LoadingHomeMainLoggedInNotificationState();
}

class LoadedHomeMainLoggedInNotificationState
    extends HomeMainLoggedInNotificationState {
  final int unreadNotificationsCount;
  const LoadedHomeMainLoggedInNotificationState(
      {required this.unreadNotificationsCount});
}

class NoHomeMainLoggedInNotificationState
    extends HomeMainLoggedInNotificationState {
  const NoHomeMainLoggedInNotificationState();
}

class ExceptionHomeMainLoggedInNotificationState
    extends HomeMainLoggedInNotificationState {
  final String exception;

  const ExceptionHomeMainLoggedInNotificationState(this.exception);
}
