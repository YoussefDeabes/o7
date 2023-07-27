part of 'home_main_logged_in_notification_bloc.dart';

abstract class HomeMainLoggedInNotificationEvent extends Equatable {
  const HomeMainLoggedInNotificationEvent();

  @override
  List<Object?> get props => [];
}

class GetUnreadNotificationsCountEvent
    extends HomeMainLoggedInNotificationEvent {
  const GetUnreadNotificationsCountEvent();
}
