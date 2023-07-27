import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:o7therapy/api/mixpanel_manager.dart';
import 'package:o7therapy/bloc/mixpanel_booking_bloc/mixpanel_keys.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/util/firebase/analytics/booking_analytics.dart';

part 'mixpanel_booking_event.dart';
part 'mixpanel_booking_state.dart';

class MixpanelBookingBloc
    extends Bloc<MixpanelBookingEvent, MixpanelBookingState> {
  late final Mixpanel _mixpanel;
  static MixpanelBookingEvent? lastEvent;
  MixpanelBookingBloc() : super(MixpanelBookingState.init()) {
    on<InitMixpanelEvent>(_onInitMixpanelEvent);
    on<TherapistCardClickedEvent>(_onTherapistCardClickedEvent);
    on<BookASessionButtonInBioClickedEvent>(
        _onBookASessionButtonInBioClickedEvent);
    on<NextButtonInScheduleClickedEvent>(_onNextButtonInScheduleClickedEvent);
    on<SuccessNextButtonInScheduleClickedEvent>(
        _onSuccessNextButtonInScheduleClickedEvent);

    on<ApplyPromoCodeEvent>(_onApplyPromoCodeEvent);
    on<ProceedToPaymentClickedEvent>(_onProceedToPaymentClickedEvent);
    on<SuccessfulBookingEvent>(_onSuccessfulBookingEvent);
    on<SuccessfulCancelBookingEvent>(_onSuccessfulCancelBookingEvent);
    on<CancelOrRescheduleButtonClickedEvent>(
        _onCancelOrRescheduleButtonClickedEvent);
    on<SuccessfulSessionRescheduleEvent>(_onSuccessfulSessionRescheduleEvent);
    on<JoinSessionActionEvent>(_onJoinSessionActionEvent);
  }

  static MixpanelBookingBloc bloc(BuildContext context) =>
      context.read<MixpanelBookingBloc>();

  FutureOr<void> _onInitMixpanelEvent(event, emit) async {
    _mixpanel = await MixpanelManager.init();
    if (kDebugMode) {
      _mixpanel.flush();
    }
  }

  FutureOr<void> _onTherapistCardClickedEvent(
    TherapistCardClickedEvent event,
    Emitter<MixpanelBookingState> emit,
  ) {
    emit(MixpanelBookingState.init());
    emit(
      state.copyWith(
        therapistId: event.therapistId,
        therapistName: event.therapistName,
      ),
    );
    log(state.therapistCardClickedMap.toString());
    _mixpanel.track(
      MixpanelKeys.therapistCardClicked,
      properties: state.therapistCardClickedMap,
    );

    BookingAnalytics.i.therapistCardClick(
      therapistId: event.therapistId,
      therapistName: event.therapistName,
    );
  }

  FutureOr<void> _onBookASessionButtonInBioClickedEvent(
    BookASessionButtonInBioClickedEvent event,
    Emitter<MixpanelBookingState> emit,
  ) {
    emit(
      state.copyWith(
        therapistId: event.therapistId,
        therapistName: event.therapistName,
      ),
    );
    log("Proceed to Booking (Next Event): ${state.therapistCardClickedMap}");
    _mixpanel.track(
      MixpanelKeys.bookASessionInBioClicked,
      properties: state.therapistCardClickedMap,
    );

    BookingAnalytics.i.bookASessionInBioClick(
      therapistId: event.therapistId,
      therapistName: event.therapistName,
    );
  }

  FutureOr<void> _onNextButtonInScheduleClickedEvent(
    NextButtonInScheduleClickedEvent event,
    Emitter<MixpanelBookingState> emit,
  ) {
    emit(
      state.copyWith(
        sessionSlotDateAndTime: event.slotDateTimeInUtc?.toIso8601String(),
        slotCurrency: event.currency,
        slotPrice: event.price,
        originalPrice: event.price,
      ),
    );
    log("NextButtonInScheduleClickedEvent: ${state.nextClickedMap}");
  }

  FutureOr<void> _onSuccessNextButtonInScheduleClickedEvent(
    SuccessNextButtonInScheduleClickedEvent event,
    Emitter<MixpanelBookingState> emit,
  ) {
    if (lastEvent! is! SuccessNextButtonInScheduleClickedEvent) {
      lastEvent = event;
      log("SuccessNextButtonInScheduleClickedEvent: ${state.nextClickedMap}");
      _mixpanel.track(
        MixpanelKeys.nextButtonInScheduleClicked,
        properties: state.nextClickedMap,
      );

      BookingAnalytics.i.nextButtonInScheduleClicked(
        therapistName: state.therapistName,
        sessionDateAndTimeInUTC: state.sessionSlotDateAndTimeISOString,
        price: state.slotPrice,
        currency: state.slotCurrency,
      );
    }
  }

  /// user try to apply promo code and back-end respond with the status of this promo-code
  FutureOr<void> _onApplyPromoCodeEvent(
    ApplyPromoCodeEvent event,
    Emitter<MixpanelBookingState> emit,
  ) {
    emit(
      state.copyWith(
        promoCode: event.promoCode,
        promoCodeStatus: event.promoCodeStatusString,
      ),
    );
    log("ApplyPromoCode: ${state.promoCodeMap}");
    _mixpanel.track(
      MixpanelKeys.applyPromoCode,
      properties: state.promoCodeMap,
    );

    BookingAnalytics.i.promoCodeApply(
      promoCode: event.promoCode,
      promoCodeStatus: event.promoCodeStatusString,
    );
  }

  /// Proceed To Payment Button Clicked
  FutureOr<void> _onProceedToPaymentClickedEvent(
    ProceedToPaymentClickedEvent event,
    Emitter<MixpanelBookingState> emit,
  ) {
    emit(state.copyWith(
      promoCode: event.promoCode,
      slotCurrency: event.currency,
      promoCodeStatus: null,
      totalPrice: event.total,
    ));
    log("Proceed To Payment Clicked Event: ${state.proceedToPaymentClickedMap}");
    _mixpanel.track(
      MixpanelKeys.proceedToPayment,
      properties: state.proceedToPaymentClickedMap,
    );

    BookingAnalytics.i.proceedToPayment(
      therapistID: state.therapistId,
      therapistName: state.therapistName,
      currency: state.slotCurrency,
      originalPrice: state.originalPrice,
      promoCode: state.promoCode,
      sessionDateAndTimeInUTC: state.sessionSlotDateAndTimeISOString,
      totalPrice: state.totalPrice,
    );
  }

  /// _onSuccessfulBookingEvent
  FutureOr<void> _onSuccessfulBookingEvent(
    SuccessfulBookingEvent event,
    Emitter<MixpanelBookingState> emit,
  ) async {
    if (event.sessionId != state.sessionId) {
      emit(state.copyWith(
          sessionId: event.sessionId,
          corporateName: await PrefManager.getCorporateName()));
      log("SuccessfulBooking: ${state.successfulBookingMap}");
      _mixpanel.track(
        MixpanelKeys.successfulBooking,
        properties: state.successfulBookingMap,
      );
    }

    BookingAnalytics.i.successfulBooking(
      therapistID: state.therapistId,
      therapistName: state.therapistName,
      currency: state.slotCurrency,
      sessionId: state.sessionId,
      promoCode: state.promoCode,
      originalPrice: state.originalPrice,
      corporateName: state.corporateName,
      actualPaidPrice: state.totalPrice,
    );
  }

  /// when user click on the cancel button or Reschedule
  /// used to save the [time],[therapistName] and [sessionId] of session
  /// that user need to cancel, in state
  /// so when successfully Canceled will trigger a mixpanel event
  /// or when successfully reschedule
  FutureOr<void> _onCancelOrRescheduleButtonClickedEvent(
    CancelOrRescheduleButtonClickedEvent event,
    Emitter<MixpanelBookingState> emit,
  ) {
    emit(state.copyWith(
      sessionSlotDateAndTime: event.slotDateTimeInUtc?.toIso8601String(),
      therapistName: event.therapistName,
      totalPrice: event.total,
      slotCurrency: event.currency,
      sessionId: event.sessionId,
    ));
    log("""CancelOrRescheduleButtonClicked: 
    ${event.total} -- ${event.currency} -- ${event.therapistName} 
    -- ${event.sessionId} -- ${event.slotDateTimeInUtc}""");
  }

  FutureOr<void> _onSuccessfulCancelBookingEvent(
    SuccessfulCancelBookingEvent event,
    Emitter<MixpanelBookingState> emit,
  ) {
    log("Successful Cancel Booking Event: ${state.successfulCancelBookingMap}");
    _mixpanel.track(
      MixpanelKeys.successfulCancelBooking,
      properties: state.successfulCancelBookingMap,
    );
    BookingAnalytics.i.successfulCancelBooking(
      sessionDateAndTimeInUTC: state.sessionSlotDateAndTimeISOString,
      currency: state.slotCurrency,
      therapistName: state.therapistName,
      sessionId: state.sessionId,
    );

    emit(MixpanelBookingState.init());
  }

  /// on Success Reschedule the session
  FutureOr<void> _onSuccessfulSessionRescheduleEvent(
    SuccessfulSessionRescheduleEvent event,
    Emitter<MixpanelBookingState> emit,
  ) {
    final Map<String, dynamic> successfulSessionRescheduleMap = {
      MixpanelKeys.oldSessionDateAndTimeInUTC:
          state.sessionSlotDateAndTimeISOString,
      MixpanelKeys.oldSessionID: state.sessionId,
      MixpanelKeys.newSessionDateAndTimeInUTC:
          event.newSlotStringDateTimeInUtc.toIso8601String(),
      MixpanelKeys.newSessionID: event.newSessionId,
      MixpanelKeys.therapistName: state.therapistName,
    };
    log("Successful Session Reschedule Event: $successfulSessionRescheduleMap");
    _mixpanel.track(
      MixpanelKeys.successfulSessionReschedule,
      properties: successfulSessionRescheduleMap,
    );

    BookingAnalytics.i.successfulSessionReschedule(
      oldSessionDateAndTimeInUTC: state.sessionSlotDateAndTimeISOString,
      oldSessionID: state.sessionId,
      newSessionDateAndTimeInUTC:
          event.newSlotStringDateTimeInUtc.toIso8601String(),
      newSessionID: event.newSessionId,
      therapistName: state.therapistName,
    );
    emit(MixpanelBookingState.init());
  }

  /// trigger the event when the user click on Join Session Action Event
  FutureOr<void> _onJoinSessionActionEvent(
    JoinSessionActionEvent event,
    Emitter<MixpanelBookingState> emit,
  ) {
    final Map<String, dynamic> joinSessionActionEventMap = {
      MixpanelKeys.sessionDateAndTimeInUTC:
          event.sessionDateAndTimeInUtc!.toIso8601String(),
      MixpanelKeys.sessionId: event.sessionId,
      MixpanelKeys.therapistName: event.therapistName,
    };
    log("join Session Action >> Button Clicked: $joinSessionActionEventMap");
    _mixpanel.track(
      MixpanelKeys.joinSessionActionEvent,
      properties: joinSessionActionEventMap,
    );

    BookingAnalytics.i.joinSessionActionEvent(
      sessionDateAndTimeInUTC: event.sessionDateAndTimeInUtc!.toIso8601String(),
      sessionId: event.sessionId,
      therapistName: event.therapistName,
    );

    emit(MixpanelBookingState.init());
  }

  @override
  void onTransition(
      Transition<MixpanelBookingEvent, MixpanelBookingState> transition) {
    lastEvent = transition.event;
    super.onTransition(transition);
  }
}
