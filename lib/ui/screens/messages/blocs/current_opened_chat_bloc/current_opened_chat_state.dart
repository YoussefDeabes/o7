part of 'current_opened_chat_bloc.dart';

class CurrentOpenedChatState extends Equatable {
  final String? currentOpenChannelUrl;
  const CurrentOpenedChatState([this.currentOpenChannelUrl]);

  @override
  List<Object?> get props => [currentOpenChannelUrl];
}
