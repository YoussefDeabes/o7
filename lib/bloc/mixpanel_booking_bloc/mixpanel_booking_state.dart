part of 'mixpanel_booking_bloc.dart';

class MixpanelBookingState extends Equatable {
  final String? therapistId;
  final String? therapistName;
  final String? sessionSlotDateAndTimeISOString;
  final double? slotPrice;
  final String? slotCurrency;
  final String? promoCode;
  final String? promoCodeStatus;
  final double? originalPrice;
  final double? totalPrice;
  final String? sessionId;
  final String? corporateName;

  const MixpanelBookingState({
    required this.sessionId,
    required this.originalPrice,
    required this.totalPrice,
    required this.therapistId,
    required this.therapistName,
    required this.sessionSlotDateAndTimeISOString,
    required this.slotPrice,
    required this.slotCurrency,
    required this.promoCode,
    required this.promoCodeStatus,
    required this.corporateName,
  });

  MixpanelBookingState copyWith({
    String? therapistId,
    String? therapistName,
    String? sessionSlotDateAndTime,
    double? slotPrice,
    String? slotCurrency,
    String? promoCode,
    String? promoCodeStatus,
    double? originalPrice,
    double? totalPrice,
    String? sessionId,
    String? corporateName,
  }) {
    return MixpanelBookingState(
      therapistId: therapistId ?? this.therapistId,
      therapistName: therapistName ?? this.therapistName,
      sessionSlotDateAndTimeISOString:
          sessionSlotDateAndTime ?? this.sessionSlotDateAndTimeISOString,
      slotPrice: slotPrice ?? this.slotPrice,
      slotCurrency: slotCurrency ?? this.slotCurrency,
      promoCode: promoCode ?? this.promoCode,
      promoCodeStatus: promoCodeStatus ?? this.promoCodeStatus,
      originalPrice: originalPrice ?? this.originalPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      sessionId: sessionId ?? this.sessionId,
      corporateName: corporateName ?? this.corporateName,
    );
  }

  Map<String, dynamic> get therapistCardClickedMap {
    return {
      MixpanelKeys.therapistId: therapistId,
      MixpanelKeys.therapistName: therapistName,
    };
  }

  Map<String, dynamic> get nextClickedMap {
    return {
      MixpanelKeys.therapistName: therapistName,
      MixpanelKeys.sessionDateAndTimeInUTC: sessionSlotDateAndTimeISOString,
      MixpanelKeys.price: slotPrice,
      MixpanelKeys.currency: slotCurrency,
    };
  }

  Map<String, dynamic> get promoCodeMap {
    return {
      MixpanelKeys.promoCode: promoCode,
      MixpanelKeys.promoCodeStatus: promoCodeStatus
    };
  }

  Map<String, dynamic> get proceedToPaymentClickedMap {
    return {
      MixpanelKeys.promoCode: promoCode,
      MixpanelKeys.originalPrice: originalPrice,
      MixpanelKeys.totalPrice: totalPrice,
      MixpanelKeys.currency: slotCurrency,
      MixpanelKeys.sessionDateAndTimeInUTC: sessionSlotDateAndTimeISOString
    };
  }

  Map<String, dynamic> get successfulBookingMap {
    return {
      MixpanelKeys.sessionId: sessionId,
      MixpanelKeys.promoCode: promoCode,
      MixpanelKeys.originalPrice: originalPrice,
      MixpanelKeys.corporateName: corporateName,
      MixpanelKeys.actualPaidPrice: totalPrice,
    };
  }

  Map<String, dynamic> get successfulCancelBookingMap {
    return {
      // MixpanelKeys.totalPrice: totalPrice,
      MixpanelKeys.sessionDateAndTimeInUTC: sessionSlotDateAndTimeISOString,
      MixpanelKeys.currency: slotCurrency,
      MixpanelKeys.therapistName: therapistName,
      MixpanelKeys.sessionId: sessionId,
    };
  }

  factory MixpanelBookingState.init() {
    return const MixpanelBookingState(
      therapistId: null,
      therapistName: null,
      sessionSlotDateAndTimeISOString: null,
      slotCurrency: null,
      slotPrice: null,
      promoCodeStatus: null,
      promoCode: null,
      originalPrice: null,
      totalPrice: null,
      sessionId: null,
      corporateName: null,
    );
  }

  @override
  List<Object?> get props => [
        therapistId,
        therapistName,
        sessionSlotDateAndTimeISOString,
        slotCurrency,
        slotPrice,
        promoCode,
        promoCodeStatus,
        originalPrice,
        totalPrice,
        sessionId,
        corporateName
      ];
}
