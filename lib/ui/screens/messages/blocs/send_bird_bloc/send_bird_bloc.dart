import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_bloc/send_bird_repo.dart';

part 'send_bird_event.dart';
part 'send_bird_state.dart';

class SendBirdBloc extends Bloc<SendBirdEvent, SendBirdState> {
  final BaseSendBirdRepository _repo;
  SendBirdBloc(this._repo) : super(const LoadingSendBirdState()) {
    /// init sendBird
    _repo.initSendBird();

    on<ConnectSendBirdEvent>(_onConnectSendBirdEvent);
  }
  static SendBirdBloc bloc(BuildContext context) =>
      context.read<SendBirdBloc>();

  _onConnectSendBirdEvent(ConnectSendBirdEvent event, emit) async {
    emit(const LoadingSendBirdState());
    emit(await _repo.connect());
  }
}
