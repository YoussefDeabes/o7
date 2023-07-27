import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AndroidChannels {
  AndroidChannels._();
  static late final AndroidChannels _instance;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel _mainChannel;

  static void init() {
    _instance = AndroidChannels._();
    _instance._mainChannel = const AndroidNotificationChannel(
      /// id
      'o7_therapy',

      /// title
      'O7 Therapy Notifications',

      /// description
      description: 'This channel is Main O7 Therapy Channel Notifications.',
      importance: Importance.max,
    );
  }

  static AndroidNotificationChannel get mainChannel => _instance._mainChannel;
}
