import 'dart:developer';

class RasselUserState {
  static RasselUserState? _instance;
  RasselUserState._();
  static RasselUserState get _i {
    _instance ??= RasselUserState._();
    return _instance!;
  }

  bool _isConversationOpened = false;
  String? restoreId;

  /// set the conversation State isOpened Or not
  static set isConversationOpened(bool isOpened) {
    log("is isConversationOpened Opened: $isOpened");
    _i._isConversationOpened = isOpened;
  }

  static bool get isConversationOpened => _i._isConversationOpened;
}
