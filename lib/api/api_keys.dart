import 'package:adjust_sdk/adjust_config.dart';
import 'package:o7therapy/api/environments/environments.dart';
import 'package:o7therapy/prefs/pref_manager.dart';

class ApiKeys {
  static late final String baseUrl;
  static late final String appSecret;
  static late final String clientId;
  static late final String grantType;
  static late final String mixpanelToken;
  static late final String adjustToken;
  static late final String rasselAppId;
  static late final String rasselAppKey;
  static late final AdjustEnvironment adjustEnv;

  const ApiKeys._();

  static void setEnvironment({required Environment env}) {
    baseUrl = env.envBaseUrl;
    appSecret = env.envAppSecret;
    clientId = env.envClientId;
    grantType = env.envGrantType;
    mixpanelToken = env.mixpanelToken;
    rasselAppId = env.rasselAppId;
    rasselAppKey = env.rasselAppKey;
    adjustEnv = env.adjustEnv;
    adjustToken = env.adjustToken;
  }

  /// Headers
  static Future<Map<String, String>> getAuthHeaders() async {
    return {
      accept: applicationJson,
      locale: (await PrefManager.getLang() ?? "en"),
      version: "1",
      platform: 'ios'
    };
  }

  static Future<Map<String, String>> getHeaders() async {
    return {
      authorization: '$keyBearer ${await PrefManager.getToken()}',
      accept: applicationJson,
      locale: (await PrefManager.getLang() ?? "en")
    };
  }

  /// Keys
  static const authorization = "Authorization";
  static const accept = "Accept";
  static const applicationJson = "application/json";
  static const locale = "locale";
  static const keyBearer = "Bearer";
  static const migrant = "migrant";
  static const version = "version";
  static const platform = "Platform";
  static const language = "Language";
  static const timeZone = "Timezone";
  static const country = "country";
  static const utcOffset = "UtcOffset";
  static const timezone = "timezone";
  static const nextAppVersion = "3.0.18";

  ///Adjust events token
  static const loginEventToken = "dbbf8b";
  static const nextEventToken = "j1a7nd";
  static const payNowEventToken = "8leh8l";
  static const bookASessionEventToken = "tidlqk";
  static const proceedToPaymentWithoutPromoEventToken = "fllwbx";
  static const proceedToPaymentWithPromoEventToken = "7qb04e";
  static const registrationEventToken = "lj2hua";
  static const getStartedEventToken = "v0jnz7";
  static const thankYouPageWithoutPromoEventToken = "jp6umh";
  static const thankYouPageWithPromoEventToken = "l6ay09";
  static const rasselDomain = "msdk.freshchat.com";

  static final baseApiUrl = '$baseUrl/api';
  static final loginUrl = '$baseApiUrl/identity/patients/v1/login';
  static final signUpUrl = '$baseApiUrl/identity/patients/v1.1/register';
  static final logoutUrl = '$baseApiUrl/identity/account/v1/logout';
  static final refreshTokenUrl =
      "$baseApiUrl/identity/account/v1/refresh_token";

  static const ipApiKey = "yFei0hNDltJtqvDNzfh3S3tXmxW53zsMgk76ah4z8geKqWxVIe";
  static final changePasswordUrl =
      '$baseApiUrl/identity/account/v1/reset_password';

  static String get getChatContactsUrl =>
      "$baseApiUrl/aggregate/chat/v1/contacts";

  /// send the code and user id to verify email
  /// api/identity/account/v1/verify_client_email?user_id=9ae14006-7d77-4ccb-96a1-6d1797661117&code=2Sgcc
  static final verifyClientEmailUrl =
      '$baseApiUrl/identity/account/v1/verify_client_email_v2';

  static final String clientTherapistBookedBeforeListUrl =
      "$baseApiUrl/aggregate/therapists/v1/GetClientTherapists";

  /// Resend verification code to user to re-enter it
  /// /api/identity/account/v1/send_verification_email
  /// post
  /// user_id: ""
  static final resendVerificationCodeEmail =
      '$baseApiUrl/identity/account/v1/send_verification_email';

  static final myProfileUrl = '$baseApiUrl/identity/patients/v1/my_profile';

