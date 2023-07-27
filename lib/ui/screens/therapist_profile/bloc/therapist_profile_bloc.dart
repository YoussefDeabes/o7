import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:o7therapy/api/models/accumulative_session_fees/AccumulativeSessionFees.dart';
import 'package:o7therapy/api/models/available_slots/AvailableSlotsWrapper.dart';
import 'package:o7therapy/api/models/client_indebt/ClientInDebtWrapper.dart';
import 'package:o7therapy/api/models/corporate_deal/CorporateDeal.dart';
import 'package:o7therapy/api/models/has_wallet_sessions/HasWalletSessions.dart';
import 'package:o7therapy/api/models/insurance_deal/InsuranceDeal.dart';
import 'package:o7therapy/api/models/therapist_bio/TherapistBio.dart';
import 'package:o7therapy/api/models/user_discounts/UserDiscounts.dart';
import 'package:o7therapy/api/models/verify_wallet_sessions/VerifyWalletSessions.dart';
import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/ui/screens/therapist_profile/bloc/therapist_profile_repo.dart';
import 'package:o7therapy/ui/screens/therapist_profile/widgets/profile_category.dart';

part 'therapist_profile_event.dart';

part 'therapist_profile_state.dart';

class TherapistProfileBloc
    extends Bloc<TherapistProfileEvent, TherapistProfileState> {
  final BaseTherapistProfileRepo _baseRepo;

  TherapistProfileBloc(this._baseRepo)
      : super(const TherapistProfileInitial()) {
    on<BookASessionClicked>(_onBookASessionSelected);
    on<CheckHasSessions>(_onCheckHasSessionsSelected);
    on<CheckHasInsuranceFlatRate>(_onCheckHasInsuranceSelected);
    on<CheckIsCorporate>(_onCheckIsCorporateSelected);
    on<CheckIsInsurance>(_onCheckIsInsuranceSelected);
    on<AccumulativeSessionFeesEvent>(_onAccumulativeSessionFees);
    on<RequestASessionEvent>(_onRequestASession);
    on<JoinWaitListEvent>(_onJoinWaitList);
  }

  _onBookASessionSelected(BookASessionClicked event, emit) async {
    emit(const LoadingTherapistProfile());
    emit(await _baseRepo.checkUserDiscounts(
        event.availableSlotId, event.slotDate));
    // emit(await _baseRepo.bookingChecks(event.availableSlotId, event.slotDate));
  }

  _onAccumulativeSessionFees(AccumulativeSessionFeesEvent event, emit) async {
    emit(const LoadingTherapistProfile());
    emit(await _baseRepo.accumulativeSessionFees());
  }

  _onRequestASession(RequestASessionEvent event, emit) async {
    emit(const LoadingTherapistProfile());
    emit(await _baseRepo.requestASession(event.id));
  }

  _onJoinWaitList(JoinWaitListEvent event, emit) async {
    emit(const LoadingTherapistProfile());
    emit(await _baseRepo.joinWaitList(event.id));
  }

  _onCheckHasSessionsSelected(CheckHasSessions event, emit) async {
    emit(await _baseRepo.hasSessionsWallet(
        event.availableSlotId, event.slotDate));
  }

  _onCheckHasInsuranceSelected(CheckHasInsuranceFlatRate event, emit) async {
    emit(await _baseRepo.hasInsuranceFlatRate(
        event.availableSlotId, event.slotDate));
  }

  _onCheckIsCorporateSelected(CheckIsCorporate event, emit) async {
    emit(await _baseRepo.isCorporate(event.availableSlotId, event.slotDate));
  }

  _onCheckIsInsuranceSelected(CheckIsInsurance event, emit) async {
    emit(await _baseRepo.isInsurance(event.availableSlotId, event.slotDate));
  }

  // _onBioSelected(BioSelected event, emit) async {
  //   emit(const LoadingTherapistProfile());
  //   emit(await _baseRepo.getTherapistBio(event.id));
  // }

// _onServicesSelected(ServicesSelected event, emit) async {
//   emit(LoadingTherapistProfile());
//   try {
//     ServicesModel services = await _baseRepo.getTherapistServices();
//     emit(ServicesState(services: services));
//   } catch (e) {
//     log('error');
//   }
// }
//
// _onReviewsSelected(ReviewsSelected event, emit) async {
//
//   emit(LoadingTherapistProfile());
//   try {
//     List<ReviewModel> reviews = await _baseRepo.getTherapistReviews();
//     emit(ReviewsState(review: reviews));
//   } catch (e) {
//     log('error');
//   }
// }
//
// _onVideosSelected(VideosSelected event, emit) async {
//   emit(LoadingTherapistProfile());
//   try {
//     List<VideosModel> videos = await _baseRepo.getTherapistVideos();
//     emit(VideosState(videos: videos));
//   } catch (e) {
//     log('error');
//   }
// }
//
// _onBlogsSelected(BlogsSelected event, emit) async {
//   emit(LoadingTherapistProfile());
//   try {
//     List<BlogsModel> blogs = await _baseRepo.getTherapistBlogs();
//     emit(BlogsState(blogs: blogs));
//   } catch (e) {
//     log('error');
//   }
// }

}
