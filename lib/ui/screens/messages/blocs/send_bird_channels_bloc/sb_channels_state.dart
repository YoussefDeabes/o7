part of 'sb_channels_bloc.dart';

abstract class SBChannelsState extends Equatable {
  const SBChannelsState();

  @override
  List<Object> get props => [];
}

class SBChannelsInitial extends SBChannelsState {
  const SBChannelsInitial();
}

class LoadingSBChannelsState extends SBChannelsState {
  const LoadingSBChannelsState();
}

class LoadedExistingSBChannelsState extends SBChannelsState {
  const LoadedExistingSBChannelsState({
    required this.chatList,
    required this.hasNext,
  });
  final List<ContactItem> chatList;
  final bool hasNext;

  @override
  List<Object> get props => [chatList];
}

class EmptySBChannelsListState extends SBChannelsState {
  const EmptySBChannelsListState();
  @override
  List<Object> get props => [];
}

class ExceptionSBChannelsState extends SBChannelsState {
  const ExceptionSBChannelsState({String? message})
      : msg = message ?? "Oops.. Something Went Wrong";
  final String msg;

  @override
  List<Object> get props => [msg];
}
