part of 'sb_messages_bloc.dart';

abstract class SBMessagesState extends Equatable {
  const SBMessagesState();

  @override
  List<Object> get props => [];
}

class InitialSBMessagesState extends SBMessagesState {
  const InitialSBMessagesState();
}

class LoadingSBMessagesState extends SBMessagesState {
  const LoadingSBMessagesState();
}

class LoadedSBMessagesState extends SBMessagesState {
  const LoadedSBMessagesState({
    required this.chatMessages,
    required this.hasNext,
  });
  final List<CustomMessage> chatMessages;
  final bool hasNext;

  @override
  List<Object> get props => [chatMessages, hasNext, chatMessages.length];
}

class EmptyPreviousSBMessagesState extends SBMessagesState {
  const EmptyPreviousSBMessagesState();
  @override
  List<Object> get props => [];
}

class ExceptionSBMessagesState extends SBMessagesState {
  const ExceptionSBMessagesState({this.message});
  final String? message;
}
