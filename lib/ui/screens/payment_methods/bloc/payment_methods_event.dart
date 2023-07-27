part of 'payment_methods_bloc.dart';

abstract class PaymentMethodsEvent {}

class PaymentMethodsLoadingEvent extends PaymentMethodsEvent {}

class PaymentMethodsSuccessEvent extends PaymentMethodsEvent {}

class DeleteCardEvt extends PaymentMethodsEvent {
  String code;

  DeleteCardEvt(this.code);
}

class SetAsPreferredEvt extends PaymentMethodsEvent {
  String code;

  SetAsPreferredEvt(this.code);
}

class AddCardEvt extends PaymentMethodsEvent {}
