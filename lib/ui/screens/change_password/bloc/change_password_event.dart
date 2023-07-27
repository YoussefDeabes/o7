part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordEvent {
  const ChangePasswordEvent();
}

class ChangePasswordInitialEvent extends ChangePasswordEvent {}

/// fire this event when the user clicked on the save button
class ChangePasswordApiEvent extends ChangePasswordEvent {
  final ChangePasswordSendModel changePasswordSendModel;

  const ChangePasswordApiEvent(this.changePasswordSendModel);
}
