part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class LoadingNotificationsState extends NotificationsState {
  const LoadingNotificationsState();
}

class LoadedNotificationsState extends NotificationsState {
  final List<NotificationModel> allNotifications;
  const LoadedNotificationsState({required this.allNotifications});

  @override
  List<Object> get props => [allNotifications];
}

class EmptyNotificationsState extends NotificationsState {
  const EmptyNotificationsState();
}

class ExceptionNotificationsState extends NotificationsState {
  final String msg;
  const ExceptionNotificationsState({required this.msg});

  @override
  List<Object> get props => [msg];
}

class LoadingFileState extends NotificationsState {
  final List<NotificationModel> allNotifications;
  const LoadingFileState({required this.allNotifications});
}
class LoadedFileState extends NotificationsState {
  final List<NotificationModel> allNotifications;
  const LoadedFileState({required this.allNotifications});
}
