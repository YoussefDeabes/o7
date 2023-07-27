import 'dart:developer';

import 'package:o7therapy/api/api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/activity/activity_wrapper.dart';
import 'package:o7therapy/api/models/activity/list.dart';
import 'package:o7therapy/api/models/activity/past_sessions/List.dart';
import 'package:o7therapy/api/models/activity/past_sessions/PastSessionsWrapper.dart';
import 'package:o7therapy/api/models/available_slots/AvailableSlotsWrapper.dart';
import 'package:o7therapy/api/models/calculate_session_fees/CalculateSessionFees.dart';
import 'package:o7therapy/api/models/calculate_session_reschedule_fees/CalculateSessionRescheduleFees.dart';
import 'package:o7therapy/api/models/cancel_session/CancelSession.dart';
import 'package:o7therapy/api/models/check_session_compensated/SessionCompensated.dart';
import 'package:o7therapy/api/models/confirm_status/ConfirmStatus.dart';
import 'package:o7therapy/api/models/confirm_status/confirm_status_send_model.dart';
import 'package:o7therapy/api/models/join_session/JoinSessionWrapper.dart';
import 'package:o7therapy/api/models/reschedule_session/RescheduleSession.dart';
import 'package:o7therapy/api/models/reschedule_session/reschedule_session_send_model.dart';
import 'package:o7therapy/ui/screens/activity/bloc/activity_bloc.dart';

abstract class BaseActivityRepo {
  const BaseActivityRepo();

  Future<ActivityState> getUpcomingSessions(
      {required bool isListUpdated,
      required String direction,
      required String from,
      required String to});

  Future<ActivityState> getHomeUpcomingSessions(
      {required String from, required String to});

  Future<ActivityState> getPastSessions(
      {required bool isListUpdated,
      required String direction,
      required String from,
      required String to});

  Future<ActivityState> checkSessionCompensated(int id);

  Future<ActivityState> checkSessionRescheduleCompensated(
      {required int id,
      required String therapistName,
      required String therapistId,
      required String therapistProfession,
      required String sessionDate,
      required String currency,
      required String image,
      required double sessionFees});

  Future<ActivityState> calculateSessionCancellationFees(int id);

  Future<ActivityState> calculateSessionRescheduleFees(
      {required int sessionId,
      required String therapistId,
      required int slotId,
      required String therapistName,
      required String therapistProfession,
      required String sessionDate,
      required String currency,
      required String image,
      required double sessionFees});

  Future<ActivityState> getAvailableSlots(
      {required String therapistName,
      required int sessionId,
      required String therapistId,
      required String therapistProfession,
      required String sessionDate,
      required String currency,
      required String image,
      required double sessionFees});

  Future<ActivityState> cancelSession(int id);

  Future<ActivityState> rescheduleSession(
      int id, RescheduleSessionSendModel model, String sessionDate);

  Future<ActivityState> joinSession(int id);

  Future<ActivityState> confirmStatus(ConfirmStatusSendModel model);

  Future<void> notification();

  Future<void> messages();

  Future<void> filter();

  Future<void> launchZoom();
}

class ActivityRepo extends BaseActivityRepo {
  static int _pageNumber = 1;
  static bool _hasMore = false;

  const ActivityRepo();

