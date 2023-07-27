part of 'internet_connection_bloc.dart';

class InternetConnectionState extends Equatable {
  final bool isConnected;
  // final bool isInitApp;
  const InternetConnectionState({
    // required this.isInitApp,
    required this.isConnected,
  });
  @override
  List<Object?> get props => [isConnected];
}
