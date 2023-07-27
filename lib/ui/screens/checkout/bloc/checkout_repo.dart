import 'dart:async';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:o7therapy/api/api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/book_session/BookSession.dart';
import 'package:o7therapy/api/models/book_session/book_session_send_model.dart';
import 'package:o7therapy/api/models/card_pay/CardPay.dart';
import 'package:o7therapy/api/models/card_pay/card_pay_send_model.dart';
import 'package:o7therapy/api/models/card_pay/card_pay_subscribe_send_model.dart';
import 'package:o7therapy/api/models/credit_card/CreditCard.dart';
import 'package:o7therapy/api/models/delete_card/DeleteCard.dart';
import 'package:o7therapy/api/models/promo_code/PromoCode.dart';
import 'package:o7therapy/api/models/reschedule_session/RescheduleSession.dart';
import 'package:o7therapy/api/models/reschedule_session/reschedule_session_send_model.dart';
import 'package:o7therapy/api/models/subscribe/Subscribe.dart';
import 'package:o7therapy/api/models/subscription_send_model/subscribe_send_model.dart';
import 'package:o7therapy/api/rassel_api_manager.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/ui/screens/checkout/bloc/checkout_bloc.dart';

abstract class BaseCheckoutRepo {
  const BaseCheckoutRepo();

  Future<CheckoutState> verifyPromoCode(String promoCode, String slotId);

  Future<CheckoutState> bookSession(BookSessionSendModel model);

  Future<CheckoutState> subscribeRassel(SubscribeSendModel model);

  Future<CheckoutState> rescheduleSession(
      int id, RescheduleSessionSendModel model);

  Future<CheckoutState> rescheduleSessionWithCard(
      int id, RescheduleSessionSendModel model);

  Future<CheckoutState> confirmSession(BookSessionSendModel model);

  Future<CheckoutState> payWithCard(CardPaySendModel model);

  Future<CheckoutState> paySubscribeWithCard(CardPaySubscribeSendModel model);

  Future<CheckoutState> bookSessionWithSavedCard(BookSessionSendModel model);

  Future<CheckoutState> subscribeRasselWithSavedCard(SubscribeSendModel model);

  Future<CheckoutState> rescheduleSessionWithSavedCard(
      String slotId, RescheduleSessionSendModel model);

  Future<CheckoutState> savedCards();

  Future<CheckoutState> deleteCard(String code);
}

class CheckoutRepo extends BaseCheckoutRepo {
  const CheckoutRepo();

  @override
  Future<CheckoutState> verifyPromoCode(String promoCode, String slotId) async {
    CheckoutState? checkoutState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.verifyPromoCode(promoCode, slotId,
          (PromoCode promoCode) async {
        if (promoCode.data == null) {
          checkoutState =  FailedPromoCode(promoCode.errorMsg??"");
        } else {
          checkoutState = VerifiedPromoCode(true, promoCode);
        }
      }, (NetworkExceptions details) {
        detailsModel = details;
        checkoutState = NetworkError(details.errorMsg!,details.errorCode!);
      });
    } catch (error) {
      checkoutState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return checkoutState!;
  }

  @override
  Future<CheckoutState> savedCards() async {
    CheckoutState? checkoutState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.creditCards((CreditCard cardsList) async {
        if (cardsList.data!.isEmpty || cardsList.data == null) {
          checkoutState = const FailedCreditCards();
        } else {
          checkoutState = CreditCardsSuccess(cardsList);
        }
      }, (NetworkExceptions details) {
        detailsModel = details;
        checkoutState = NetworkError(details.errorMsg!,details.errorCode!);
      });
    } catch (error) {
      checkoutState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return checkoutState!;
  }

