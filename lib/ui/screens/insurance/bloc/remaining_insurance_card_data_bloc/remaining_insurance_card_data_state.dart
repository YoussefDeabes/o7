part of 'remaining_insurance_card_data_bloc.dart';

abstract class RemainingInsuranceCardDataState extends Equatable {
  const RemainingInsuranceCardDataState();

  @override
  List<Object> get props => [];
}

class RemainingInsuranceCardDataInitial
    extends RemainingInsuranceCardDataState {
  const RemainingInsuranceCardDataInitial();
}

class LoadingRemainingInsuranceCardData
    extends RemainingInsuranceCardDataState {
  const LoadingRemainingInsuranceCardData();
}

class LoadedRemainingInsuranceCardData extends RemainingInsuranceCardDataState {
  final VerifiedInsuranceViewDataModel verifiedInsuranceData;
  const LoadedRemainingInsuranceCardData({
    required this.verifiedInsuranceData,
  });
  @override
  List<Object> get props => [verifiedInsuranceData];
}

class ExceptionRemainingInsuranceCardData
    extends RemainingInsuranceCardDataState {
  final String failureMsg;
  const ExceptionRemainingInsuranceCardData({
    required this.failureMsg,
  });
}
