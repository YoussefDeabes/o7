part of 'checkout_bloc.dart';

@immutable
abstract class CheckoutState {
  const CheckoutState();
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoadingState extends CheckoutState {}

class CheckoutSuccessState extends CheckoutState {}

class CheckoutPromoCodeState extends CheckoutState {}

class VerifiedPromoCode extends CheckoutState {
  bool isVerified;
  PromoCode promoCode;

  VerifiedPromoCode(this.isVerified, this.promoCode);
}

class FailedPromoCode extends CheckoutState {
  final String errorMsg;

  const FailedPromoCode(this.errorMsg);
}

class CreditCardsSuccess extends CheckoutState {
  final CreditCard creditCardsList;

  const CreditCardsSuccess(this.creditCardsList);
}

class FailedCreditCards extends CheckoutState {
  const FailedCreditCards();
}

class LoadingPayfortTokenization extends CheckoutState {
  const LoadingPayfortTokenization();
}

class PayfortTokenizationSuccess extends CheckoutState {
  const PayfortTokenizationSuccess();
}

class PayfortTokenizationFail extends CheckoutState {
  const PayfortTokenizationFail();
}

class AddCardState extends CheckoutState {
  final String userIp;
  final String userId;
  final String countryCode;
  final String userToken;

  const AddCardState(
      {required this.userIp, required this.userId, required this.userToken,required this.countryCode});
}

class DeleteCardSuccess extends CheckoutState {
  final DeleteCard deletedCard;

  const DeleteCardSuccess(this.deletedCard);
}

class SuccessPaymentScreenState extends CheckoutState {
  const SuccessPaymentScreenState();
}

class BookSessionSuccess extends CheckoutState {
  final BookSession bookSession;
  final String token;
  final String ip;

  const BookSessionSuccess(this.bookSession, this.token, this.ip);
}
class SubscribeRasselSuccess extends CheckoutState {
  final Subscribe subscribe;
  final String token;
  final String ip;
  final String userId;
  final String countryCode;

  const SubscribeRasselSuccess(this.subscribe, this.token, this.ip,this.countryCode,this.userId);
}
class RescheduleSessionSuccess extends CheckoutState {
  final RescheduleSession rescheduleSession;
  final String token;
  final String ip;

  const RescheduleSessionSuccess(this.rescheduleSession, this.token, this.ip);
}

class RescheduleSessionWithCardSuccess extends CheckoutState {
  final RescheduleSession rescheduleSession;
  final String token;
  final String ip;

  const RescheduleSessionWithCardSuccess(this.rescheduleSession, this.token, this.ip);
}

class PayInDebt extends CheckoutState {
  final String userIp;
  final String userId;
  final String userToken;

  const PayInDebt(
      {required this.userIp, required this.userId, required this.userToken});
}

class ConfirmSessionSuccess extends CheckoutState {
  final BookSession bookSession;
  final String token;
  final String ip;

  const ConfirmSessionSuccess(this.bookSession, this.token, this.ip);
}

class BookSessionWithSavedCardSuccess extends CheckoutState {
  final BookSession bookSession;
  final String token;
  final String ip;

  const BookSessionWithSavedCardSuccess(this.bookSession, this.token, this.ip);
}

class RescheduleSessionWithSavedCardSuccess extends CheckoutState {
  final RescheduleSession rescheduleSession;
  final String token;
  final String ip;

  const RescheduleSessionWithSavedCardSuccess(
      this.rescheduleSession, this.token, this.ip);
}

class PayWithSavedCardSuccess extends CheckoutState {
  final dynamic data;

  const PayWithSavedCardSuccess(this.data);
}

class PayWithSavedCardFailed extends CheckoutState {
  final String message;

  const PayWithSavedCardFailed(this.message);
}

class PaySubscribeWithSavedCardSuccess extends CheckoutState {
  final dynamic data;

  const PaySubscribeWithSavedCardSuccess(this.data);
}

class PaySubscribeWithSavedCardFailed extends CheckoutState {
  final String message;

  const PaySubscribeWithSavedCardFailed(this.message);
}

class RasselSubscribeState extends CheckoutState {
  Subscribe subscribe;
  final String token;
  final String ip;

  RasselSubscribeState(this.subscribe,this.token,this.ip);
}

class NetworkError extends CheckoutState {
  final String message;
  final int errorCode;

  const NetworkError(this.message,this.errorCode);
}

class ErrorState extends CheckoutState {
  final String message;

  const ErrorState(this.message);
}
