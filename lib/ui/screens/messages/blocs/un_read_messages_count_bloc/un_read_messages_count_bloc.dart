import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/api/send_bird_manager.dart';

part 'un_read_messages_count_event.dart';
part 'un_read_messages_count_state.dart';

class UnReadMessagesCountBloc
    extends Bloc<UnReadMessagesCountEvent, UnReadMessagesCountState> {
  UnReadMessagesCountBloc() : super(const NoNewUnReadMessagesState()) {
    on<GetUnReadMessagesCountEvent>(_onUnReadMessagesCountEvent);
    on<EnableUnReadMessagesCountListenerEvent>(
        _onEnableUnReadMessagesCountListenerEvent);
  }

  static UnReadMessagesCountBloc bloc(BuildContext context) =>
      context.read<UnReadMessagesCountBloc>();

  /// listener to the sendBird when receive new message
  /// after listen for a new message will get the total messages unRead number
  /// by add(_UnReadMessagesCountEvent) to bloc
  _onEnableUnReadMessagesCountListenerEvent(event, emit) async {
    final int totalUnreadMessageCount =
        await SendBirdManager.sendBirdSdk.getTotalUnreadMessageCount();
    add(GetUnReadMessagesCountEvent(totalUnreadMessageCount));
    SendBirdManager.sendBirdSdk.totalUnreadMessageCountStream!.listen((event) {
      add(GetUnReadMessagesCountEvent(event));
    });
  }

  _onUnReadMessagesCountEvent(GetUnReadMessagesCountEvent event, emit) {
    if (event.numberOfUnReadMessages > 0) {
      emit(NewUnReadMessagesState(event.numberOfUnReadMessages));
    } else {
      emit(const NoNewUnReadMessagesState());
    }
  }
}
