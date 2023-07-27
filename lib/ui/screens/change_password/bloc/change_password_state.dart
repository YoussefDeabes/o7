part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordState {
  const ChangePasswordState();
}

class ChangePasswordInitial extends ChangePasswordState {}

class Loading extends ChangePasswordState {
  const Loading();
}

class NetworkError extends ChangePasswordState {
  final String message;

  const NetworkError(this.message);
}

class ErrorState extends ChangePasswordState {
  final String message;

  const ErrorState(this.message);
}

/// password is empty
class PasswordEmptyError extends ChangePasswordState {
  const PasswordEmptyError();
}

/// password is correct
class PasswordFormatNotCorrect extends ChangePasswordState {
  const PasswordFormatNotCorrect();
}

/// success changed password --> will pop screen
class SuccessChangePassword extends ChangePasswordState {
  final ChangePassword changePassword;

  const SuccessChangePassword(this.changePassword);
}
