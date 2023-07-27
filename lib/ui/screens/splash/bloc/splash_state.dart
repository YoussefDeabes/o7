part of 'splash_bloc.dart';

@immutable
abstract class SplashState {
  const SplashState();
}

class SplashInitial extends SplashState {}

class EnforceUpdateSuccess extends SplashState {
  final EnforceUpdate enforce;

  const EnforceUpdateSuccess(this.enforce);
}

class NetworkError extends SplashState {
  final String message;

  const NetworkError(this.message);
}

class ErrorState extends SplashState {
  final String message;

  const ErrorState(this.message);
}
