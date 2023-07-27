part of 'insurance_status_bloc.dart';

abstract class InsuranceStatusState extends Equatable {
  const InsuranceStatusState();

  @override
  List<Object> get props => [];
}

class InitInsuranceStatusState extends InsuranceStatusState {
  const InitInsuranceStatusState();

  @override
  List<Object> get props => [];
}

class NoInsuranceStatus extends InsuranceStatusState {
  const NoInsuranceStatus();
}

class VerifiedInsuranceStatus extends InsuranceStatusState {
  const VerifiedInsuranceStatus();
  @override
  List<Object> get props => [];
}

class UnVerifiedInsuranceStatus extends InsuranceStatusState {
  final InsuranceCard insuranceCard;
  const UnVerifiedInsuranceStatus({required this.insuranceCard});

  @override
  List<Object> get props => [insuranceCard];
}

class LoadingInsuranceStatus extends InsuranceStatusState {
  const LoadingInsuranceStatus();
}

class ExceptionInsuranceStatus extends InsuranceStatusState {
  final String failureMsg;
  const ExceptionInsuranceStatus({required this.failureMsg});

  @override
  List<Object> get props => [failureMsg];
}

class SuccessAddedInsuranceCardStatus extends InsuranceStatusState {
  const SuccessAddedInsuranceCardStatus();

  @override
  List<Object> get props => [];
}

class SuccessUpdatedInsuranceCard extends InsuranceStatusState {
  const SuccessUpdatedInsuranceCard();

  @override
  List<Object> get props => [];
}

class SuccessVerifiedInsuranceStatus extends InsuranceStatusState {
  const SuccessVerifiedInsuranceStatus();
  @override
  List<Object> get props => [];
}

class InsuranceDealState extends InsuranceStatusState {
  final InsuranceDeal insuranceDeal;
  final String slotId;
  final String slotDate;

  const InsuranceDealState(this.insuranceDeal, this.slotId, this.slotDate);
}
