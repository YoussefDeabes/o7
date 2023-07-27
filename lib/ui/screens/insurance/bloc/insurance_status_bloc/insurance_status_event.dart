part of 'insurance_status_bloc.dart';

abstract class InsuranceStatusEvent extends Equatable {
  const InsuranceStatusEvent();

  @override
  List<Object> get props => [];
}

class GetInsuranceStatusEvent extends InsuranceStatusEvent {
  const GetInsuranceStatusEvent();

  @override
  List<Object> get props => [];
}

class ValidateOtpInsuranceStatusEvent extends InsuranceStatusEvent {
  const ValidateOtpInsuranceStatusEvent({
    required this.otp,
    required this.cardNumber,
  });
  final String otp;
  final String cardNumber;
  @override
  List<Object> get props => [];
}

class AddNewInsuranceEvent extends InsuranceStatusEvent {
  final PageTwoInsuranceDataModel addNewInsuranceDataModel;
  const AddNewInsuranceEvent({required this.addNewInsuranceDataModel});

  @override
  List<Object> get props => [addNewInsuranceDataModel];
}

class DeleteInsuranceEvent extends InsuranceStatusEvent {
  final int cardId;
  const DeleteInsuranceEvent({required this.cardId});

  @override
  List<Object> get props => [cardId];
}

class UpdateInsuranceCardEvent extends InsuranceStatusEvent {
  final UpdateInsuranceCardParams params;
  const UpdateInsuranceCardEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class GetInsuranceDealEvent extends InsuranceStatusEvent {
  final String availableSlotId;
  final String slotDate;
  const GetInsuranceDealEvent({
    required this.availableSlotId,
    required this.slotDate,
  });

  @override
  List<Object> get props => [availableSlotId, slotDate];
}
