import 'dart:async';
import 'dart:developer';

import 'package:o7therapy/api/api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/accumulative_session_fees/AccumulativeSessionFees.dart';
import 'package:o7therapy/api/models/available_slots/AvailableSlotsWrapper.dart';
import 'package:o7therapy/api/models/client_indebt/ClientInDebtWrapper.dart';
import 'package:o7therapy/api/models/corporate_deal/CorporateDeal.dart';
import 'package:o7therapy/api/models/flat_rate/FlatRateWrapper.dart';
import 'package:o7therapy/api/models/insurance_deal/InsuranceDeal.dart';
import 'package:o7therapy/api/models/join_wait_list/JoinWaitList.dart';
import 'package:o7therapy/api/models/request_session/RequestSession.dart';
import 'package:o7therapy/api/models/therapist_bio/TherapistBio.dart';
import 'package:o7therapy/api/models/user_discounts/UserDiscounts.dart';
import 'package:o7therapy/api/models/verify_wallet_sessions/VerifyWalletSessions.dart';
import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/ui/screens/therapist_profile/bloc/therapist_profile_bloc.dart';

abstract class BaseTherapistProfileRepo {
  const BaseTherapistProfileRepo();

  // Future<TherapistProfileState> getTherapistProfile();

  Future<TherapistProfileState> checkUserDiscounts(
      String slotId, String slotDate);

  Future<TherapistProfileState> bookingChecks(String slotId, String slotDate);

  Future<TherapistProfileState> hasSessionsWallet(
      String slotId, String slotDate);

  Future<TherapistProfileState> hasInsuranceFlatRate(
      String slotId, String slotDate);

  Future<TherapistProfileState> isCorporate(String slotId, String slotDate);

  Future<TherapistProfileState> isInsurance(String slotId, String slotDate);

  Future<TherapistProfileState> requestASession(String id);

  Future<TherapistProfileState> joinWaitList(String id);

  Future<TherapistProfileState> accumulativeSessionFees();

  Future<ServicesModel> getTherapistServices();

  Future<List<ReviewModel>> getTherapistReviews();

  Future<List<VideosModel>> getTherapistVideos();

  Future<List<BlogsModel>> getTherapistBlogs();
}

class TherapistProfileRepo extends BaseTherapistProfileRepo {
  const TherapistProfileRepo();