  /// api/identity/account/v1/check_verified_email?user_id=
  static final checkVerifiedEmail =
      '$baseApiUrl/identity/account/v2/check_verified_email_mobile';

  static final upcomingSessionsUrl =
      '$baseApiUrl/sessions/patient_sessions/v1?session_brief_status=1';
  static final pastSessionsUrl =
      '$baseApiUrl/sessions/patient_sessions/v1?session_brief_status=0';
  static final zoomSessionUrl =
      '$baseApiUrl/sessions/patient_sessions/v1/join_session/';
  static final therapistBio = '$baseApiUrl/aggregate/therapists/v1/';

  // this url for _therapistListGuestUrl
  static final String _therapistListGuestUrl =
      '$baseApiUrl/identity/therapists/v1?';

  /// this url for _therapistListUrl
  static final String _therapistListUrl =
      "$baseApiUrl/aggregate/therapists/v1.1/getTherapistList?";

  static final String _availableSlots =
      '$baseApiUrl/sessions/patient_slots/v1?';

  static final String checkUserDiscountsUrl =
      '$baseApiUrl/aggregate/payment/v1/check_user_discounts';

  static final String checkClientInDebtUrl =
      '$baseApiUrl/sessions/patient_sessions/v1/check_client_indebt';
  static final String verifyHasSessionsOnWallet =
      '$baseApiUrl/aggregate/sessionswallet/v1/verify_user_has_session_on_wallet';
  static final String sessionsOnWallet =
      '$baseApiUrl/aggregate/sessionswallet/v1';
  static final String flatRateInsuranceUrl =
      '$baseApiUrl/aggregate/slots/v1/check_user_is_flat_insurance';
  static final String _verifyInsuranceDealUrl =
      '$baseApiUrl/aggregate/slots/v1/verify_insurance_deal?slot_id=';
  static final String _verifyCorporateDealUrl =
      '$baseApiUrl/aggregate/slots/v1/verify_corporate_deal?slot_id=';
  static final String _verifyPromoCode =
      '$baseApiUrl/aggregate/slots/v1/verify_promo_code?';
  static final String creditCardList = '$baseApiUrl/credit_card/cards/v1';
  static final String checkIfSessionCompensated =
      '$baseApiUrl/aggregate/sessionswallet/v1/check_if_session_compansated/';
  static final String calculateSessionCancellationFees =
      '$baseApiUrl/aggregate/sessions/v1/calculate_session_cancellation_fees/';
  static final String calculateSessionRescheduleFees =
      '$baseApiUrl/aggregate/sessions/v1/calculate_session_reschedule_fees/';
  static final String cancelSession =
      '$baseApiUrl/aggregate/sessions/v1/cancel_session/';
  static final String bookSession = '$baseApiUrl/aggregate/slots/v1/book/';
  static final String payWithSavedCard =
      '$baseApiUrl/aggregate/payment/v1/pay/';
  static final String paySubscribeWithSavedCard =
      '$baseApiUrl/aggregate/payment/v1/paysubscription';
  static final String deleteCreditCard = '$baseApiUrl/aggregate/creditCard/v1/';
  static final String setAsPreferredCard =
      '$baseApiUrl/credit_card/cards/v1/set_preferred_card/';
  static final rescheduleSession =
      '$baseApiUrl/aggregate/sessions/v1/reschedule_session/';
  static final requestASession =
      '$baseApiUrl/sessions/patient_slots/v1/prompt_add_slot?therapist_id=';
  static final joinWaitingList =
      '$baseApiUrl/sessions/patient_slots/v1/join_waitlist?therapist_id=';
  static final updateProfileUrl =
      '$baseApiUrl/identity/patients/v1.1/my_profile';
  static final mySubscriptionsUrl =
      '$baseApiUrl/identity/patients/v1.1/my_subscriptions';
  static final cancelSubscription =
      '$baseApiUrl/identity/patients/v1.1/cancel_subscription';

  //Get upcoming sessions query url
  static String upcomingSessionsUrlQuery(
      {String sortByAttribute = 'FromDate',
      String direction = "Asc",
      required String from,
      required String to,
      required int pageNumber,
      int pageSize = 20}) {
    return "$upcomingSessionsUrl&sort_by_attribute=$sortByAttribute&direction=$direction&page_number=$pageNumber&page_size=$pageSize";
  }

