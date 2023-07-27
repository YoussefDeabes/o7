import 'package:o7therapy/api/api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/promo_code/PromoCode.dart';
import 'package:o7therapy/ui/screens/group_assessment/bloc/group_assessment_promo_code_bloc/group_assessment_promo_code_bloc.dart';

abstract class BaseGroupAssessmentPromoCodeRepo {
  const BaseGroupAssessmentPromoCodeRepo();

  Future<GroupAssessmentPromoCodeState> verifyPromoCode(
    String promoCode,
    String slotId,
  );
}

class GroupAssessmentPromoCodeRepo extends BaseGroupAssessmentPromoCodeRepo {
  const GroupAssessmentPromoCodeRepo();

  @override
  Future<GroupAssessmentPromoCodeState> verifyPromoCode(
    String promoCode,
    String slotId,
  ) async {
    GroupAssessmentPromoCodeState? state;

    try {
      await ApiManager.verifyPromoCode(
        promoCode,
        slotId,
        (PromoCode promoCode) async {
          if (promoCode.data == null) {
            state = const FailedGroupAssessmentPromoCode();
          } else {
            state = VerifiedGroupAssessmentPromoCode(promoCode);
          }
        },
        (NetworkExceptions details) {
          state = ErrorGroupAssessmentState(details.errorMsg!);
        },
      );
    } catch (error) {
      state = const ErrorGroupAssessmentState("");
    }
    return state!;
  }
}
