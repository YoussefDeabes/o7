part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

///////////////////////////////////////////////////////////
//////////////////// Login Screen Events //////////////////
///////////////////////////////////////////////////////////

/// fire this event when the user clicked on the login button
class LoginApiEvent extends AuthEvent {
  final LoginSendModel loginSendModel;

  const LoginApiEvent(this.loginSendModel);
}
class LoginAfterSignupApiEvent extends AuthEvent {
  final LoginSendModel loginSendModel;

  const LoginAfterSignupApiEvent(this.loginSendModel);
}

/// fire this event when the user clicked on the google login button
class GoogleLoginApiEvent extends AuthEvent {
  const GoogleLoginApiEvent();
}

/// fire this event when the user clicked on the Signup button
class SignupApiEvent extends AuthEvent {
  final String? email;
  final String? password;
  final String? confirmPassword;
  // final String? phoneNumber;
  const SignupApiEvent({
    // this.phoneNumber,
    this.email,
    this.password,
    this.confirmPassword,
  });
}

class OpenForgetPasswordEvent extends AuthEvent {
  const OpenForgetPasswordEvent();
}

// fire this event when email field has change to validate
class ValidateEmailEvent extends AuthEvent {
  final String username;

  const ValidateEmailEvent(this.username);
}

// fire this event when password field has change to validate
class ValidatePasswordEvent extends AuthEvent {
  final String password;

  const ValidatePasswordEvent(this.password);
}

/// fire this event when the user try to move to another page
class CheckStepEvent extends AuthEvent {
  final int comingStepNumber;
  final int currentStepNumber;

  const CheckStepEvent({
    required this.comingStepNumber,
    required this.currentStepNumber,
  });
}

/// fire this event only when the user moves to different page
class ChangeStepEvent extends AuthEvent {
  // final int comingStepNumber;
  final int currentStepNumber;

  const ChangeStepEvent({
    // required this.comingStepNumber,
    required this.currentStepNumber,
  });
}

/// fire this event while the user writing his name
class NickNameChangedEvent extends AuthEvent {
  final String name;
  const NickNameChangedEvent(this.name);
}

/// fire this event while the user choose his Gender
class GenderChangedEvent extends AuthEvent {
  final Gender gender;
  const GenderChangedEvent(this.gender);
}

/// fire this event while the user choose his Age
class BirthDateChangedEvent extends AuthEvent {
  final DateTime birthDate;
  const BirthDateChangedEvent(this.birthDate);
}

/// fire this event while the user choosing his Goals
class GoalsChangedEvent extends AuthEvent {
  final List<Goals> goals;
  const GoalsChangedEvent(this.goals);
}

class VerifyClientEmailEvent extends AuthEvent {
  final String code;
  final String userId;
  const VerifyClientEmailEvent({
    required this.code,
    required this.userId,
  });

  @override
  List<Object?> get props => [code, userId];
}

class ResendVerificationCodeAuthEvent extends AuthEvent {
  final String userId;
  const ResendVerificationCodeAuthEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

class _CheckIsAccountVerifiedEvent extends AuthEvent {
  final String userId;
  const _CheckIsAccountVerifiedEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

class _CheckIsAccountVerifiedAfterSignupEvent extends AuthEvent {
  final String userId;
  const _CheckIsAccountVerifiedAfterSignupEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

class _GetProfileAuthEvent extends AuthEvent {
  const _GetProfileAuthEvent();

  @override
  List<Object?> get props => [];
}