  @override
  Future<TherapistProfileState> checkUserDiscounts(
      String slotId, String slotDate) async {
    TherapistProfileState? therapistProfileState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.checkUserDiscountsQuery(slotId,
          (UserDiscounts user) async {
        therapistProfileState = ClientDiscountsState(user, slotId, slotDate);
      }, (NetworkExceptions details) {
        detailsModel = details;
        therapistProfileState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      therapistProfileState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return therapistProfileState!;
  }

  @override
  Future<TherapistProfileState> bookingChecks(
      String slotId, String slotDate) async {
    TherapistProfileState? therapistProfileState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.checkClientInDebt((ClientInDebtWrapper inDebt) async {
        if (inDebt.data == true) {
          therapistProfileState = ClientInDebtState(inDebt, slotDate, slotId);
        } else {
          therapistProfileState = FailClientInDebtState(slotDate, slotId);
        }
      }, (NetworkExceptions details) {
        detailsModel = details;
        therapistProfileState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      therapistProfileState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return therapistProfileState!;
  }

  @override
  Future<TherapistProfileState> accumulativeSessionFees() async {
    TherapistProfileState? therapistProfileState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.accumulativeSessionFees(
          (AccumulativeSessionFees accSessionFees) async {
        therapistProfileState = AccumulativeSessionFeesState(accSessionFees);
      }, (NetworkExceptions details) {
        detailsModel = details;
        therapistProfileState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      therapistProfileState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return therapistProfileState!;
  }

  @override
  Future<TherapistProfileState> hasSessionsWallet(
      String slotId, String slotDate) async {
    TherapistProfileState? therapistProfileState;
    NetworkExceptions? detailsModel;

    try {
      await ApiManager.hasWalletSessions(slotId,
          (VerifyWalletSessions hasWalletSessions) async {
        if (hasWalletSessions.data == true) {
          therapistProfileState =
              HasWalletSessionsState(hasWalletSessions, slotDate, slotId);
        } else {
          therapistProfileState = FailHasWalletSessionsState(slotDate, slotId);
        }
      }, (NetworkExceptions details) {
        detailsModel = details;
        therapistProfileState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      therapistProfileState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return therapistProfileState!;
  }

  @override
  Future<TherapistProfileState> hasInsuranceFlatRate(
      String slotId, String slotDate) async {
    TherapistProfileState? therapistProfileState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.checkFlatRateInsurance(
          (FlatRateWrapper insuranceFlatRate) async {
        if (insuranceFlatRate.data == true) {
          therapistProfileState = InsuranceFlatRateState(slotId, slotDate);
        } else {
          therapistProfileState = FailInsuranceFlatRateState(slotDate, slotId);
        }
      }, (NetworkExceptions details) {
        detailsModel = details;
        therapistProfileState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      therapistProfileState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return therapistProfileState!;
  }

  @override
  Future<TherapistProfileState> isCorporate(
      String slotId, String slotDate) async {
    TherapistProfileState? therapistProfileState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.verifyCorporateDeal(slotId,
          (CorporateDeal isCorporate) async {
        if (isCorporate.data?.flatRate == true) {
          therapistProfileState = CorporateFlatRateState(slotId, slotDate);
        } else {
          therapistProfileState = CorporateState(isCorporate, slotId, slotDate);
        }
      }, (NetworkExceptions details) {
        detailsModel = details;
        therapistProfileState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      therapistProfileState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }

    return therapistProfileState!;
  }

  @override
  Future<TherapistProfileState> isInsurance(
      String slotId, String slotDate) async {
    TherapistProfileState? therapistProfileState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.verifyInsuranceDeal(slotId, (InsuranceDeal isInsurance) {
        therapistProfileState = InsuranceState(isInsurance, slotId, slotDate);
      }, (NetworkExceptions details) {
        detailsModel = details;
        therapistProfileState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      therapistProfileState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return therapistProfileState!;
  }

  // @override
  // Future<TherapistProfileState> getTherapistBio(String id) async {
  //   TherapistProfileState? therapistProfileState;
  //   NetworkExceptions? detailsModel;
  //   try {
  //     await ApiManager.therapistBio(id, (TherapistBio bio) {
  //       therapistProfileState = BioState(bio: bio);
  //     }, (NetworkExceptions details) {
  //       detailsModel = details;
  //       therapistProfileState = NetworkError(details.errorMsg!);
  //     });
  //   } catch (error) {
  //     therapistProfileState =
  //         ErrorState(detailsModel?.errorMsg ?? error.toString());
  //   }
  //   return therapistProfileState!;
  // }

  @override
  Future<TherapistProfileState> requestASession(String id) async {
    TherapistProfileState? therapistProfileState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.requestASession(id, (RequestSession request) {
        therapistProfileState = const RequestASessionState();
      }, (NetworkExceptions details) {
        detailsModel = details;
        therapistProfileState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      therapistProfileState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return therapistProfileState!;
  }

  @override
  Future<TherapistProfileState> joinWaitList(String id) async {
    TherapistProfileState? therapistProfileState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.joinWaitList(id, (JoinWaitList joinWaitList) {
        therapistProfileState = const JoinWaitListState();
      }, (NetworkExceptions details) {
        detailsModel = details;
        therapistProfileState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      therapistProfileState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return therapistProfileState!;
  }

  @override
  Future<ServicesModel> getTherapistServices() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      return servicesModel;
    } catch (error) {
      log("catch", error: error);
      rethrow;
    }
  }

  @override
  Future<List<ReviewModel>> getTherapistReviews() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      return reviews;
    } catch (error) {
      log("catch", error: error);
      rethrow;
    }
  }

  @override
  Future<List<VideosModel>> getTherapistVideos() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      return videos;
    } catch (error) {
      log("catch", error: error);
      rethrow;
    }
  }

  @override
  Future<List<BlogsModel>> getTherapistBlogs() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      return blogs;
    } catch (error) {
      log("catch", error: error);
      rethrow;
    }
  }
}
