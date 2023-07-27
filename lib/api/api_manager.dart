import 'dart:developer';

import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/base/base_api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/accumulative_session_fees/AccumulativeSessionFees.dart';
import 'package:o7therapy/api/models/activity/activity_wrapper.dart';
import 'package:o7therapy/api/models/activity/past_sessions/PastSessionsWrapper.dart';
import 'package:o7therapy/api/models/available_slots/AvailableSlotsWrapper.dart';
import 'package:o7therapy/api/models/book_session/BookSession.dart';
import 'package:o7therapy/api/models/book_session/book_session_send_model.dart';
import 'package:o7therapy/api/models/calculate_session_fees/CalculateSessionFees.dart';
import 'package:o7therapy/api/models/calculate_session_reschedule_fees/CalculateSessionRescheduleFees.dart';
import 'package:o7therapy/api/models/cancel_session/CancelSession.dart';
import 'package:o7therapy/api/models/card_pay/CardPay.dart';
import 'package:o7therapy/api/models/card_pay/card_pay_send_model.dart';
import 'package:o7therapy/api/models/card_pay/card_pay_subscribe_send_model.dart';
import 'package:o7therapy/api/models/change_password/ChangePassword.dart';
import 'package:o7therapy/api/models/change_password/change_password_send_model.dart';
import 'package:o7therapy/api/models/check_session_compensated/SessionCompensated.dart';
import 'package:o7therapy/api/models/client_indebt/ClientInDebtWrapper.dart';
import 'package:o7therapy/api/models/confirm_status/ConfirmStatus.dart';
import 'package:o7therapy/api/models/confirm_status/confirm_status_send_model.dart';
import 'package:o7therapy/api/models/corporate_deal/CorporateDeal.dart';
import 'package:o7therapy/api/models/credit_card/CreditCard.dart';
import 'package:o7therapy/api/models/delete_card/DeleteCard.dart';
import 'package:o7therapy/api/models/enforce_update/EnforceUpdate.dart';
import 'package:o7therapy/api/models/flat_rate/FlatRateWrapper.dart';
import 'package:o7therapy/api/models/has_wallet_sessions/HasWalletSessions.dart';
import 'package:o7therapy/api/models/insurance_deal/InsuranceDeal.dart';
import 'package:o7therapy/api/models/join_session/JoinSessionWrapper.dart';
import 'package:o7therapy/api/models/join_wait_list/JoinWaitList.dart';
import 'package:o7therapy/api/models/my_subscriptions/cancel_subscription_wrapper.dart';
import 'package:o7therapy/api/models/promo_code/PromoCode.dart';
import 'package:o7therapy/api/models/request_session/RequestSession.dart';
import 'package:o7therapy/api/models/set_preferred_card/PreferredCard.dart';
import 'package:o7therapy/api/models/reschedule_session/RescheduleSession.dart';
import 'package:o7therapy/api/models/reschedule_session/reschedule_session_send_model.dart';
import 'package:o7therapy/api/models/therapist_bio/TherapistBio.dart';
import 'package:o7therapy/api/models/user_discounts/UserDiscounts.dart';
import 'package:o7therapy/api/models/verify_wallet_sessions/VerifyWalletSessions.dart';
import 'package:http/http.dart' as http;

import 'models/my_subscriptions/my_subscriptions_wrapper.dart';

