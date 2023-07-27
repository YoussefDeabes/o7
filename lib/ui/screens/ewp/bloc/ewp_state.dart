part of 'ewp_bloc.dart';

abstract class EwpState extends Equatable {
  const EwpState();

  @override
  List<Object> get props => [];
}

class EwpInitial extends EwpState {}

class DiscountSessionsEwpState extends EwpState {
  final EwpViewModel ewpViewModel;
  const DiscountSessionsEwpState({required this.ewpViewModel});

  @override
  List<Object> get props => [ewpViewModel];
}

class FixedSessionsNumberEwpState extends EwpState {
  final EwpViewModel ewpViewModel;
  const FixedSessionsNumberEwpState({required this.ewpViewModel});

  @override
  List<Object> get props => [ewpViewModel];
}

class NoEwpState extends EwpState {
  const NoEwpState();
}

class LoadingEwpState extends EwpState {
  const LoadingEwpState();
}

class ExceptionEwpState extends EwpState {
  final String msg;
  const ExceptionEwpState({required this.msg});

  @override
  List<Object> get props => [msg];
}