  //Get upcoming sessions query url
  static String pastSessionsUrlQuery(
      {String sortByAttribute = 'FromDate',
      String direction = "Desc",
      required String from,
      required String to,
      required int pageNumber,
      int pageSize = 10}) {
    return "$pastSessionsUrl&sort_by_attribute=$sortByAttribute&direction=$direction&page_number=$pageNumber&page_size=$pageSize";
  }

  static String get insuranceProvidersList =>
      "$baseApiUrl/insurance/client/v1/get_insurance_providers";

  static String get getCardMaskedNumberUrl =>
      "$baseApiUrl/insurance/client/v1/get_card_masked_number";

  static String minMax() =>
      "$baseApiUrl/identity/therapists/v1/get_min_max_price";

  static String get addInsuranceCard => "$baseApiUrl/insurance/client/v1";

  static String get deleteCard => "$baseApiUrl/insurance/client/v1/Delete_Card";

  static String get getInsuranceCard =>
      "$baseApiUrl/insurance/client/v1/my_insurance_cards";

  static String get validateCardOtp =>
      "$baseApiUrl/insurance/client/v1/validate_card_otp";

  static String get resendVerificationCode =>
      "$baseApiUrl/insurance/client/v1/resend_verification_code";

  static String get updateInsuranceCard =>
      "$baseApiUrl/insurance/client/v1/update_Card";

  static String get getRemainingInsuranceCard =>
      "$baseApiUrl/insurance/client/v1/get_remaining_cap_no";

  static String get notifications => "$baseApiUrl/messaging/notifications";

  static String get unreadNotificationsCount =>
      "$baseApiUrl/messaging/get_unread_notifications_count";

  static String get markAllAsRead => "$baseApiUrl/messaging/mark_all_as_read";

  static final pushForNotification = "$baseApiUrl/messaging/register_for_push";

  static String get updateMessagesStatus =>
      "$baseApiUrl/messaging/update_messages_status";

  static String get getRemainingCapNoForEwpUrl =>
      "$baseApiUrl/aggregate/payment/v1.1/get_remaining_cap_no_v2";

  static String get verifyUserIsCorporateUrl =>
      "$baseApiUrl/aggregate/payment/v1/verify_user_is_corporate_v2";

  static String get accumulativeSessionFees =>
      "$baseApiUrl/sessions/patient_sessions/v1/get_accmulative_session_fees";

  static String get sendForgotPasswordUrl =>
      "$baseApiUrl/identity/account/v1.1/forgot_password";

  static String get verifyForgotPasswordCodeUrl =>
      "$baseApiUrl/identity/account/v1.1/forgot_password_otp_verification";

  static String get updateForgotPasswordVerificationUrl =>
      "$baseApiUrl/identity/account/v1.1/forgot_password_verification";

  static String get confirmStatusUrl =>
      "$baseApiUrl/sessions/patient_sessions/v1/add_session_history";

  static String get enforceUpdate =>
      "$baseApiUrl/identity/version/check_application_version";

  static String get getRasselSubscription =>
      "$baseApiUrl/aggregate/services/v1/get_rasel_subscription";

  static String get getIsSubscribed =>
      "$baseApiUrl/services/client/v1/is_subscriped";

  static String get getRasselClientSubscription =>
      "$baseApiUrl/services/client/v1/get_client_subscriptions";

  static String get getRasselClientSubscriptionWithResibscribe =>
      "$baseApiUrl/services/client/v1/get_client_subscriptions_with_resubscribe";

  static String get calculateSubscriptionFees =>
      "$baseApiUrl/services/client/v1/calculate_subscription_fees";

  static String get rasselCancelSubscription =>
      "$baseApiUrl/services/client/v1/cancel_subscription";

  static String get rasselSubscribe =>
      "$baseApiUrl/aggregate/services/v1/subscripe";

