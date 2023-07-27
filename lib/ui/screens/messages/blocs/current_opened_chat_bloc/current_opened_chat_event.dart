part of 'current_opened_chat_bloc.dart';

abstract class CurrentOpenedChatEvent extends Equatable {
  const CurrentOpenedChatEvent();

  @override
  List<Object> get props => [];
}

class OpenChatEvent extends CurrentOpenedChatEvent {
  final String currentOpenChannelUrl;
  const OpenChatEvent(this.currentOpenChannelUrl);

  @override
  List<Object> get props => [currentOpenChannelUrl];
}

class CloseChatEvent extends CurrentOpenedChatEvent {
  const CloseChatEvent();

  @override
  List<Object> get props => [];
}
