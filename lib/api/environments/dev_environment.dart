import 'package:adjust_sdk/adjust_config.dart';
import 'package:o7therapy/api/environments/environment.dart';

class DevEnv implements Environment {
  const DevEnv();

  /// Dev: http://20.253.156.153/
  @override
  String get envBaseUrl => "http://20.253.156.153:8080";

  // @override
  // String get envBaseUrl => "https://gatewaydev.o7therapy.com";

  @override
  String get envAppSecret => appSecret;

  @override
  String get envClientId => clientId;

  @override
  String get envGrantType => grantType;

  @override
  String get returnUrl =>
      'https://gatewaydev.o7therapy.com/api/aggregate/server/payment/v1/pay'; //dev

  @override
  String get cancelSessionReturnUrl =>
      'https://gatewaydev.o7therapy.com/api/aggregate/server/payment/v1/paycanceledsession';

  @override
  String get rasselSubscribeReturnUrl =>
      'https://gatewaydev.o7therapy.com/api/aggregate/server/payment/v1/paysubscription';

  @override
  String getReturnUrl(String userId, String countryCode) {
    return 'https://gatewaydev.o7therapy.com/api/credit_card/payfort/v1?account_number=$userId&country_code=$countryCode'; //dev
  }

  @override
  String get merchantIdentifier => "6be25812";

  @override
  String get accessCode => 'stv40N9RCK9hK4YRsPME';

  @override
  String get shaRequestPhrase => '\$2y\$10\$rvaQyZlrW';

  @override
  String get payfortTokenization =>
      "https://sbcheckout.PayFort.com/FortAPI/paymentPage";

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

  String get mixpanelToken => '8644b5e626e2dfd831a3ffc3c9911765';

  @override
  AdjustEnvironment get adjustEnv => AdjustEnvironment.sandbox;

  @override
  String get adjustToken => 'ryulo9cubcw0'; //prod there is no stg token

  @override
  String get rasselAppId => 'c9bed259-ddde-4f8b-9d29-f458f1db7650'; //stg
  @override
  String get rasselAppKey => '07679fbe-2b42-4281-b675-c1e13bdba229'; //stg
}
