import 'package:o7therapy/api/models/notifications/notifications.dart';

class NotificationsWrapper {
  NotificationsWrapper({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
    required this.errorDetails,
    required this.expiration,
    required this.persistence,
    required this.totalSeconds,
  });

  final List<NotificationModel> data;
  final int errorCode;
  final String errorMsg;
  final String errorDetails;
  final Expiration expiration;
  final Persistence persistence;
  final int totalSeconds;

  NotificationsWrapper copyWith({
    List<NotificationModel>? data,
    int? errorCode,
    String? errorMsg,
    String? errorDetails,
    Expiration? expiration,
    Persistence? persistence,
    int? totalSeconds,
  }) =>
      NotificationsWrapper(
        data: data ?? this.data,
        errorCode: errorCode ?? this.errorCode,
        errorMsg: errorMsg ?? this.errorMsg,
        errorDetails: errorDetails ?? this.errorDetails,
        expiration: expiration ?? this.expiration,
        persistence: persistence ?? this.persistence,
        totalSeconds: totalSeconds ?? this.totalSeconds,
      );

  factory NotificationsWrapper.fromJson(json) => NotificationsWrapper(
        data: List<NotificationModel>.from(
            json["data"].map((x) => NotificationModel.fromJson(x))),
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        errorDetails: json["error_details"],
        expiration: Expiration.fromJson(json["expiration"]),
        persistence: Persistence.fromJson(json["persistence"]),
        totalSeconds: json["total_seconds"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "error_code": errorCode,
        "error_msg": errorMsg,
        "error_details": errorDetails,
        "expiration": expiration.toJson(),
        "persistence": persistence.toJson(),
        "total_seconds": totalSeconds,
      };
}

class ExtraParams {
  ExtraParams({
    required this.therapistId,
  });

  final String? therapistId;

  ExtraParams copyWith({
    String? therapistId,
  }) =>
      ExtraParams(
        therapistId: therapistId ?? this.therapistId,
      );

  factory ExtraParams.fromJson(json) => ExtraParams(
        therapistId: json["therapistId"],
      );

  Map<String, dynamic> toJson() => {
        "therapistId": therapistId,
      };
}

enum MessageTypeCode {
  TXT,
  SSN_SECOND_RMNDR_PTN,
  SSN_FIRST_RMNDR_PTN,
  BK_CFRM_PTN,
  BK_CNCL_PTN,
  SM_TOS_PAT,
  BK_RSCDL_PTN,
  NW_BK_THP
}

final messageTypeCodeValues = EnumValues({
  "BK-CFRM-PTN": MessageTypeCode.BK_CFRM_PTN,
  "BK-CNCL-PTN": MessageTypeCode.BK_CNCL_PTN,
  "BK-RSCDL-PTN": MessageTypeCode.BK_RSCDL_PTN,
  "NW-BK-THP": MessageTypeCode.NW_BK_THP,
  "SM-TOS-PAT": MessageTypeCode.SM_TOS_PAT,
  "SSN-FIRST-RMNDR-PTN": MessageTypeCode.SSN_FIRST_RMNDR_PTN,
  "SSN-SECOND-RMNDR-PTN": MessageTypeCode.SSN_SECOND_RMNDR_PTN,
  "TXT": MessageTypeCode.TXT
});

// enum Title {
//   HELLO,
//   SESSION_REMINDER,
//   BOOKING_CONFIRMED,
//   SESSION_WALLET,
//   BOOKING_CANCELLED,
//   THERAPIST_OPEN_SLOT,
//   BOOKING_RESCHEDULED,
//   SESSION_LIMITS,
//   _SESSION_BOOKING,
//   NEW_SESSION_BOOKING
// }

// final titleValues = EnumValues({
//   "Booking Cancelled": Title.BOOKING_CANCELLED,
//   "Booking Confirmed": Title.BOOKING_CONFIRMED,
//   "Booking Rescheduled": Title.BOOKING_RESCHEDULED,
//   "\u200eHello": Title.HELLO,
//   "New Session Booking": Title.NEW_SESSION_BOOKING,
//   "\u200eSession Limits": Title.SESSION_LIMITS,
//   "Session Reminder": Title.SESSION_REMINDER,
//   "\u200eSession Wallet": Title.SESSION_WALLET,
//   "Therapist open slot": Title.THERAPIST_OPEN_SLOT
// });

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => MapEntry(v, k));
    }
    return reverseMap;
  }
}
