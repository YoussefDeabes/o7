import 'package:o7therapy/ui/screens/messages/blocs/send_bird_channels_bloc/sb_channels_bloc.dart';
import 'package:o7therapy/ui/screens/messages/models/contact_item.dart';
import 'package:o7therapy/api/send_bird_manager.dart';

/// get the channels from back end
class SBChannelsFromBackend {
  static LoadedExistingSBChannelsState? loadedExistingSBChannelsState;
  const SBChannelsFromBackend._();

  static Future<SBChannelsState> getState({bool reload = false}) async {
    if (reload == false && loadedExistingSBChannelsState != null) {
      return loadedExistingSBChannelsState!;
    }
    loadedExistingSBChannelsState = null;
    SBChannelsState? state;
    await SendBirdManager.getExistingChannelsFromBackEnd(
      reload: reload,
      onSuccess: (List<ContactItem> chatList, bool hasNext) {
        if (chatList.isEmpty && !hasNext) {
          state = const EmptySBChannelsListState();
        } else {
          state = LoadedExistingSBChannelsState(
            chatList: chatList,
            hasNext: hasNext,
          );
          loadedExistingSBChannelsState =
              state as LoadedExistingSBChannelsState;
        }
      },
      onFail: ({String? msg}) => state = ExceptionSBChannelsState(message: msg),
    );
    return state!;
  }
}
