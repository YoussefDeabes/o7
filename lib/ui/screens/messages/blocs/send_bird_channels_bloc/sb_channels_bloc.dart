import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_channels_bloc/sb_channels_repo.dart';
import 'package:o7therapy/ui/screens/messages/models/contact_item.dart';
import 'package:o7therapy/api/send_bird_manager.dart';
import 'package:o7therapy/ui/screens/messages/models/contact_item_mixin.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

part 'sb_channels_event.dart';
part 'sb_channels_state.dart';

class SBChannelsBloc extends Bloc<SBChannelsEvent, SBChannelsState>
    with ContactItemMixin {
  final BaseSBChannelsRepository _repo;
  SBChannelsBloc({required BaseSBChannelsRepository sbChannelsRepository})
      : _repo = sbChannelsRepository,
        super(const SBChannelsInitial()) {
    onChannelChanged();
    on<GetExistingSBChannelsEvent>(_onGetExistingChannelsSendBirdEvent);
    on<UpdateCurrentChannelListWithUpdatedGroupChannelEvent>(
        _onUpdateCurrentChannelList);
    on<GetMoreSBChannelsEvent>(_onGetMoreChannelsSendBirdEvent);
  }

  static SBChannelsBloc bloc(BuildContext context) =>
      context.read<SBChannelsBloc>();

  _onGetExistingChannelsSendBirdEvent(
    GetExistingSBChannelsEvent event,
    emit,
  ) async {
    emit(const LoadingSBChannelsState());
    emit(await _repo.getExistingChannels(reload: event.reload));
  }

  /// this event will used if there is an option of load more
  /// but it is not exist with this endpoint
  _onGetMoreChannelsSendBirdEvent(event, emit) async =>
      emit(await _repo.loadMoreChannels());

  _onUpdateCurrentChannelList(
    UpdateCurrentChannelListWithUpdatedGroupChannelEvent event,
    Emitter<SBChannelsState> emit,
  ) {
    if (state is LoadedExistingSBChannelsState) {
      LoadedExistingSBChannelsState loadedState =
          state as LoadedExistingSBChannelsState;

      /// remove old contact Item
      ContactItem oldContactItem =
          loadedState.chatList.removeAt(event.oldContactItemIndex);

      /// add new contact item with updated group channel in index 0;
      loadedState.chatList.insert(
        0,
        oldContactItem.copyWith(
          groupChannel: event.newGroupChannel,
          channelUrl: event.newGroupChannel.channelUrl,
          lastMessage: event.newGroupChannel.lastMessage?.message,
          lastMessageTime: getLastMessageCreatedAt(
              event.newGroupChannel.lastMessage?.createdAt),
          noOfUnreadMessage: event.newGroupChannel.unreadMessageCount,
        ),
      );

      /// then sort the list
      loadedState.chatList.sort(((a, b) {
        int aDate = a.lastMessageTime?.microsecondsSinceEpoch ?? 0;
        int bDate = b.lastMessageTime?.microsecondsSinceEpoch ?? 0;
        return bDate.compareTo(aDate);
      }));

      emit(const LoadingSBChannelsState());
      emit(LoadedExistingSBChannelsState(
        chatList: [...loadedState.chatList],
        hasNext: loadedState.hasNext,
      ));
    }
  }

  void onChannelChanged() {
    SendBirdManager.sendBirdSdk
        .channelChangedStream()
        .listen((BaseChannel newChannel) {
      if (newChannel is! GroupChannel) return;

      /// if the channel is not new then sort only
      /// else get the channels again
      if (state is LoadedExistingSBChannelsState) {
        LoadedExistingSBChannelsState loadedState =
            state as LoadedExistingSBChannelsState;
        int oldContactItemIndex = loadedState.chatList
            .indexWhere((item) => item.channelUrl == newChannel.channelUrl);
        if (oldContactItemIndex != -1) {
          add(UpdateCurrentChannelListWithUpdatedGroupChannelEvent(
              newGroupChannel: newChannel,
              oldContactItemIndex: oldContactItemIndex));
        } else {
          add(const GetExistingSBChannelsEvent());
        }
      }
    });
  }
}
