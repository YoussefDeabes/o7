part of 'mixpanel_booking_bloc.dart';

abstract class MixpanelBookingEvent extends Equatable {
  const MixpanelBookingEvent();
}

class InitMixpanelEvent extends MixpanelBookingEvent {
  const InitMixpanelEvent();

  @override
  List<Object?> get props => [];
}

class TherapistCardClickedEvent extends MixpanelBookingEvent {
  final String? therapistId;
  final String? therapistName;
  const TherapistCardClickedEvent(this.therapistId, this.therapistName);

  @override
  List<Object?> get props => [therapistId, therapistName];
}

class BookASessionButtonInBioClickedEvent extends MixpanelBookingEvent {
  final String? therapistId;
  final String? therapistName;
  const BookASessionButtonInBioClickedEvent(
    this.therapistId,
    this.therapistName,
  );

  @override
  List<Object?> get props => [];
}

class NextButtonInScheduleClickedEvent extends MixpanelBookingEvent {
  final DateTime? slotDateTimeInUtc;
  final String? currency;
  final double? price;
  const NextButtonInScheduleClickedEvent(
      {this.slotDateTimeInUtc, this.currency, this.price});

  @override
  List<Object?> get props => [slotDateTimeInUtc, currency, price];
}

class SuccessNextButtonInScheduleClickedEvent extends MixpanelBookingEvent {
  const SuccessNextButtonInScheduleClickedEvent();

  @override
  List<Object?> get props => [];
}

class ApplyPromoCodeEvent extends MixpanelBookingEvent {
  final String promoCodeStatusString;
  final String promoCode;
  const ApplyPromoCodeEvent({
    required this.promoCodeStatusString,
    required this.promoCode,
  });

  @override
  List<Object?> get props => [];
}

class ProceedToPaymentClickedEvent extends MixpanelBookingEvent {
  final String? promoCode;
  final double total;
  final String currency;
  const ProceedToPaymentClickedEvent({
    required this.promoCode,
    required this.total,
    required this.currency,
  });

  @override
  List<Object?> get props => [];
}

class SuccessfulBookingEvent extends MixpanelBookingEvent {
  final String sessionId;
  const SuccessfulBookingEvent({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class SuccessfulCancelBookingEvent extends MixpanelBookingEvent {
  const SuccessfulCancelBookingEvent();

  @override
  List<Object?> get props => [];
}

class CancelOrRescheduleButtonClickedEvent extends MixpanelBookingEvent {
  final double total;
  final String currency;
  final DateTime? slotDateTimeInUtc;
  final String sessionId;
  final String? therapistName;

  const CancelOrRescheduleButtonClickedEvent({
    required this.slotDateTimeInUtc,
    required this.therapistName,
    required this.sessionId,
    required this.total,
    required this.currency,
  });

  @override
  List<Object?> get props => [];
}

class SuccessfulSessionRescheduleEvent extends MixpanelBookingEvent {
  final DateTime newSlotStringDateTimeInUtc;
  final String newSessionId;

  const SuccessfulSessionRescheduleEvent({
    required this.newSlotStringDateTimeInUtc,
    required this.newSessionId,
  });

  @override
  List<Object?> get props => [];
}

class JoinSessionActionEvent extends MixpanelBookingEvent {
  final String? sessionId;
  final String? therapistName;
  final DateTime? sessionDateAndTimeInUtc;
  const JoinSessionActionEvent({
    required this.sessionId,
    required this.therapistName,
    required this.sessionDateAndTimeInUtc,
  });

  @override
  List<Object?> get props => [];
}