class ApiManager {
  static Future<void> upcomingSessionsApi(
      void Function(ActivityWrapper) success,
      void Function(NetworkExceptions) fail,
      {required int pageNumber, required String from,
        required  String to,
      int? pageSize}) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .get(ApiKeys.upcomingSessionsUrlQuery(
            pageNumber: pageNumber, pageSize: pageSize ?? 20,from: from,to: to))
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      log(extractedData.toString());
      ActivityWrapper wrapper = ActivityWrapper.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> pastSessionsApi(
      void Function(PastSessionsWrapper) success,
      void Function(NetworkExceptions) fail,
      {required int pageNumber, required String from,
        required  String to}) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .get(ApiKeys.pastSessionsUrlQuery(pageNumber: pageNumber,from: from,to: to))
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      PastSessionsWrapper wrapper = PastSessionsWrapper.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> joinSessionsApi(
      int id,
      void Function(JoinSessionWrapper) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .put(ApiKeys.joinSessionUrl(id.toString()))
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      JoinSessionWrapper wrapper = JoinSessionWrapper.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> getAvailableSlots(
      String therapistId,
      void Function(AvailableSlotsWrapper) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.availableSlotsUrlQuery(
        id: therapistId,
      ));

      AvailableSlotsWrapper wrapper =
          AvailableSlotsWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> checkUserDiscounts(void Function(UserDiscounts) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.checkUserDiscountsUrl);

      UserDiscounts wrapper = UserDiscounts.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> checkUserDiscountsQuery(
      String slotId,
      void Function(UserDiscounts) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response =
          await BaseApi.dio.get(ApiKeys.checkUserDiscountsQueryUrl(slotId));

      UserDiscounts wrapper = UserDiscounts.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> checkClientInDebt(
      void Function(ClientInDebtWrapper) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.checkClientInDebtUrl);

      ClientInDebtWrapper wrapper = ClientInDebtWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> hasWalletSessions(
      String slotId,
      void Function(VerifyWalletSessions) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio
          .post(ApiKeys.verifyHasSessionsOnWallet, data: {"slot_id": slotId});

      VerifyWalletSessions wrapper =
          VerifyWalletSessions.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> checkFlatRateInsurance(
      void Function(FlatRateWrapper) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.flatRateInsuranceUrl);

      FlatRateWrapper wrapper = FlatRateWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> verifyCorporateDeal(
      String slotId,
      void Function(CorporateDeal) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response =
          await BaseApi.dio.get(ApiKeys.verifyCorporateFlatRateUrl(slotId));

      CorporateDeal wrapper = CorporateDeal.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> verifyInsuranceDeal(
      String slotId,
      void Function(InsuranceDeal) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.verifyInsuranceFlatRateUrl(
        slotId,
      ));

      InsuranceDeal wrapper = InsuranceDeal.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> verifyPromoCode(
      String promoCode,
      String slotId,
      void Function(PromoCode) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response =
          await BaseApi.dio.get(ApiKeys.verifyPromoCodeUrl(slotId, promoCode));

      PromoCode wrapper = PromoCode.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> creditCards(void Function(CreditCard) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.creditCardList);

      CreditCard wrapper = CreditCard.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> sessionsWallet(void Function(HasWalletSessions) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.sessionsOnWallet);

      HasWalletSessions wrapper = HasWalletSessions.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> payfortTokenization(var htmlRequest) async {
    var headers = {
      "Content-Type": "multipart/form-data",
      "Accept": "*/*",
      // 'Cookie': 'JSESSIONID=DGWtVJsWcXc-iUwxJ_k6Hkekh7957HdyeHRu0PAh.ip-10-50-212-21; tkn1=117227y4BnFBum1I4G0rR5aScLbWns; tkn2=21130ZhXJfpqSZS80tvsDF8pIYpwJl'
    };

    // var loginPage = await http.post(Uri.parse(ApiKeys.payfortTokenizationStg),body: htmlRequest);

    // var document = parse(loginPage.body);
    // var username = document.querySelector('#username') as InputElement;
    // var password = document.querySelector('#password') as InputElement;
    // username.value = 'USERNAME';
    // password.value = 'PASSWORD';
    // var submit = document.querySelector('.btn-submit') as ButtonElement;
    // submit.click();
    // var request = http.MultipartRequest('POST',
    //     Uri.parse('https://sbcheckout.PayFort.com/FortAPI/paymentPage'));
    // request.fields.addAll({
    //   "service_command": "TOKENIZATION",
    //   "access_code": "stv40N9RCK9hK4YRsPME",
    //   "merchant_identifier": "6be25812",
    //   "merchant_reference": "XYZ9239-yu898",
    //   "language": "en",
    //   "expiry_date": "2408",
    //   "card_number": "4005550000000001",
    //   "card_security_code": "123",
    //   "signature": "\$2y\$10\$rvaQyZlrW",
    //   "return_url": "https://www.merchant.com"
    // });

    // request.headers.addAll(headers);

    // http.StreamedResponse response = await request.send();

    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    // } else {
    //   print("error" + response.reasonPhrase!);
    //   print("error " + response.statusCode.toString());
    // }
    // try {
    //   // await BaseApi.updateHeader();
    //   // FormData formData = FormData.fromMap({
    //   //   "uploadedfile": await MultipartFile.fromFile(imagPath),
    //   // });
    //   Map body = {
    //     'service_command': 'TOKENIZATION',
    //     'access_code': 'stv40N9RCK9hK4YRsPME',
    //     'merchant_identifier': '6be25812',
    //     'merchant_reference': 'XYZ9239-yu898',
    //     'language': 'en',
    //     'expiry_date': '2408',
    //     'card_number': '4005550000000001',
    //     'card_security_code': '123',
    //     'signature': "\$2y\$10\$rvaQyZlrW",
    //     'return_url' : "https://www.merchant.com"
    //   };
    //
    //   final response = await BaseApi.dio.post(ApiKeys.payfortTokenizationStg,
    //       data: body,options: Options(headers: {
    //         'Cookie': 'JSESSIONID=DGWtVJsWcXc-iUwxJ_k6Hkekh7957HdyeHRu0PAh.ip-10-50-212-21; tkn1=117227y4BnFBum1I4G0rR5aScLbWns; tkn2=21130ZhXJfpqSZS80tvsDF8pIYpwJl'
    //       }));
    //   // print(response.data.toString());
    //   // CreditCard wrapper = CreditCard.fromJson(response.data);
    //   // if (wrapper.errorCode == 0) {
    //   //   success(wrapper);
    //   // } else {
    //   //   DetailsApiModel details = DetailsApiModel.fromJson(response.data);
    //   //   fail(details);
    //   // }
    // } catch (onError) {
    //   log(onError.toString());
    //   // fail(BaseApi.checkErrorType(onError));
    // }
  }

  static Future<void> changePasswordApi(
      ChangePasswordSendModel changePasswordModel,
      void Function(ChangePassword) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .put(ApiKeys.changePasswordUrl, data: changePasswordModel.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ChangePassword wrapper = ChangePassword.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> therapistBio(
      String id,
      void Function(TherapistBio) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.therapistBioUrl(id));
      TherapistBio wrapper = TherapistBio.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> checkIfCompensatedSession(
      int id,
      void Function(SessionCompensated) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response =
          await BaseApi.dio.get(ApiKeys.checkIfSessionCompensatedUrl(id: id));

      SessionCompensated wrapper = SessionCompensated.fromJson(response.data);

      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> calculateSessionFees(
      int id,
      void Function(CalculateSessionFees) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio
          .get(ApiKeys.calculateSessionCancellationFeesUrl(id: id));

      CalculateSessionFees wrapper =
          CalculateSessionFees.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> cancelSession(
      int id,
      void Function(CancelSession) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio.put(ApiKeys.cancelSessionUrl(id: id)).then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      CancelSession wrapper = CancelSession.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> checkIfCompensatedRescheduleSession(
      int id,
      void Function(SessionCompensated) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response =
          await BaseApi.dio.get(ApiKeys.checkIfSessionCompensatedUrl(id: id));

      SessionCompensated wrapper = SessionCompensated.fromJson(response.data);

      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> calculateSessionRescheduleFees(
      int id,
      void Function(CalculateSessionRescheduleFees) success,
      void Function(NetworkExceptions) fail) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio
          .get(ApiKeys.calculateSessionRescheduleFeesUrl(id: id));

      CalculateSessionRescheduleFees wrapper =
          CalculateSessionRescheduleFees.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> rescheduleSession(
      int id,
      RescheduleSessionSendModel model,
      void Function(RescheduleSession) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .put(ApiKeys.rescheduleSessionUrl(id: id), data: model.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      RescheduleSession wrapper = RescheduleSession.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> bookSession(
      BookSessionSendModel model,
      void Function(BookSession) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .post(ApiKeys.bookSession, data: model.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      BookSession wrapper = BookSession.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> payWithCard(
      CardPaySendModel model,
      void Function(CardPay) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .post(ApiKeys.payWithSavedCard, data: model.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      CardPay wrapper = CardPay.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> paySubscribeWithCard(
      CardPaySubscribeSendModel model,
      void Function(CardPay) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .post(ApiKeys.paySubscribeWithSavedCard, data: model.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      CardPay wrapper = CardPay.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> setAsPreferredCard(
      String code,
      void Function(PreferredCard) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .put(ApiKeys.setAsPreferredCardUrl(code: code))
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      PreferredCard wrapper = PreferredCard.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> deleteCard(String code, void Function(DeleteCard) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .delete(ApiKeys.deleteCardUrl(code: code))
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      DeleteCard wrapper = DeleteCard.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> accumulativeSessionFees(
      void Function(AccumulativeSessionFees) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio.get(ApiKeys.accumulativeSessionFees).then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      AccumulativeSessionFees wrapper =
          AccumulativeSessionFees.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> confirmStatus(
      ConfirmStatusSendModel model,
      Function(ConfirmStatus) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .put(ApiKeys.confirmStatusUrl, data: model.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ConfirmStatus wrapper = ConfirmStatus.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> requestASession(
      String id,
      Function(RequestSession) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio.post(ApiKeys.requestASessionUrl(id: id)).then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      RequestSession wrapper = RequestSession.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> joinWaitList(String id, Function(JoinWaitList) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio.post(ApiKeys.joinWaitListUrl(id: id)).then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      JoinWaitList wrapper = JoinWaitList.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> updateVersion(
      String appVersion,
      String platform,
      void Function(EnforceUpdate) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .get(ApiKeys.enforceUpdateUrl(
            appVersion: appVersion, platform: platform))
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      EnforceUpdate wrapper = EnforceUpdate.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> getMySubscriptions(
      {required void Function(MySubscriptionsWrapper) success,
      required void Function(NetworkExceptions) fail}) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.mySubscriptionsUrl);

      MySubscriptionsWrapper wrapper =
          MySubscriptionsWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> cancelMySubscriptions(
      {required void Function(CancelSubscriptionWrapper) success,
      required void Function(NetworkExceptions) fail}) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.cancelSubscription);

      CancelSubscriptionWrapper wrapper =
          CancelSubscriptionWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }
}
