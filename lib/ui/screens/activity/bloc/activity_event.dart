part of 'activity_bloc.dart';

@immutable
abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

class _UpcomingSessionsSelectedEvt extends ActivityEvent {
  final String direction;
  final String from;
  final String to;
  final Map<String, dynamic> queryParameters;

  const _UpcomingSessionsSelectedEvt(
      {required this.direction,
      required this.queryParameters,
      required this.from,
      required this.to});

  factory _UpcomingSessionsSelectedEvt.init() => _UpcomingSessionsSelectedEvt(
        from: DateTime.now().year.toString() +
            DateTime.now().month.toString() +
            DateTime.now().day.toString(),
        to: "${DateTime.now().year}${DateTime.now().month}31",
        direction: "Asc",
        queryParameters: {},
      );

  _UpcomingSessionsSelectedEvt copyWith({
    String? direction,
    String? from,
    String? to,
    bool? updateList,
    Map<String, dynamic>? queryParameters,
  }) {
    return _UpcomingSessionsSelectedEvt(
        from: from ?? this.from,
        to: to ?? this.to,
        direction: direction ?? this.direction,
        queryParameters: queryParameters ?? this.queryParameters);
  }

  @override
  List<Object?> get props => [direction, queryParameters];
}

class GetMorePastSessionsEvent extends ActivityEvent {
  final String from;
  final String to;

  const GetMorePastSessionsEvent({required this.from, required this.to});
}

class RefreshUpcomingSessionEvent extends ActivityEvent {
  final String from;
  final String to;

  const RefreshUpcomingSessionEvent({required this.from, required this.to});
}

class HomeUpcomingSessionEvent extends ActivityEvent {
  final String from;
  final String to;

  const HomeUpcomingSessionEvent({required this.from, required this.to});
}

class _PastSessionsSelectedEvt extends ActivityEvent {
  final String direction;
  final String from;
  final String to;
  final Map<String, dynamic> queryParameters;

  const _PastSessionsSelectedEvt(
      {required this.direction,
      required this.from,
      required this.to,
      required this.queryParameters});

  factory _PastSessionsSelectedEvt.init() => _PastSessionsSelectedEvt(
      direction: "Desc",
      queryParameters: {},
      from:
          "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}01",
      to: DateTime.now().year.toString() +
          DateTime.now().month.toString() +
          DateTime.now().day.toString());

  _PastSessionsSelectedEvt copyWith({
    String? direction,
    String? from,
    String? to,
    bool? updateList,
    Map<String, dynamic>? queryParameters,
  }) {
    return _PastSessionsSelectedEvt(
        from: from ?? this.from,
        to: to ?? this.to,
        direction: direction ?? this.direction,
        queryParameters: queryParameters ?? this.queryParameters);
  }

  @override
  List<Object?> get props => [direction, queryParameters];
}

class GetMoreUpcomingSessionsEvent extends ActivityEvent {
  final String from;
  final String to;

  const GetMoreUpcomingSessionsEvent({required this.from, required this.to});
}

class RefreshPastSessionEvent extends ActivityEvent {
  final String from;
  final String to;

  const RefreshPastSessionEvent({required this.from, required this.to});
}

class BookASessionSelectedEvt extends ActivityEvent {
  const BookASessionSelectedEvt();
}

class NoActivityEvt extends ActivityEvent {
  const NoActivityEvt();
}

class MessageActivityEvt extends ActivityEvent {
  const MessageActivityEvt();
}

class NotificationActivityEvt extends ActivityEvent {
  const NotificationActivityEvt();
}

class ApplyFilterActivityEvt extends ActivityEvent {
  final Set<ServicesType> selectedServicesType;
  final Set<SessionStatus> selectedSessionStatus;

  const ApplyFilterActivityEvt({
    required this.selectedServicesType,
    required this.selectedSessionStatus,
  });
}

class RescheduleActivityEvt extends ActivityEvent {
  final int id;
  final String sessionDate;
  final RescheduleSessionSendModel model;

  const RescheduleActivityEvt(this.id, this.model, this.sessionDate);
}

class CompensatedRescheduleSessionActivityEvt extends ActivityEvent {
  final int sessionId;
  final String therapistName;
  final String therapistId;
  final String therapistProfession;
  final String sessionDate;
  final String currency;
  final String image;
  final double sessionFees;

  const CompensatedRescheduleSessionActivityEvt({
    required this.sessionId,
    required this.therapistName,
    required this.therapistId,
    required this.therapistProfession,
    required this.sessionDate,
    required this.image,
    required this.currency,
    required this.sessionFees,
  });
}

class CalculateSessionRescheduleFeesActivityEvt extends ActivityEvent {
  final int sessionId;
  final int slotId;
  final String therapistId;
  final String therapistName;
  final String therapistProfession;
  final String sessionDate;
  final String currency;
  final String image;
  final double sessionFees;

  const CalculateSessionRescheduleFeesActivityEvt({
    required this.sessionId,
    required this.slotId,
    required this.therapistId,
    required this.therapistProfession,
    required this.sessionDate,
    required this.image,
    required this.currency,
    required this.therapistName,
    required this.sessionFees,
  });
}

class CompensatedSessionActivityEvt extends ActivityEvent {
  final int id;

  const CompensatedSessionActivityEvt(this.id);
}

class CalculateSessionCancellationFeesActivityEvt extends ActivityEvent {
  final int id;

  const CalculateSessionCancellationFeesActivityEvt(this.id);
}

class CancelActivityEvt extends ActivityEvent {
  final int id;

  const CancelActivityEvt(this.id);
}

class AvailableSlotsEvt extends ActivityEvent {
  final String therapistId;
  final String therapistName;
  final int sessionId;
  final String therapistProfession;
  final String sessionDate;
  final String currency;
  final String image;
  final double sessionFees;

  const AvailableSlotsEvt({
    required this.therapistId,
    required this.therapistName,
    required this.sessionId,
    required this.currency,
    required this.sessionDate,
    required this.therapistProfession,
    required this.image,
    required this.sessionFees,
  });
}

class JoinSessionActivityEvt extends ActivityEvent {
  final int id;

  const JoinSessionActivityEvt({required this.id});
}

class LaunchZoomActivityEvt extends ActivityEvent {
  const LaunchZoomActivityEvt();
}

class LoadingActivityEvt extends ActivityEvent {}

class LoadingRescheduleDetailsEvt extends ActivityEvent {}

class LoadingRescheduleEvt extends ActivityEvent {}

class RescheduleRequirePayment extends ActivityEvent {}

class ConfirmStatusEvent extends ActivityEvent {
  final ConfirmStatusSendModel model;

  const ConfirmStatusEvent(this.model);
}
