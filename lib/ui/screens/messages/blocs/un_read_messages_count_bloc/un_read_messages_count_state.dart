part of 'un_read_messages_count_bloc.dart';

abstract class UnReadMessagesCountState extends Equatable {
  const UnReadMessagesCountState();

  @override
  List<Object> get props => [];
}

class NoNewUnReadMessagesState extends UnReadMessagesCountState {
  const NoNewUnReadMessagesState();
}

class NewUnReadMessagesState extends UnReadMessagesCountState {
  final int newUnReadMessagesNumber;
  const NewUnReadMessagesState(this.newUnReadMessagesNumber);
}
