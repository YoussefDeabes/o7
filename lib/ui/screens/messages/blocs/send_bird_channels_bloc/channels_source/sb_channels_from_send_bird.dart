import 'package:o7therapy/ui/screens/messages/blocs/send_bird_channels_bloc/sb_channels_bloc.dart';
import 'package:o7therapy/api/send_bird_manager.dart';
import 'package:o7therapy/ui/screens/messages/models/contact_item.dart';
import 'package:o7therapy/ui/screens/messages/models/contact_item_builder_from_send_bird.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

/// get the channels from sendBird
class SBChannelsFromSendBird {
  const SBChannelsFromSendBird._();

  static Future<SBChannelsState> getState({
    required int limit,
  }) async {
    /// send bird max limit = 100
    /// so if num of therapist form back end more than 100
    /// make limit 100 and if there is more than 100 then check hasNext = true;
    /// then load more items

    if (limit > 100) {
      limit = 100;
    }
    SBChannelsState state = await _getState(
      limit: limit,
      reload: true,
    );
    if (!_isLoadedExistingSBChannelsState(state)) {
      return state;
    }
    state as LoadedExistingSBChannelsState;
    bool hasNext = state.hasNext;
    List<ContactItem> chatList = state.chatList;

    /// if there is next load more and add it to chatList
    /// and then update hasNext
    while (hasNext) {
      SBChannelsState? newState = await _getState(
        limit: limit,
        reload: false,
      );
      if (!_isLoadedExistingSBChannelsState(newState)) {
        return state;
      }
      newState as LoadedExistingSBChannelsState;
      hasNext = newState.hasNext;
      chatList.addAll(newState.chatList);
      state = LoadedExistingSBChannelsState(
        chatList: chatList,
        hasNext: hasNext,
      );
    }
    return state;
  }

  static bool _isLoadedExistingSBChannelsState(SBChannelsState state) {
    if (state is LoadedExistingSBChannelsState) {
      return true;
    }
    return false;
  }

  static Future<SBChannelsState> _getState({
    required int limit,
    required bool reload,
  }) async {
    SBChannelsState? state;
    await SendBirdManager.getExistingChannelsFromSendBird(
      reload: reload,
      limit: limit,
      onSuccess: (List<GroupChannel> group, bool hasNext) {
        if (group.isEmpty && !hasNext) {
          state = const EmptySBChannelsListState();
        } else {
          state = LoadedExistingSBChannelsState(
            chatList: group
                .map(
                  (channel) =>
                      ContactItemBuilderFromSendBird(groupChannel: channel)
                          .getContactItem(),
                )
                .toList(),
            hasNext: hasNext,
          );
        }
      },
      onFail: ({String? msg}) => state = ExceptionSBChannelsState(message: msg),
    );
    return state!;
  }
}
