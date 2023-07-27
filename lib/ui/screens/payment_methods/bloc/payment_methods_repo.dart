import 'dart:async';

import 'package:o7therapy/api/api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/credit_card/CreditCard.dart';
import 'package:o7therapy/api/models/delete_card/DeleteCard.dart';
import 'package:o7therapy/api/models/set_preferred_card/PreferredCard.dart';
import 'package:o7therapy/ui/screens/payment_methods/bloc/payment_methods_bloc.dart';

abstract class BasePaymentMethodsRepo {
  const BasePaymentMethodsRepo();

  Future<PaymentMethodsState> savedCards();
  Future<PaymentMethodsState> setAsPreferred(String code);
  Future<PaymentMethodsState> deleteCard(String code);
}

class PaymentMethodsRepo extends BasePaymentMethodsRepo {
  const PaymentMethodsRepo();

  @override
  Future<PaymentMethodsState> savedCards() async {
    PaymentMethodsState? paymentMethodsState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.creditCards((CreditCard cardsList) async {
        if (cardsList.data!.isEmpty || cardsList.data == null) {
          paymentMethodsState = const PaymentMethodsFail();
        } else {
          paymentMethodsState = PaymentMethodsSuccess(cardsList);
        }
      }, (NetworkExceptions details) {
        detailsModel = details;
        paymentMethodsState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      paymentMethodsState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return paymentMethodsState!;
  }

  @override
  Future<PaymentMethodsState> setAsPreferred(String code) async {
    PaymentMethodsState? paymentMethodsState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.setAsPreferredCard(code,
          (PreferredCard preferredCard) async {
        if (preferredCard.errorCode == 0) {
          paymentMethodsState = const SetAsPreferredSuccess();
        } else {
          paymentMethodsState = const SetAsPreferredFailed();
        }
      }, (NetworkExceptions details) {
        detailsModel = details;
        paymentMethodsState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      paymentMethodsState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return paymentMethodsState!;
  }

  @override
  Future<PaymentMethodsState> deleteCard(String code) async {
    PaymentMethodsState? paymentMethodsState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.deleteCard(code, (DeleteCard card) async {
        if (card.errorCode == 0) {
          paymentMethodsState = const DeleteCardSuccess();
        } else {
          paymentMethodsState = const DeleteCardFail();
        }
      }, (NetworkExceptions details) {
        detailsModel = details;
        paymentMethodsState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      paymentMethodsState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return paymentMethodsState!;
  }
}