  @override
  Future<ActivityState> getUpcomingSessions(
      {required bool isListUpdated,
      required String direction,
      required String from,
      required String to}) async {
    if (isListUpdated == true) {
      _pageNumber = 1;
      _hasMore = false;
    }
    ActivityState? activityState;
    NetworkExceptions? detailsModel;
    List<ListData>? upcomingSessions;
    try {
      await ApiManager.upcomingSessionsApi(
          pageNumber: _pageNumber,
          from: from,
          to: to, (ActivityWrapper sessions) {
        upcomingSessions = sessions.data?.list;
        _hasMore = sessions.data!.hasMore!;
        activityState = UpcomingSessionsState(
            isListUpdated: isListUpdated,
            sessions: upcomingSessions ?? [],
            hasMore: _hasMore);
      }, (NetworkExceptions details) {
        activityState = NetworkError(details.errorMsg!);
      });
      if (_hasMore) {
        _pageNumber++;
      }
    } catch (error) {
      activityState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return activityState!;
  }

  @override
  Future<ActivityState> getHomeUpcomingSessions(
      {required String from, required String to}) async {
    ActivityState? activityState;
    NetworkExceptions? detailsModel;
    List<ListData>? upcomingSessions;
    try {
      await ApiManager.upcomingSessionsApi(
        pageNumber: 1,
        pageSize: 1,
        from: from,
        to: to,
        (ActivityWrapper sessions) {
          upcomingSessions = sessions.data?.list;
          _hasMore = sessions.data!.hasMore!;
          activityState = HomeUpcomingSessionsState(
              isListUpdated: true,
              sessions: upcomingSessions ?? [],
              hasMore: _hasMore);
        },
        (NetworkExceptions details) {
          activityState = NetworkError(details.errorMsg!);
        },
      );
    } catch (error) {
      activityState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return activityState!;
  }

  @override
  Future<ActivityState> getPastSessions(
      {required bool isListUpdated,
      required String direction,
      required String from,
      required String to}) async {
    if (isListUpdated == true) {
      _pageNumber = 1;
      _hasMore = false;
    }
    ActivityState? activityState;
    NetworkExceptions? detailsModel;
    List<PastListData>? pastSessions;
    try {
      await ApiManager.pastSessionsApi(
          pageNumber: _pageNumber,
          from: from,
          to: to, (PastSessionsWrapper sessions) {
        pastSessions = sessions.data?.list;
        _hasMore = sessions.data!.hasMore!;
        activityState = PastSessionsState(
            isListUpdated: isListUpdated,
            sessions: pastSessions!,
            hasMore: _hasMore);
      }, (NetworkExceptions details) {
        detailsModel = details;
        activityState = NetworkError(details.errorMsg!);
      });
      if (_hasMore) {
        _pageNumber++;
      }
    } catch (error) {
      activityState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return activityState!;
  }

  @override
  Future<ActivityState> checkSessionCompensated(int id) async {
    ActivityState? activityState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.checkIfCompensatedSession(id,
          (SessionCompensated sessionCompensated) {
        activityState = CompensatedSessionState(sessionCompensated, id);
      }, (NetworkExceptions details) {
        detailsModel = details;
        activityState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      activityState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return activityState!;
  }

  @override
  Future<ActivityState> calculateSessionCancellationFees(int id) async {
    ActivityState? activityState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.calculateSessionFees(id,
          (CalculateSessionFees sessionCompensated) {
        activityState = CalculateSessionState(sessionCompensated, id);
      }, (NetworkExceptions details) {
        detailsModel = details;
        activityState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      activityState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return activityState!;
  }

  @override
  Future<ActivityState> cancelSession(int id) async {
    ActivityState? activityState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.cancelSession(id, (CancelSession cancelSession) {
        activityState = CancelSessionState(cancelSession, id);
      }, (NetworkExceptions details) {
        detailsModel = details;
        activityState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      activityState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return activityState!;
  }

  @override
  Future<ActivityState> checkSessionRescheduleCompensated(
      {required int id,
      required String therapistName,
      required String therapistId,
      required String therapistProfession,
      required String sessionDate,
      required String currency,
      required String image,
      required double sessionFees}) async {
    ActivityState? activityState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.checkIfCompensatedSession(id,
          (SessionCompensated sessionCompensated) {
        activityState = RescheduleCompensatedSessionState(
            sessionCompensated: sessionCompensated,
            sessionId: id,
            therapistName: therapistName,
            therapistId: therapistId,
            therapistProfession: therapistProfession,
            sessionDate: sessionDate,
            currency: currency,
            sessionFees: sessionFees,
            image: image);
      }, (NetworkExceptions details) {
        detailsModel = details;
        activityState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      activityState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return activityState!;
  }

  @override
  Future<ActivityState> calculateSessionRescheduleFees(
      {required int sessionId,
      required int slotId,
      required String therapistId,
      required String therapistName,
      required String therapistProfession,
      required String sessionDate,
      required String currency,
      required String image,
      required double sessionFees}) async {
    ActivityState? activityState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.calculateSessionRescheduleFees(sessionId,
          (CalculateSessionRescheduleFees calculatedSession) {
        activityState = RescheduleCalculateSessionState(
            calculateSessionFees: calculatedSession,
            sessionId: sessionId,
            slotId: slotId,
            therapistId: therapistId,
            therapistName: therapistName,
            image: image,
            currency: currency,
            sessionDate: sessionDate,
            therapistProfession: therapistProfession,
            sessionFees: sessionFees);
      }, (NetworkExceptions details) {
        detailsModel = details;
        activityState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      activityState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return activityState!;
  }

  @override
  Future<ActivityState> rescheduleSession(
      int id, RescheduleSessionSendModel model, String sessionDate) async {
    ActivityState? activityState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.rescheduleSession(id, model,
          (RescheduleSession rescheduleSession) {
        if (rescheduleSession.data!.requirePayment == false) {
          activityState =
              RescheduleSessionState(rescheduleSession, id, sessionDate);
        } else {
          activityState = RescheduleRequirePaymentState();
        }
      }, (NetworkExceptions details) {
        detailsModel = details;
        activityState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      activityState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return activityState!;
  }

  @override
  Future<ActivityState> joinSession(int id) async {
    ActivityState? activityState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.joinSessionsApi(id, (JoinSessionWrapper joinSession) {
        activityState = JoinSessionState(joinSession: joinSession);
      }, (NetworkExceptions details) {
        detailsModel = details;
        activityState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      activityState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return activityState!;
  }

  @override
  Future<ActivityState> getAvailableSlots(
      {required String therapistName,
      required int sessionId,
      required String therapistId,
      required String therapistProfession,
      required String sessionDate,
      required String currency,
      required double sessionFees,
      required String image}) async {
    ActivityState? activityState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.getAvailableSlots(therapistId,
          (AvailableSlotsWrapper availableSlots) {
        activityState = AvailableSlotsState(
            availableSlots: availableSlots,
            therapistName: therapistName,
            sessionId: sessionId.toString(),
            therapistId: therapistId,
            therapistProfession: therapistProfession,
            sessionDate: sessionDate,
            sessionFees: sessionFees,
            currency: currency,
            image: image);
      }, (NetworkExceptions details) {
        detailsModel = details;
        activityState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      activityState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return activityState!;
  }

  @override
  Future<ActivityState> confirmStatus(ConfirmStatusSendModel model) async {
    ActivityState? activityState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.confirmStatus(model, (ConfirmStatus joinSession) {
        activityState = ConfirmStatusState();
      }, (NetworkExceptions details) {
        detailsModel = details;
        activityState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      activityState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return activityState!;
  }

  @override
  Future<void> notification() async {
    log("notification pressed");
  }

  @override
  Future<void> messages() async {
    log("message pressed");
  }

  @override
  Future<void> filter() async {
    log("filter pressed");
  }

  @override
  Future<void> launchZoom() async {
    log("Launch Zoom pressed");
  }
}
