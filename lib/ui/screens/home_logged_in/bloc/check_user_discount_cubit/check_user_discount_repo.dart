import 'package:o7therapy/api/api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/user_discounts/UserDiscounts.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/check_user_discount_cubit/check_user_discount_cubit.dart';
import 'package:o7therapy/ui/screens/home_logged_in/models/user_discount_data.dart';

abstract class BaseCheckUserDiscountRepository {
  const BaseCheckUserDiscountRepository();
  Future<CheckUserDiscountState> checkUserDiscount();
}

class CheckUserDiscountRepository extends BaseCheckUserDiscountRepository {
  const CheckUserDiscountRepository();

  @override
  Future<CheckUserDiscountState> checkUserDiscount() async {
    CheckUserDiscountState? state;
    try {
      await ApiManager.checkUserDiscounts(
        (UserDiscounts wrapper) {
          state = LoadedUserDiscountState(
            UserDiscountData.fromBackEndDataModel(wrapper.data!),
          );
        },
        (NetworkExceptions details) {
          state = const ExceptionUserDiscountState();
        },
      );
    } catch (error) {
      state = const ExceptionUserDiscountState();
    }
    return state!;
  }
}
