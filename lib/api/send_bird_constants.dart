import 'package:o7therapy/api/environments/environments.dart';

class SendBirdConstants {
  SendBirdConstants._();
  static late final Environment _env;
  static String get sendBirdApplicationID => _env.sendBirdApplicationID;
  static String get sendBirdApiToken => _env.sendBirdApiToken;
  static String get sendBirdApiUrl => _env.sendBirdApiUrl;

  static String getUnreadChannelCountUrl(String userId) {
    return "$sendBirdApiUrl/users/$userId/unread_channel_count";
  }

  static const String sendBirdApiTokenKey = "Api-Token";

  static void setEnvironment({required Environment env}) => _env = env;
}
