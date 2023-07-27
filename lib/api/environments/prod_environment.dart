import 'package:adjust_sdk/adjust_config.dart';
import 'package:o7therapy/api/environments/environment.dart';

class ProdEnv implements Environment {
  const ProdEnv();

  @override
  String get envBaseUrl => "https://gateway.o7therapy.com";

  @override
  String get envAppSecret => "H7Edvhfn";

  @override
  String get envClientId => clientId;

  @override
  String get envGrantType => grantType;

  @override
  String get merchantIdentifier => 'ykfuEpCy'; //prod

  @override
  String get accessCode => 'HcZKOMtB9NifjU7IJTHj'; // prod

  @override
  String get shaRequestPhrase => '\$2y\$10\$JUYxbjIwX'; //prod

  @override
  String get mixpanelToken => 'eb394395d2ec6beac1227fc25cf59c7f'; //prod

  @override
  AdjustEnvironment get adjustEnv => AdjustEnvironment.production; //prod

  @override
  String get adjustToken => 'ryulo9cubcw0'; //prod

  @override
  String get returnUrl =>
      'https://gateway.o7therapy.com/api/aggregate/server/payment/v1/pay';

  @override
  String get cancelSessionReturnUrl =>
      'https://gateway.o7therapy.com/api/aggregate/server/payment/v1/paycanceledsession';

  @override
  String get rasselSubscribeReturnUrl =>
      'https://gateway.o7therapy.com/api/aggregate/server/payment/v1/paysubscription';

  @override
  String getReturnUrl(String userId, String countryCode) {
    return 'https://gateway.o7therapy.com/api/credit_card/payfort/v1?account_number=$userId&country_code=$countryCode';
  }

  @override
  String get payfortTokenization =>
      "https://checkout.payfort.com/FortAPI/paymentPage";

  ///prod
  @override
  String get zoomApiKey => 'LosDkTvbLCagFbY3bRXDwXD0lwy3UySfh9je';

  @override
  String get zoomAppSecret => '02vDaiz4P71Wa24xGLOrbHH79ImOQzazGjsx';

  @override
  String get sendBirdApplicationID => "0C95A93B-289E-4FC8-8125-9C8296E6E1F5";

  @override
  String get sendBirdApiToken => "35533b45e938f9e0e536aad922838304571e707d";

  @override
  String get sendBirdApiUrl =>
      "https://api-0C95A93B-289E-4FC8-8125-9C8296E6E1F5.sendbird.com/v3";

  @override
  String get rasselAppId => 'a11bf035-a1a6-4eaf-8363-da3eddeace31';
  @override
  String get rasselAppKey => '7c203440-59d4-4ba4-b45a-2ff1d5f64719';
}
