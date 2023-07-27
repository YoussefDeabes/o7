import 'package:o7therapy/ui/screens/messages/blocs/send_bird_bloc/send_bird_bloc.dart';
import 'package:o7therapy/api/send_bird_manager.dart';

abstract class BaseSendBirdRepository {
  const BaseSendBirdRepository();

  void initSendBird();

  /// connect send bird while the main home screen opens
  Future<SendBirdState> connect();
}

class SendBirdRepository extends BaseSendBirdRepository {
  const SendBirdRepository();
  @override
  void initSendBird() => SendBirdManager.init();

  @override
  Future<SendBirdState> connect() async {
    SendBirdState? state;
    try {
      await SendBirdManager.connect(
        onSuccess: () => state = const SuccessConnectedSendBirdState(),
        onFail: ({String? msg}) => state = ExceptionSendBirdState(message: msg),
      );
    } catch (e) {
      state = const ExceptionSendBirdState();
    }
    return state!;
  }
}
