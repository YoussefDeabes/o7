part of 'send_bird_bloc.dart';

abstract class SendBirdEvent extends Equatable {
  const SendBirdEvent();

  @override
  List<Object> get props => [];
}

/// connect send bird while the main home screen opens
class ConnectSendBirdEvent extends SendBirdEvent {
  const ConnectSendBirdEvent();

  @override
  List<Object> get props => [];
}
