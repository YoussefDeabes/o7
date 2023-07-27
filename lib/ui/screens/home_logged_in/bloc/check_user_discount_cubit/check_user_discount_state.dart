part of 'check_user_discount_cubit.dart';

abstract class CheckUserDiscountState extends Equatable {
  const CheckUserDiscountState();

  @override
  List<Object> get props => [];
}

class LoadingCheckUserDiscountState extends CheckUserDiscountState {
  const LoadingCheckUserDiscountState();
}

class LoadedUserDiscountState extends CheckUserDiscountState {
  final UserDiscountData userDiscountData;
  const LoadedUserDiscountState(this.userDiscountData);
}

class ExceptionUserDiscountState extends CheckUserDiscountState {
  const ExceptionUserDiscountState();
}
