part of 'activity_bloc.dart';

@immutable
abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object?> get props => [];
}

class LoadingActivityState extends ActivityState {
  const LoadingActivityState();
}

class UpcomingSessionsState extends SessionCategoryState {
  final List<ListData> sessions;
  final bool isListUpdated;
  final bool hasMore;

  const UpcomingSessionsState({
    required this.sessions,
    required this.hasMore,
    this.isListUpdated = false,
  });

  @override
  List<Object> get props => [sessions, isListUpdated];

  UpcomingSessionsState copyWith({
    List<ListData>? sessions,
    bool? hasMore,
    bool? isListUpdated,
  }) {
    return UpcomingSessionsState(
      sessions: sessions ?? this.sessions,
      hasMore: hasMore ?? this.hasMore,
      isListUpdated: isListUpdated ?? this.isListUpdated,
    );
  }
}

class HomeUpcomingSessionsState extends SessionCategoryState {
  final List<ListData> sessions;
  final bool isListUpdated;
  final bool hasMore;

  const HomeUpcomingSessionsState({
    required this.sessions,
    required this.hasMore,
    this.isListUpdated = false,
  });

  @override
  List<Object> get props => [sessions, isListUpdated];

  HomeUpcomingSessionsState copyWith({
    List<ListData>? sessions,
    bool? hasMore,
    bool? isListUpdated,
  }) {
    return HomeUpcomingSessionsState(
      sessions: sessions ?? this.sessions,
      hasMore: hasMore ?? this.hasMore,
      isListUpdated: isListUpdated ?? this.isListUpdated,
    );
  }
}

class PastSessionsState extends SessionCategoryState {
  final List<PastListData> sessions;
  final bool isListUpdated;
  final bool hasMore;

  const PastSessionsState(
      {required this.sessions,
      required this.hasMore,
      this.isListUpdated = false});

  @override
  List<Object> get props => [sessions, isListUpdated];

  PastSessionsState copyWith({
    List<PastListData>? sessions,
    bool? hasMore,
    bool? isListUpdated,
  }) {
    return PastSessionsState(
      sessions: sessions ?? this.sessions,
      hasMore: hasMore ?? this.hasMore,
      isListUpdated: isListUpdated ?? this.isListUpdated,
    );
  }
}

class NetworkError extends ActivityState {
  final String message;

  const NetworkError(this.message);
}

class ErrorState extends ActivityState {
  final String message;

  const ErrorState(this.message);
}

class BookSessionState extends ActivityState {
  const BookSessionState();
}

class NoActivityState extends ActivityState {
  const NoActivityState();
}

abstract class SessionCategoryState extends ActivityState {
  const SessionCategoryState();
}

class JoinSessionState extends ActivityState {
  final JoinSessionWrapper joinSession;

  const JoinSessionState({required this.joinSession});
}

class LaunchZoomState extends ActivityState {
  const LaunchZoomState();
}

class NotificationState extends ActivityState {
  const NotificationState();
}

class MessageSessionState extends ActivityState {
  const MessageSessionState();
}

class FilterSessionState extends ActivityState {
  final Set<ServicesType> selectedServicesType;
  final Set<SessionStatus> selectedSessionStatus;

  const FilterSessionState({
    required this.selectedServicesType,
    required this.selectedSessionStatus,
  });
}

class CompensatedSessionState extends ActivityState {
  final SessionCompensated sessionCompensated;
  final int sessionId;

  const CompensatedSessionState(this.sessionCompensated, this.sessionId);
}

class CalculateSessionState extends ActivityState {
  final CalculateSessionFees calculateSessionFees;
  final int sessionId;

  const CalculateSessionState(this.calculateSessionFees, this.sessionId);
}

class CancelSessionState extends ActivityState {
  final CancelSession cancelSession;
  final int sessionId;

  const CancelSessionState(this.cancelSession, this.sessionId);
}

class RescheduleCompensatedSessionState extends ActivityState {
  final SessionCompensated sessionCompensated;
  final String therapistId;
  final String therapistName;
  final int sessionId;
  final String therapistProfession;
  final String sessionDate;
  final String currency;
  final String image;
  final double sessionFees;

  const RescheduleCompensatedSessionState(
      {required this.sessionCompensated,
      required this.sessionId,
      required this.therapistName,
      required this.therapistId,
      required this.currency,
      required this.image,
      required this.therapistProfession,
      required this.sessionDate,
      required this.sessionFees});
}

class RescheduleCalculateSessionState extends ActivityState {
  final CalculateSessionRescheduleFees calculateSessionFees;
  final int sessionId;
  final int slotId;
  final String therapistName;
  final String therapistId;
  final String therapistProfession;
  final String sessionDate;
  final String currency;
  final String image;
  final double sessionFees;

  const RescheduleCalculateSessionState(
      {required this.calculateSessionFees,
      required this.sessionId,
      required this.slotId,
      required this.therapistName,
      required this.currency,
      required this.image,
      required this.therapistProfession,
      required this.therapistId,
      required this.sessionDate,
      required this.sessionFees});
}

class RescheduleSessionState extends ActivityState {
  final RescheduleSession rescheduleSession;
  final int sessionId;
  final String sessionDate;

  const RescheduleSessionState(
      this.rescheduleSession, this.sessionId, this.sessionDate);
}

class AvailableSlotsState extends ActivityState {
  final AvailableSlotsWrapper availableSlots;
  final String therapistName;
  final String therapistId;
  final String sessionId;
  final String therapistProfession;
  final String sessionDate;
  final String currency;
  final String image;
  final double sessionFees;

  const AvailableSlotsState(
      {required this.availableSlots,
      required this.therapistName,
      required this.therapistId,
      required this.sessionId,
      required this.therapistProfession,
      required this.sessionDate,
      required this.currency,
      required this.image,
      required this.sessionFees});
}

class LoadingRescheduleDetailsSuccess extends ActivityState {}

class LoadingRescheduleSuccess extends ActivityState {}

class RescheduleRequirePaymentState extends ActivityState {}

class ConfirmStatusState extends ActivityState {}
