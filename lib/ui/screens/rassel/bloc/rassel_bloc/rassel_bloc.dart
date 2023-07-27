import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:o7therapy/api/models/calculate_subscription_fees/CalculateSubscriptionFees.dart';
import 'package:o7therapy/api/models/calculate_subscription_send_model/calculate_subscription_send_model.dart';
import 'package:o7therapy/api/models/rassel_client_subscription/RasselClientSubscriptions.dart';
import 'package:o7therapy/api/models/rassel_client_subscriptions_with_resubscribe/RasselClientSubscriptionsWithResubscribe.dart';
import 'package:o7therapy/api/models/rassel_is_subscribed/IsSubscribed.dart';
import 'package:o7therapy/api/models/rassel_subscription/RasselSubscription.dart';
import 'package:o7therapy/api/models/subscribe/Subscribe.dart';
import 'package:o7therapy/api/models/subscription_send_model/subscribe_send_model.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/rassel_bloc/rassel_repo.dart';
import 'package:o7therapy/ui/screens/rassel/model/fresh_chat_helper.dart';

part 'rassel_event.dart';

part 'rassel_state.dart';

class RasselBloc extends Bloc<RasselEvent, RasselState> {
  final BaseRasselRepo _baseRepo;
  static RasselSubscriptionState? rasselSubscriptionState;

  RasselBloc(this._baseRepo) : super(RasselLoadingState()) {
    on<RasselInitialEvt>(_onRasselTabEvt);
    on<RasselIsSubscribedEvt>(_onRasselIsSubscribedEvt);
    on<RasselClientSubscriptionsEvt>(_onRasselClientSubscriptionsEvt);
    on<RasselCalculateSubscriptionFeesEvt>(
        _onRasselCalculateSubscriptionFeesEvt);
    on<RasselCancelSubscriptionEvt>(_onRasselCancelSubscriptionEvt);
    on<RasselSubscribeEvt>(_onRasselSubScribeEvt);
    on<RasselMonthFreeTrialEvt>(_onRasselFreeTrialEvt);
    on<RasselMissedMessagesEvt>(_onRasselMissedMessagesEvt);
  }

  _onRasselTabEvt(RasselInitialEvt event, emit) async {
    emit(RasselLoadingState());
    RasselState getRasselSubscription = await _baseRepo.getRasselSubscription();
    if (getRasselSubscription is RasselSubscriptionState) {
      rasselSubscriptionState = getRasselSubscription;

      bool? isExpired = _isFreshChatExpired(
        rasselSubscriptionState?.rasselSubscription.data?.expirationDate,
      );
      if (isExpired) {
        FreshChatHelper.instance.reset();
      } else {
        FreshChatHelper.instance.enableFreshChatForSubscribedUserOnly();
      }
    }
    emit(getRasselSubscription);
  }

  _onRasselIsSubscribedEvt(RasselIsSubscribedEvt event, emit) async {
    emit(RasselLoadingState());
    emit(await _baseRepo.getIsSubscribed(
        subscriptionId: event.subscriptionId,
        currency: event.currency,
        amount: event.amount));
  }

  _onRasselClientSubscriptionsEvt(
      RasselClientSubscriptionsEvt event, emit) async {
    emit(RasselLoadingState());
    emit(await _baseRepo.getRasselClientSubscriptionsWithResubscribe());
  }

  _onRasselCalculateSubscriptionFeesEvt(
      RasselCalculateSubscriptionFeesEvt event, emit) async {
    emit(RasselLoadingState());
    emit(await _baseRepo.calculateSubscriptionFees(
        subscribeModel: event.subscribeSendModel));
  }

  _onRasselCancelSubscriptionEvt(
      RasselCancelSubscriptionEvt event, emit) async {
    emit(RasselLoadingState());
    emit(await _baseRepo.cancelSubscription(
        clientSubscriptionId: event.clientSubscriptionId));
  }

  _onRasselSubScribeEvt(RasselSubscribeEvt event, emit) async {
    emit(RasselLoadingState());
    emit(await _baseRepo.subscribe(
        subscribeSendModel: event.subscribeSendModel));
  }

  _onRasselFreeTrialEvt(RasselMonthFreeTrialEvt event, emit) {}

  _onRasselMissedMessagesEvt(RasselMissedMessagesEvt event, emit) {}

  bool _isFreshChatExpired(String? expirationDate) {
    if (expirationDate == null) {
      return false;
    } else if (DateTime.parse(expirationDate).isBefore(DateTime.now())) {
      return true;
    } else {
      return false;
    }
  }
}
