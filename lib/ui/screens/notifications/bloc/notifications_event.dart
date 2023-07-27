part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class GetNotifications extends NotificationsEvent {
  const GetNotifications();

  @override
  List<Object> get props => [];
}

class MarkAllAsRead extends NotificationsEvent {
  const MarkAllAsRead();
}

class LoadingFileEvt extends NotificationsEvent {
  final List<NotificationModel> allNotifications;
  const LoadingFileEvt({required this.allNotifications});
}

class LoadedFileEvt extends NotificationsEvent {
  final List<NotificationModel> allNotifications;
  const LoadedFileEvt({required this.allNotifications});
}
