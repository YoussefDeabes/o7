import 'package:adjust_sdk/adjust_config.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/environments/environments.dart';
import 'package:o7therapy/api/fort_constants.dart';
import 'package:o7therapy/api/send_bird_constants.dart';
import 'package:o7therapy/api/zoom_constants.dart';

enum EnvType {
  prod(analyticsName: "production"),
  stg(analyticsName: "staging"),
  dev(analyticsName: "dev");

  const EnvType({required this.analyticsName});
  final String analyticsName;
}

const String clientId = "Xamarin";
const String grantType = "password";
const String appSecret = "secret";

abstract class Environment {
  static late EnvType _envType;
  static EnvType get envType => _envType;
  final String envBaseUrl;
  final String envAppSecret;
  final String envClientId;
  final String envGrantType;
  final String merchantIdentifier;
  final String accessCode;
  final String shaRequestPhrase;
  final String returnUrl;
  final String cancelSessionReturnUrl;
  final String rasselSubscribeReturnUrl;
  final String payfortTokenization;
  final String zoomApiKey;
  final String zoomAppSecret;
  final String sendBirdApplicationID;
  final String sendBirdApiToken;
  final String sendBirdApiUrl;
  final String mixpanelToken;
  final String rasselAppId;
  final String rasselAppKey;
  final AdjustEnvironment adjustEnv;
  final String adjustToken;

  String getReturnUrl(String userId, String countryCode);

  const Environment(
      this.envBaseUrl,
      this.envAppSecret,
      this.envClientId,
      this.envGrantType,
      this.merchantIdentifier,
      this.accessCode,
      this.shaRequestPhrase,
      this.returnUrl,
      this.cancelSessionReturnUrl,
      this.rasselSubscribeReturnUrl,
      this.payfortTokenization,
      this.zoomApiKey,
      this.zoomAppSecret,
      this.sendBirdApplicationID,
      this.sendBirdApiToken,
      this.sendBirdApiUrl,
      this.mixpanelToken,
      this.adjustEnv,
      this.adjustToken,
      this.rasselAppKey,
      this.rasselAppId);

  static void init({required EnvType envType}) {
    _envType = envType;
    Environment env;
    switch (envType) {
      case EnvType.prod:
        env = const ProdEnv();
        break;
      case EnvType.stg:
        env = const StagingEnv();
        break;
      case EnvType.dev:
        env = const DevEnv();
        break;
    }
    ApiKeys.setEnvironment(env: env);
    SendBirdConstants.setEnvironment(env: env);
    FortConstants.setEnvironment(env: env);
    ZoomConstants.setEnvironment(env: env);
  }
}
