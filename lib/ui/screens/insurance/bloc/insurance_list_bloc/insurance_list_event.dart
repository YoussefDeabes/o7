part of 'insurance_list_bloc.dart';

abstract class InsuranceListEvent extends Equatable {
  const InsuranceListEvent();

  @override
  List<Object> get props => [];
}

class GetInsuranceListEvent extends InsuranceListEvent {
  const GetInsuranceListEvent();
}
