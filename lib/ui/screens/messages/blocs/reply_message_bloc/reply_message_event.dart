part of 'reply_message_bloc.dart';

abstract class ReplyMessageEvent extends Equatable {
  const ReplyMessageEvent();

  @override
  List<Object> get props => [];
}

class AddReplyMessageEvent extends ReplyMessageEvent {
  final CustomMessage customMessage;
  const AddReplyMessageEvent({required this.customMessage});

  @override
  List<Object> get props => [customMessage];
}

class RemoveReplyMessageEvent extends ReplyMessageEvent {
  const RemoveReplyMessageEvent();

  @override
  List<Object> get props => [];
}
