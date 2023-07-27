import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/custom_message.dart';

part 'reply_message_event.dart';
part 'reply_message_state.dart';

class ReplyMessageBloc extends Bloc<ReplyMessageEvent, ReplyMessageState> {
  ReplyMessageBloc() : super(const ReplyMessageState(null)) {
    on<AddReplyMessageEvent>(_onAddReplyMessageEvent);
    on<RemoveReplyMessageEvent>(_onRemoveReplyMessageEvent);
  }

  static ReplyMessageBloc bloc(BuildContext context) =>
      context.read<ReplyMessageBloc>();

  _onAddReplyMessageEvent(AddReplyMessageEvent event, emit) {
    emit(ReplyMessageState(event.customMessage));
  }

  _onRemoveReplyMessageEvent(RemoveReplyMessageEvent event, emit) {
    emit(const ReplyMessageState(null));
  }
}
