import 'package:o7therapy/ui/screens/messages/blocs/send_bird_channels_bloc/channels_source/sb_channels_from_backend.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_channels_bloc/channels_source/sb_channels_from_send_bird.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_channels_bloc/sb_channels_bloc.dart';
import 'package:o7therapy/ui/screens/messages/models/contact_item.dart';
import 'package:o7therapy/api/send_bird_manager.dart';

abstract class BaseSBChannelsRepository {
  const BaseSBChannelsRepository();

  Future<SBChannelsState> getExistingChannels({bool reload = false});
  Future<SBChannelsState> loadMoreChannels();
}

class SBChannelsRepository extends BaseSBChannelsRepository {
  const SBChannelsRepository();

  @override
  Future<SBChannelsState> getExistingChannels({bool reload = false}) async {
    SBChannelsState? state;
    try {
      SBChannelsState backEndState =
          await SBChannelsFromBackend.getState(reload: reload);
      if (backEndState is LoadedExistingSBChannelsState &&
          backEndState.chatList.isNotEmpty) {
        SBChannelsState sendBirdState = await SBChannelsFromSendBird.getState(
          limit: backEndState.chatList.length,
        );
        if (sendBirdState is LoadedExistingSBChannelsState) {
          state = updateLoadedExistingSBChannelsState(
            backEndState: backEndState,
            sendBirdState: sendBirdState,
          );
        } else {
          state = sendBirdState;
        }
      } else {
        state = backEndState;
      }
    } catch (e) {
      state = const ExceptionSBChannelsState();
    }
    return state;
  }

  @override
  Future<SBChannelsState> loadMoreChannels() async {
    SBChannelsState? state;
    try {
      await SendBirdManager.getExistingChannelsFromBackEnd(
        reload: false,
        onSuccess: (List<ContactItem> chatList, bool hasNext) {
          state = LoadedExistingSBChannelsState(
            chatList: chatList,
            hasNext: hasNext,
          );
        },
        onFail: ({String? msg}) =>
            state = ExceptionSBChannelsState(message: msg),
      );
    } catch (e) {
      state = const ExceptionSBChannelsState();
    }
    return state!;
  }

  LoadedExistingSBChannelsState updateLoadedExistingSBChannelsState({
    required LoadedExistingSBChannelsState backEndState,
    required LoadedExistingSBChannelsState sendBirdState,
  }) {
    List<ContactItem> chatList = sendBirdState.chatList;
    List<ContactItem> updatedContacts = [];
    List<ContactItem> backEndChatList = List.from(backEndState.chatList);

    for (var sendBirdItem in chatList) {
      try {
        /// find the backEndItem where its channelUrl == current sendBirdItem.channelUrl
        /// and then remove it from the list >> we will not need it anyMore

        ContactItem backEndItem = backEndChatList
            .firstWhere((item) => item.channelUrl == sendBirdItem.channelUrl);
        backEndChatList.remove(backEndItem);
        updatedContacts.add(ContactItem(
            groupChannel: sendBirdItem.groupChannel,
            canChatTill: backEndItem.canChatTill,
            channelUrl: sendBirdItem.channelUrl,
            therapistId: backEndItem.therapistId,
            contactType: backEndItem.contactType,
            groupChannelImage: backEndItem.groupChannelImage,
            groupChannelName: backEndItem.groupChannelName,
            lastMessage: sendBirdItem.lastMessage,
            lastMessageTime: sendBirdItem.lastMessageTime,
            noOfUnreadMessage: sendBirdItem.noOfUnreadMessage));
      } catch (_) {}
    }
    return LoadedExistingSBChannelsState(
      chatList: updatedContacts,
      hasNext: backEndState.hasNext,
    );
  }
}
