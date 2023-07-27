import 'package:dio/dio.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/environments/environments.dart';
import 'package:o7therapy/api/models/ip_api/ip_api_model.dart';
import 'package:o7therapy/api/models/payfort_urls/PayfortUrls.dart';

class FortConstants {
  const FortConstants._();

  static late final Environment _env;

  static String get payfortTokenization => _env.payfortTokenization;

  static String get merchantIdentifier => _env.merchantIdentifier;

  static String get accessCode => _env.accessCode;

  static String get shaRequestPhrase => _env.shaRequestPhrase;

  static String get returnUrl => _env.returnUrl;

  static String get cancelSessionReturnUrl => _env.cancelSessionReturnUrl;

  static String get rasselSubscribeReturnUrl => _env.rasselSubscribeReturnUrl;

  static String getReturnUrl(String userId, String countryCode) =>
      _env.getReturnUrl(userId, countryCode);

  static void setEnvironment({required Environment env}) => _env = env;

  static Future<PayfortUrls> getLoginSignUpHeaders() async {
    final response =
        await Dio().get("https://ipapi.co/json/?key=${ApiKeys.ipApiKey}");

    IpApiDataModel ipApiModel = IpApiDataModel.fromJson(response.data);

    await Dio()
        .get("https://gateway.o7therapy.com/api/aggregate/configurations/v1");

    PayfortUrls payfortUrls = PayfortUrls.fromJson(response.data);
    return payfortUrls;
  }

  //PARAMS
  static const String merchantExtra = 'pay_session';
  static const String merchantExtraReschedule = 'pay_rescheduled_session';
  static const String merchantExtraRasselSubscribe = 'pay_subscription';
  static const String tokenizationCommand = 'TOKENIZATION';
  static const String createTokenCommand = 'CREATE_TOKEN';
  static const String language = 'en';
  static const String shaType = 'SHA-256';

  //Request attributes
  static const String accessCodeAttr = 'access_code';
  static const String cardHolderNameAttr = 'card_holder_name';
  static const String cardNumberAttr = 'card_number';
  static const String cardSecurityCodeAttr = 'card_security_code';
  static const String expiryDateAttr = 'expiry_date';
  static const String languageAttr = 'language';
  static const String merchantExtraAttr = 'merchant_extra';
  static const String merchantExtra1Attr = 'merchant_extra1';
  static const String merchantExtra2Attr = 'merchant_extra2';
  static const String merchantExtra3Attr = 'merchant_extra3';
  static const String merchantIdentifierAttr = 'merchant_identifier';
  static const String merchantReferenceAttr = 'merchant_reference';
  static const String rememberMeAttr = 'remember_me';
  static const String returnUrlAttr = 'return_url';
  static const String serviceCommandAttr = 'service_command';
  static const String signatureAttr = 'signature';
  static const String currencyAttr = 'currency';
  static const String userId = 'user_id';
  static const String userToken = 'user_token';
  static const String userIp = 'user_ip';
}