  @override
  Future<CheckoutState> bookSession(BookSessionSendModel model) async {
    CheckoutState? checkoutState;
    NetworkExceptions? detailsModel;
    final token = await PrefManager.getToken();
    final ipv4 = await Ipify.ipv4();
    try {
      await ApiManager.bookSession(model, (BookSession bookSession) {
        checkoutState = BookSessionSuccess(bookSession, token!, ipv4);
      }, (NetworkExceptions details) {
        detailsModel = details;
        checkoutState = NetworkError(details.errorMsg!,details.errorCode!);
      });
    } catch (error) {
      checkoutState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return checkoutState!;
  }

  @override
  Future<CheckoutState> subscribeRassel(SubscribeSendModel model) async {
    CheckoutState? checkoutState;
    NetworkExceptions? detailsModel;
    final token = await PrefManager.getToken();
    final ipv4 = await Ipify.ipv4();
    String? id = await PrefManager.getId();
    String? countryCode = await PrefManager.getCountryCode();
    try {
      await RasselApiManager.subscribe(model: model, (Subscribe subscribe) {
        checkoutState =
            SubscribeRasselSuccess(subscribe, token!, ipv4, countryCode!, id!);
      }, (NetworkExceptions details) {
        detailsModel = details;
        checkoutState = NetworkError(details.errorMsg!,details.errorCode!);
      });
    } catch (error) {
      checkoutState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return checkoutState!;
  }

  @override
  Future<CheckoutState> rescheduleSession(
      int id, RescheduleSessionSendModel model) async {
    CheckoutState? checkoutState;
    NetworkExceptions? detailsModel;
    final token = await PrefManager.getToken();
    final ipv4 = await Ipify.ipv4();
    try {
      await ApiManager.rescheduleSession(id, model,
          (RescheduleSession rescheduleSession) {
        checkoutState =
            RescheduleSessionSuccess(rescheduleSession, token!, ipv4);
      }, (NetworkExceptions details) {
        detailsModel = details;
        checkoutState = NetworkError(details.errorMsg!,details.errorCode!);
      });
    } catch (error) {
      checkoutState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return checkoutState!;
  }

  @override
  Future<CheckoutState> rescheduleSessionWithCard(
      int id, RescheduleSessionSendModel model) async {
    CheckoutState? checkoutState;
    NetworkExceptions? detailsModel;
    final token = await PrefManager.getToken();
    final ipv4 = await Ipify.ipv4();
    try {
      await ApiManager.rescheduleSession(id, model,
          (RescheduleSession rescheduleSession) {
        checkoutState =
            RescheduleSessionWithCardSuccess(rescheduleSession, token!, ipv4);
      }, (NetworkExceptions details) {
        detailsModel = details;
        checkoutState = NetworkError(details.errorMsg!,details.errorCode!);
      });
    } catch (error) {
      checkoutState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return checkoutState!;
  }

  @override
  Future<CheckoutState> confirmSession(BookSessionSendModel model) async {
    CheckoutState? checkoutState;
    NetworkExceptions? detailsModel;
    final token = await PrefManager.getToken();
    final ipv4 = await Ipify.ipv4();
    print(ipv4);
    try {
      await ApiManager.bookSession(model, (BookSession bookSession) {
        checkoutState = ConfirmSessionSuccess(bookSession, token!, ipv4);
      }, (NetworkExceptions details) {
        detailsModel = details;
        checkoutState = NetworkError(details.errorMsg!,details.errorCode!);
      });
    } catch (error) {
      checkoutState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return checkoutState!;
  }

  @override
  Future<CheckoutState> bookSessionWithSavedCard(
      BookSessionSendModel model) async {
    CheckoutState? checkoutState;
    NetworkExceptions? detailsModel;
    final token = await PrefManager.getToken();
    final ipv4 = await Ipify.ipv4();
    try {
      await ApiManager.bookSession(model, (BookSession bookSession) {
        checkoutState =
            BookSessionWithSavedCardSuccess(bookSession, token!, ipv4);
      }, (NetworkExceptions details) {
        detailsModel = details;
        checkoutState = NetworkError(details.errorMsg!,details.errorCode!);
      });
    } catch (error) {
      checkoutState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return checkoutState!;
  }

  @override
  Future<CheckoutState> subscribeRasselWithSavedCard(
      SubscribeSendModel model) async {
    CheckoutState? checkoutState;
    NetworkExceptions? detailsModel;
    final token = await PrefManager.getToken();
    final ipv4 = await Ipify.ipv4();
    try {
      await RasselApiManager.subscribe(model: model, (Subscribe subscribe) {
        checkoutState = RasselSubscribeState(subscribe,token!,ipv4);
      }, (NetworkExceptions details) {
        detailsModel = details;
        checkoutState = NetworkError(details.errorMsg!,details.errorCode!);
      });
    } catch (error) {
      checkoutState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return checkoutState!;
  }

  @override
  Future<CheckoutState> rescheduleSessionWithSavedCard(
      String slotId, RescheduleSessionSendModel model) async {
    CheckoutState? checkoutState;
    NetworkExceptions? detailsModel;
    final token = await PrefManager.getToken();
    final ipv4 = await Ipify.ipv4();
    try {
      await ApiManager.rescheduleSession(int.parse(slotId), model,
          (RescheduleSession rescheduleSession) {
        checkoutState = RescheduleSessionWithSavedCardSuccess(
            rescheduleSession, token!, ipv4);
      }, (NetworkExceptions details) {
        detailsModel = details;
        checkoutState = NetworkError(details.errorMsg!,details.errorCode!);
      });
    } catch (error) {
      checkoutState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return checkoutState!;
  }

  @override
  Future<CheckoutState> payWithCard(CardPaySendModel model) async {
    CheckoutState? checkoutState;
    NetworkExceptions? detailsModel;
    final token = await PrefManager.getToken();
    final ipv4 = await Ipify.ipv4();
    try {
      await ApiManager.payWithCard(model, (CardPay data) {
        checkoutState = PayWithSavedCardSuccess(data);
      }, (NetworkExceptions details) {
        detailsModel = details;
        checkoutState = PayWithSavedCardFailed(details.errorMsg!);
        // checkoutState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      checkoutState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return checkoutState!;
  }

  @override
  Future<CheckoutState> paySubscribeWithCard(
      CardPaySubscribeSendModel model) async {
    CheckoutState? checkoutState;
    NetworkExceptions? detailsModel;
    final token = await PrefManager.getToken();
    final ipv4 = await Ipify.ipv4();
    try {
      await ApiManager.paySubscribeWithCard(model, (CardPay data) {
        checkoutState = PaySubscribeWithSavedCardSuccess(data);
      }, (NetworkExceptions details) {
        detailsModel = details;
        checkoutState = PaySubscribeWithSavedCardFailed(details.errorMsg!);
        // checkoutState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      checkoutState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return checkoutState!;
  }

  @override
  Future<CheckoutState> deleteCard(String code) async {
    CheckoutState? checkoutState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.deleteCard(code, (DeleteCard card) async {
        checkoutState = DeleteCardSuccess(card);
      }, (NetworkExceptions details) {
        detailsModel = details;
        checkoutState = NetworkError(details.errorMsg!,details.errorCode!);
      });
    } catch (error) {
      checkoutState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return checkoutState!;
  }
}
