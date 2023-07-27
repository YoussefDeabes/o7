part of 'checkout_bloc.dart';

@immutable
abstract class CheckoutEvent {}

class CheckoutLoadingEvent extends CheckoutEvent {}

class CheckoutSuccessEvent extends CheckoutEvent {}

class CheckoutPromoCodeEvent extends CheckoutEvent {
  String promoCode;
  String slotId;

  CheckoutPromoCodeEvent(this.promoCode, this.slotId);
}

class PayNowEvent extends CheckoutEvent {
  final String promoCode;
  final String slotId;
  final double sessionFees;
  final bool isWallet;

  PayNowEvent(this.promoCode, this.slotId, this.sessionFees, this.isWallet);
}

class PayNowRasselSubscribeEvent extends CheckoutEvent {
  final int clientSubscriptionId;
  final int currency;
  final int clientType;

  PayNowRasselSubscribeEvent({required this.clientSubscriptionId,required this.currency,required this.clientType});
}

class PayNowRescheduleEvent extends CheckoutEvent {
  final int slotId;
  final String sessionId;

  PayNowRescheduleEvent(this.slotId, this.sessionId);
}

class PayInDebtEvent extends CheckoutEvent {
  PayInDebtEvent();
}

class ConfirmSessionEvent extends CheckoutEvent {
  final String promoCode;
  final String slotId;
  final double sessionFees;
  final bool isWallet;

  ConfirmSessionEvent(
      this.promoCode, this.slotId, this.sessionFees, this.isWallet);
}

class BookSessionWithSavedCardEvent extends CheckoutEvent {
  final String promoCode;
  final String slotId;
  final double sessionFees;
  final bool isWallet;

  BookSessionWithSavedCardEvent(
      this.promoCode, this.slotId, this.sessionFees, this.isWallet);
}

class SubscribeRasselWithSavedCardEvent extends CheckoutEvent {
  SubscribeSendModel model;

  SubscribeRasselWithSavedCardEvent(this.model);
}

class RescheduleSessionWithSavedCardEvent extends CheckoutEvent {
  final CardPaySendModel model;
  final String sessionId;
  final int slotId;

  RescheduleSessionWithSavedCardEvent(this.model, this.sessionId, this.slotId);
}

class PayNowWithSavedCardEvent extends CheckoutEvent {
  final CardPaySendModel model;

  PayNowWithSavedCardEvent(this.model);
}

class PayNowIndebtWithSavedCardEvent extends CheckoutEvent {
  final CardPaySendModel model;

  PayNowIndebtWithSavedCardEvent(this.model);
}
class PayNowSubscribeWithSavedCardEvent extends CheckoutEvent {
  final CardPaySubscribeSendModel model;

  PayNowSubscribeWithSavedCardEvent(this.model);
}
class PayNowWithSavedCardRescheduleEvent extends CheckoutEvent {
  final CardPaySendModel model;

  PayNowWithSavedCardRescheduleEvent(this.model);
}

class PayNowRescheduleWithSavedCardEvent extends CheckoutEvent {
  final CardPaySendModel model;

  PayNowRescheduleWithSavedCardEvent(this.model);
}

class CheckoutCreditCardEvent extends CheckoutEvent {
  CheckoutCreditCardEvent();
}

class AddCardEvent extends CheckoutEvent {
  AddCardEvent();
}

class DeleteCardEvent extends CheckoutEvent {
  final String code;

  DeleteCardEvent(this.code);
}

class SuccessPaymentScreenEvent extends CheckoutEvent {
  SuccessPaymentScreenEvent();
}
