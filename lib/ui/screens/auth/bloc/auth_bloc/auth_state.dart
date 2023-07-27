part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class InitialState extends AuthState {}

class LoadingAuthState extends AuthState {
  const LoadingAuthState();
}

class NetworkError extends AuthState {
  final String message;

  const NetworkError(this.message);
}

class ErrorState extends AuthState {
  final String message;

  const ErrorState(this.message);
}

class FieldEmptyError extends AuthState {
  const FieldEmptyError();
}

/// email it self not well formatted mail
class EmailFormattedError extends AuthState {
  const EmailFormattedError();
}

/// email is empty
class EmailEmptyError extends AuthState {
  const EmailEmptyError();
}

/// password not matched the validations
class PasswordFormattedError extends AuthState {
  const PasswordFormattedError();
}

/// password is empty
class PasswordEmptyError extends AuthState {
  const PasswordEmptyError();
}

/// email is correct
class EmailFormatCorrect extends AuthState {
  const EmailFormatCorrect();
}

/// password is correct
class PasswordFormatCorrect extends AuthState {}

/// email first login --> will open verify code then set password
class FirstLogin extends AuthState {
  final String mail;

  const FirstLogin(this.mail);
}

/// success login --> will open home screen
class SuccessLogin extends AuthState {
  final LoginWrapper loginWrapper;

  const SuccessLogin(this.loginWrapper);
}

/// success login --> google sign in
class SuccessGoogleLogin extends AuthState {
  const SuccessGoogleLogin();
}

/// success SignUP --> will open Verification Code screen
class SuccessSignUP extends AuthState {
  final SignUpWrapper signUpWrapper;

  const SuccessSignUP(this.signUpWrapper);
}

/// will open forget password screen
class OpenForgetPassword extends AuthState {
  const OpenForgetPassword();
}

class SignUpStepsExceptionState extends AuthState {
  final SignUpCustomExceptions exception;
  const SignUpStepsExceptionState(this.exception);
}

class SignupStepChangedState extends AuthState {
  const SignupStepChangedState();
}

class SigupUpdateStepIndex extends AuthState {
  final int newStepIndex;
  final int currentStepIndex;
  const SigupUpdateStepIndex({
    required this.newStepIndex,
    required this.currentStepIndex,
  });
}

class ClientProfile extends AuthState {
  final UserProfileInfo profileInfo;
  const ClientProfile({
    required this.profileInfo,
  });
}

class SuccessCodeResentAuthState extends AuthState {
  const SuccessCodeResentAuthState();
}

class VerifiedEmailAuthState extends AuthState {
  final bool isVerified;
  final CheckVerifiedEmailData? date;
  final String userId;
  const VerifiedEmailAuthState({
    required this.userId,
    required this.date,
    required this.isVerified,
  });
  @override
  List<Object> get props => [isVerified];
}

class VerifiedEmailAfterSignupScreenAuthState extends AuthState {
  final bool isVerified;
  final CheckVerifiedEmailData? date;
  final String userId;
  const VerifiedEmailAfterSignupScreenAuthState({
    required this.userId,
    required this.date,
    required this.isVerified,
  });
  @override
  List<Object> get props => [isVerified];
}
class SuccessVerifiedAuthState extends AuthState {
  final String? companyName;
  final bool? isCorporate;

  const SuccessVerifiedAuthState(this.companyName,this.isCorporate);
}
