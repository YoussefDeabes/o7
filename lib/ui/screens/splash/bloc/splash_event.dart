part of 'splash_bloc.dart';

@immutable
abstract class SplashEvent {}

class CheckEnforceUpdate extends SplashEvent {
  final String version;

  CheckEnforceUpdate(this.version);
}
