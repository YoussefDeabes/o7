part of 'un_read_messages_count_bloc.dart';

abstract class UnReadMessagesCountEvent extends Equatable {
  const UnReadMessagesCountEvent();

  @override
  List<Object> get props => [];
}

class GetUnReadMessagesCountEvent extends UnReadMessagesCountEvent {
  final int numberOfUnReadMessages;
  const GetUnReadMessagesCountEvent(this.numberOfUnReadMessages);

  @override
  List<Object> get props => [numberOfUnReadMessages];
}

class EnableUnReadMessagesCountListenerEvent extends UnReadMessagesCountEvent {
  const EnableUnReadMessagesCountListenerEvent();
}
