part of 'insurance_list_bloc.dart';

abstract class InsuranceListState extends Equatable {
  const InsuranceListState();

  @override
  List<Object> get props => [];
}

class InitialInsuranceListState extends InsuranceListState {
  const InitialInsuranceListState();
}

class LoadingInsuranceListState extends InsuranceListState {
  const LoadingInsuranceListState();
}

class LoadedInsuranceListState extends InsuranceListState {
  final List<ProviderData> insuranceProvidersList;
  const LoadedInsuranceListState({required this.insuranceProvidersList});

  @override
  List<Object> get props => [insuranceProvidersList];
}

class ExceptionInsuranceListState extends InsuranceListState {
  final String message;
  const ExceptionInsuranceListState({required this.message});

  @override
  List<Object> get props => [message];
}
