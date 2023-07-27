import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'current_opened_chat_event.dart';
part 'current_opened_chat_state.dart';

class CurrentOpenedChatBloc
    extends Bloc<CurrentOpenedChatEvent, CurrentOpenedChatState> {
  CurrentOpenedChatBloc() : super(const CurrentOpenedChatState()) {
    on<OpenChatEvent>(_onOpenChatEvent);
    on<CloseChatEvent>(_onCloseChatEvent);
  }

  static CurrentOpenedChatBloc bloc(BuildContext context) =>
      context.read<CurrentOpenedChatBloc>();

  FutureOr<void> _onOpenChatEvent(
    OpenChatEvent event,
    Emitter<CurrentOpenedChatState> emit,
  ) {
    emit(CurrentOpenedChatState(event.currentOpenChannelUrl));
  }

  FutureOr<void> _onCloseChatEvent(
    CloseChatEvent event,
    Emitter<CurrentOpenedChatState> emit,
  ) {
    emit(const CurrentOpenedChatState(null));
  }
}
