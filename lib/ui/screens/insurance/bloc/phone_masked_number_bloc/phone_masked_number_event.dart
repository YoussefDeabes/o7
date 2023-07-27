part of 'phone_masked_number_bloc.dart';

class GetPhoneMaskedNumberEvent extends Equatable {
  final String cardNumber;
  const GetPhoneMaskedNumberEvent(this.cardNumber);

  @override
  List<Object> get props => [cardNumber];
}
