import 'package:adjust_sdk/adjust_config.dart';
import 'package:o7therapy/api/environments/environment.dart';

class StagingEnv implements Environment {
  const StagingEnv();

  /// Staging: http://104.42.35.134/
  @override
  String get envBaseUrl => "http://104.42.35.134:8080";

  // @override
  // String get envBaseUrl => "https://gatewaystg.o7therapy.com";

  @override
  String get envAppSecret => appSecret;

  @override
  String get envClientId => clientId;

  @override
  String get envGrantType => grantType;

  @override
  String get merchantIdentifier => '6be25812'; //stg

  @override
  String get shaRequestPhrase => '\$2y\$10\$rvaQyZlrW'; //stg

  @override
  String get accessCode => 'stv40N9RCK9hK4YRsPME'; //stg

  @override
  AdjustEnvironment get adjustEnv => AdjustEnvironment.sandbox;

  @override
  String get mixpanelToken => '8644b5e626e2dfd831a3ffc3c9911765'; //stg

  @override
  String get rasselAppId => "8353e06b-fbfa-4df4-8abf-3d418db238cf"; //stg

  @override
  String get rasselAppKey => "949af2f5-4e0f-438f-8bd6-fc704250de81"; //stg

  @override
  String get adjustToken => 'ryulo9cubcw0'; //prod there is no stg token

  @override
  String get returnUrl =>
      'https://gatewaystg.o7therapy.com/api/aggregate/server/payment/v1/pay'; //stg

  @override
  String get cancelSessionReturnUrl =>
      'https://gatewaystg.o7therapy.com/api/aggregate/server/payment/v1/paycanceledsession'; //stg

  @override
  String get rasselSubscribeReturnUrl =>
      'https://gatewaystg.o7therapy.com/api/aggregate/server/payment/v1/paysubscription'; //stg

  @override
  String getReturnUrl(String userId, String countryCode) {
    return 'https://gatewaystg.o7therapy.com/api/credit_card/payfort/v1?account_number=$userId&country_code=$countryCode'; //stg
  }

  @override
  String get payfortTokenization =>
      "https://sbcheckout.PayFort.com/FortAPI/paymentPage";

  // stg and dev
  // static const payfortTokenization = "https://sbcheckout.PayFort.com/FortAPI/paymentPage";

  @override
  String get zoomApiKey => 'JtOYkgAdzZ4JhSkYotoGjDY5tbcnYgH8Bxu5';

  @override
  String get zoomAppSecret => 'c8MFgdZwwy0rqPcYpUU9T4NlAHoMJxTRohQO';

  @override
  String get sendBirdApplicationID => "C8F82B6F-79AA-43B1-8B87-E752361ABB9E";

  @override
  String get sendBirdApiToken => "8511ddaf83247f17a8fb95ef3ae1841c73a3b268";

  @override
  String get sendBirdApiUrl =>
      "https://api-0C95A93B-289E-4FC8-8125-9C8296E6E1F5.sendbird.com/v3";
}
