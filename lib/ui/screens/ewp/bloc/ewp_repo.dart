import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/ewp_api_manager.dart';
import 'package:o7therapy/api/models/booking/verify_user_is_corporate/verify_user_is_corporate_wrapper.dart';
import 'package:o7therapy/api/models/ewp/ewp_remaining_cap_no_wrapper.dart';
import 'package:o7therapy/api/therapist_list_api_manager.dart';
import 'package:o7therapy/ui/screens/ewp/models/ewp_view_model.dart';

import 'ewp_bloc.dart';

abstract class BaseEwpRepository {
  const BaseEwpRepository();

  Future<EwpState> getRemainingCapNoForEwp();

  Future<EwpState?> checkUserIsCorporate();
}

class EwpRepository extends BaseEwpRepository {
  const EwpRepository();

  @override
  Future<EwpState?> checkUserIsCorporate() async {
    late EwpState? state;
    try {
      await TherapistListApiManager.verifyUserIsCorporateApi(
        (VerifyUserIsCorporateWrapper wrapper) {
          if (wrapper.data == null || wrapper.data == false) {
            state = const NoEwpState();
          } else {
            state = null;
          }
        },
        (NetworkExceptions details) {
          state = ExceptionEwpState(
              msg: details.errorMsg ?? "Oops... Something went wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionEwpState(msg: "Oops... Something went wrong!");
    }
    return state;
  }

  @override
  Future<EwpState> getRemainingCapNoForEwp() async {
    EwpState? state;
    try {
      await EwpApiManager.getRemainingCapNoForEwpApi(
        success: (EwpRemainingCapNoWrapper wrapper) async {
          if (wrapper.data == null) {
            state = const NoEwpState();
          } else {
            EwpViewModel ewpViewModel =
                EwpViewModel.fromEwpRemainingCapNoWrapper(wrapper);
            if (ewpViewModel.orginalCap == null ||
                ewpViewModel.remainingCap == null) {
              state = DiscountSessionsEwpState(ewpViewModel: ewpViewModel);
            } else {
              state = FixedSessionsNumberEwpState(ewpViewModel: ewpViewModel);
            }
          }
        },
        fail: (NetworkExceptions details) {
          state = ExceptionEwpState(
              msg: details.errorMsg ?? "Oops.. Something went Wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionEwpState(msg: "Oops.. Something went Wrong!");
    }
    return state!;
  }
}
