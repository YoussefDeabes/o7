part of 'reply_message_bloc.dart';

class ReplyMessageState extends Equatable {
  final CustomMessage? customMessage;
  const ReplyMessageState(this.customMessage);

  @override
  List<Object?> get props => [customMessage];
}
