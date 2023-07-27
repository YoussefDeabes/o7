part of 'payment_methods_bloc.dart';

abstract class PaymentMethodsState {
  const PaymentMethodsState();
}

class PaymentMethodsInitial extends PaymentMethodsState {}

class PaymentMethodsLoadingState extends PaymentMethodsState {}

class PaymentMethodsSuccess extends PaymentMethodsState {
  final CreditCard creditCardsList;

  const PaymentMethodsSuccess(this.creditCardsList);
}

class PaymentMethodsFail extends PaymentMethodsState {
  const PaymentMethodsFail();
}

class SetAsPreferredSuccess extends PaymentMethodsState {
  const SetAsPreferredSuccess();
}

class SetAsPreferredFailed extends PaymentMethodsState {
  const SetAsPreferredFailed();
}

class DeleteCardSuccess extends PaymentMethodsState {
  const DeleteCardSuccess();
}

class AddCardState extends PaymentMethodsState {
  final String userIp;
  final String userId;
  final String countryCode;
  final String userToken;

  AddCardState(
      {required this.userIp, required this.userId, required this.userToken,required this.countryCode});
}

class DeleteCardFail extends PaymentMethodsState {
  const DeleteCardFail();
}

class NetworkError extends PaymentMethodsState {
  final String message;

  const NetworkError(this.message);
}

class ErrorState extends PaymentMethodsState {
  final String message;

  const ErrorState(this.message);
}
