part of 'phone_masked_number_bloc.dart';

class PhoneMaskedNumberState extends Equatable {
  final String maskedPhoneNumber;
  const PhoneMaskedNumberState(this.maskedPhoneNumber);

  @override
  List<Object> get props => [maskedPhoneNumber];
}
