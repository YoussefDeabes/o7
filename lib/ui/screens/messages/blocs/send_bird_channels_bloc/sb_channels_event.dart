part of 'sb_channels_bloc.dart';

abstract class SBChannelsEvent extends Equatable {
  const SBChannelsEvent();

  @override
  List<Object> get props => [];
}

class GetExistingSBChannelsEvent extends SBChannelsEvent {
  final bool reload;
  const GetExistingSBChannelsEvent({this.reload = false});

  @override
  List<Object> get props => [];
}

class GetMoreSBChannelsEvent extends SBChannelsEvent {
  const GetMoreSBChannelsEvent();

  @override
  List<Object> get props => [];
}

class UpdateCurrentChannelListWithUpdatedGroupChannelEvent
    extends SBChannelsEvent {
  final int oldContactItemIndex;
  final GroupChannel newGroupChannel;
  const UpdateCurrentChannelListWithUpdatedGroupChannelEvent({
    required this.newGroupChannel,
    required this.oldContactItemIndex,
  });

  @override
  List<Object> get props => [];
}
