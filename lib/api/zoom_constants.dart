import 'package:o7therapy/api/environments/environments.dart';

class ZoomConstants {
  ZoomConstants._();
  static late final Environment _env;
  static String get apiKey => _env.zoomApiKey;
  static String get appSecret => _env.zoomAppSecret;

  static void setEnvironment({required Environment env}) => _env = env;
}
