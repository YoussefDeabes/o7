part of 'sb_messages_bloc.dart';

abstract class SBMessagesEvent extends Equatable {
  const SBMessagesEvent();

  @override
  List<Object> get props => [];
}

class UpdateGroupChannelSBMessagesEvent extends SBMessagesEvent {
  final GroupChannel groupChannel;
  const UpdateGroupChannelSBMessagesEvent(this.groupChannel);
  @override
  List<Object> get props => [];
}

class SendMessageEvent extends SBMessagesEvent {
  final String message;
  final int? parentMessageId;
  const SendMessageEvent(this.message, {this.parentMessageId});

  @override
  List<Object> get props => [];
}

class SendFileMessageEvent extends SBMessagesEvent {
  final File file;
  final CustomMessageType customMessageType;
  final int? parentMessageId;
  const SendFileMessageEvent(
    this.file,
    this.customMessageType, {
    this.parentMessageId,
  });

  @override
  List<Object> get props => [];
}

class LoadAllPreviousMessagesEvent extends SBMessagesEvent {
  final LoadMessagesParams loadMessagesParams;
  const LoadAllPreviousMessagesEvent({
    required this.loadMessagesParams,
  });

  @override
  List<Object> get props => [];
}

class LoadMoreMessagesEvent extends SBMessagesEvent {
  final LoadMessagesParams loadMessagesParams;

  const LoadMoreMessagesEvent({required this.loadMessagesParams});

  @override
  List<Object> get props => [];
}

class UpdateLoadedMessagesStateEvent extends SBMessagesEvent {
  const UpdateLoadedMessagesStateEvent();

  @override
  List<Object> get props => [];
}
