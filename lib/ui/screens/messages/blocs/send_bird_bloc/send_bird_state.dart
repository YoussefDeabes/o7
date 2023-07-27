part of 'send_bird_bloc.dart';

abstract class SendBirdState extends Equatable {
  const SendBirdState();

  @override
  List<Object> get props => [];
}

class LoadingSendBirdState extends SendBirdState {
  const LoadingSendBirdState();
}

class SuccessConnectedSendBirdState extends SendBirdState {
  const SuccessConnectedSendBirdState();
}

class ExceptionSendBirdState extends SendBirdState {
  const ExceptionSendBirdState({String? message})
      : msg = message ?? "Oops.. Something Went Wrong";
  final String msg;

  @override
  List<Object> get props => [msg];
}