  /// get the UrlQuery to get the list of therapist from backend
  /// api/identity/therapists/v1?
  /// page_number=1
  /// &page_size=5
  /// &sort_by_attribute=Availability
  /// &direction=Asc
  /// &include_unavailable=true
  static String therapistListUrlQuery({
    int pageNumber = 1,
    int pageSize = 10,
    String sortByAttribute = "Availability",
    String direction = "Asc",
    includeUnavailable = true,
  }) {
    return "$_therapistListUrl&sort_by_attribute=$sortByAttribute&direction=$direction&page_number=$pageNumber&page_size=$pageSize&include_unavailable=$includeUnavailable";
  }

  static String therapistListGuestUrlQuery({
    int pageNumber = 1,
    int pageSize = 4,
    String sortByAttribute = "Availability",
    String direction = "Asc",
    includeUnavailable = true,
  }) {
    return "$_therapistListGuestUrl&sort_by_attribute=$sortByAttribute&direction=$direction&page_number=$pageNumber&page_size=$pageSize&include_unavailable=$includeUnavailable";
  }

  static String availableSlotsUrlQuery({
    required String id,
  }) {
    return "${_availableSlots}therapist_id=$id";
  }

  static String joinSessionUrl(String id) {
    return zoomSessionUrl + id;
  }

  static String verifyCorporateFlatRateUrl(String slotId) {
    return _verifyCorporateDealUrl + slotId;
  }

  static String checkUserDiscountsQueryUrl(String slotId) {
    return "$checkUserDiscountsUrl?slotId=$slotId";
  }

  static String verifyInsuranceFlatRateUrl(String slotId) {
    return _verifyInsuranceDealUrl + slotId;
  }

  static String verifyPromoCodeUrl(String slotId, String promoCode) {
    return "${_verifyPromoCode}slot_id=$slotId&promo_code=$promoCode";
  }

  static String therapistBioUrl(String id) {
    return "$therapistBio$id";
  }

  static String checkIfSessionCompensatedUrl({
    required int id,
  }) {
    return "$checkIfSessionCompensated$id";
  }

  static String calculateSessionCancellationFeesUrl({
    required int id,
  }) {
    return "$calculateSessionCancellationFees$id";
  }

  static String calculateSessionRescheduleFeesUrl({
    required int id,
  }) {
    return "$calculateSessionRescheduleFees$id";
  }

  static String cancelSessionUrl({
    required int id,
  }) {
    return "$cancelSession$id";
  }

  static String setAsPreferredCardUrl({
    required String code,
  }) {
    return "$setAsPreferredCard$code";
  }

  static String deleteCardUrl({
    required String code,
  }) {
    return "$deleteCreditCard$code";
  }

  static String rescheduleSessionUrl({
    required int id,
  }) {
    return "$rescheduleSession$id";
  }

  static String requestASessionUrl({
    required String id,
  }) {
    return "$requestASession$id";
  }

  static String joinWaitListUrl({
    required String id,
  }) {
    return "$joinWaitingList$id";
  }

  static String enforceUpdateUrl({
    required String appVersion,
    required String platform,
  }) {
    return "$enforceUpdate?application_version=$appVersion&platform=$platform";
  }

  static String getIsSubscribedQuery({
    required String subscriptionId,
  }) {
    return "$getIsSubscribed?subscriptionId=$subscriptionId";
  }

  static String getCancelSubscriptionQuery({
    required String clientSubscriptionId,
  }) {
    return "$rasselCancelSubscription?clientSubscriptionId=$clientSubscriptionId";
  }

  static const aboutO7 = "https://o7therapy.com/mobile-about-o7/";
  static const arAboutO7 = "https://o7therapy.com/ar/mobile-about-o7/";
  static const faqs = "https://o7therapy.com/mobile-faq/";
  static const arFaqs = "https://o7therapy.com/ar/mobile-faq/";
  static const ewpFormUrl = "https://o7therapy.com/corporate-registration/";

  static const mobilePrivacyPolicy =
      "https://o7therapy.com/mobile-privacy-policy/";
  static const arMobilePrivacyPolicy =
      "https://o7therapy.com/ar/mobile-privacy-policy/";

  static const mobileTermsAndConditions =
      "https://o7therapy.com/mobile-terms-and-conditions/";
  static const arMobileTermsAndConditions =
      "https://o7therapy.com/ar/mobile-terms-and-conditions/";
}
