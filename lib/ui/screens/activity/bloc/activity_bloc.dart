import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:o7therapy/api/models/activity/list.dart';
import 'package:o7therapy/api/models/activity/past_sessions/List.dart';
import 'package:o7therapy/api/models/available_slots/AvailableSlotsWrapper.dart';
import 'package:o7therapy/api/models/calculate_session_fees/CalculateSessionFees.dart';
import 'package:o7therapy/api/models/calculate_session_reschedule_fees/CalculateSessionRescheduleFees.dart';
import 'package:o7therapy/api/models/cancel_session/CancelSession.dart';
import 'package:o7therapy/api/models/check_session_compensated/SessionCompensated.dart';
import 'package:o7therapy/api/models/confirm_status/confirm_status_send_model.dart';
import 'package:o7therapy/api/models/join_session/JoinSessionWrapper.dart';
import 'package:o7therapy/api/models/reschedule_session/RescheduleSession.dart';
import 'package:o7therapy/api/models/reschedule_session/reschedule_session_send_model.dart';
import 'package:o7therapy/ui/screens/activity/bloc/activity_repo.dart';
import 'package:o7therapy/ui/screens/activity/filter_list.dart';

part 'activity_event.dart';

part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final BaseActivityRepo _baseRepo;
  static UpcomingSessionsState? _lastUpcomingSessionsPageState;
  static _UpcomingSessionsSelectedEvt _lastUpcomingSessionsEvent =
      _UpcomingSessionsSelectedEvt.init();
  static PastSessionsState? _lastPastSessionsPageState;
  static _PastSessionsSelectedEvt _lastPastSessionsEvent =
      _PastSessionsSelectedEvt.init();

  ActivityBloc(this._baseRepo) : super(const LoadingActivityState()) {
    on<_UpcomingSessionsSelectedEvt>(_onUpcomingSelected);
    on<_PastSessionsSelectedEvt>(_onPastSelected);
    on<NoActivityEvt>(_onNoActivity);
    on<RescheduleActivityEvt>(_onReschedulePressed);
    on<CancelActivityEvt>(_onCancelPressed);
    on<JoinSessionActivityEvt>(_onJoinSessionPressed);
    on<LaunchZoomActivityEvt>(_onLaunchZoomPressed);
    on<MessageActivityEvt>(_onMessagePressed);
    on<NotificationActivityEvt>(_onNotificationPressed);
    on<ApplyFilterActivityEvt>(_onApplyFilterPressed);
    on<CompensatedSessionActivityEvt>(_onCompensatedSession);
    on<CalculateSessionCancellationFeesActivityEvt>(_onCalculateSessionFees);
    on<CalculateSessionRescheduleFeesActivityEvt>(
        _onCalculateSessionRescheduleFees);
    on<CompensatedRescheduleSessionActivityEvt>(
        _onCompensatedRescheduleSession);
    on<AvailableSlotsEvt>(_onAvailableSlotsSelected);
    on<LoadingActivityEvt>(_loadingActivity);
    on<LoadingRescheduleDetailsEvt>(_onRescheduleDetailsSuccessLoaded);
    on<LoadingRescheduleEvt>(_onRescheduleSuccessLoaded);
    on<RescheduleRequirePayment>(_onRescheduleRequirePayment);
    on<ConfirmStatusEvent>(_onConfirmStatus);
    on<RefreshUpcomingSessionEvent>(_onRefreshUpcomingSessionEvent);
    on<HomeUpcomingSessionEvent>(_onHomeUpcomingSessionEvent);
    on<RefreshPastSessionEvent>(_onRefreshPastSessionEvent);
    on<GetMorePastSessionsEvent>(_onGetMorePastSessionsEvent);
    on<GetMoreUpcomingSessionsEvent>(_onGetMoreUpcomingSessionsEvent);
  }

  _onUpcomingSelected(_UpcomingSessionsSelectedEvt event, emit) async {
    emit(const LoadingActivityState());
    ActivityState state = await _baseRepo.getUpcomingSessions(
      isListUpdated: true,
      direction: 'Asc',
      from: event.from,
      to: event.to
    );
    if (state is UpcomingSessionsState) {
      _lastUpcomingSessionsPageState = state;
    } else {
      _lastUpcomingSessionsPageState = null;
    }
    emit(state);

    /// update the event
    _lastUpcomingSessionsEvent = event;
  }

  _onPastSelected(_PastSessionsSelectedEvt event, emit) async {
    emit(const LoadingActivityState());
    ActivityState state = await _baseRepo.getPastSessions(
      isListUpdated: true,
      direction: 'Desc',
        from: event.from,
        to: event.to
    );
    if (state is PastSessionsState) {
      _lastPastSessionsPageState = state;
    } else {
      _lastPastSessionsPageState = null;
    }
    emit(state);

    /// update the event
    _lastPastSessionsEvent = event;
  }

  _onGetMorePastSessionsEvent(GetMorePastSessionsEvent event, emit) async {
    log(" GetMorePastSessionsEvent:");
    ActivityState state = await _baseRepo.getPastSessions(
        from: event.from,
        to: event.to,
        isListUpdated: false, direction: _lastPastSessionsEvent.direction);
    emit(state);
  }

  _onGetMoreUpcomingSessionsEvent(
      GetMoreUpcomingSessionsEvent event, emit) async {
    log(" GetMoreUpcomingSessionsEvent:");
    ActivityState state = await _baseRepo.getUpcomingSessions(
        from: event.from,
        to: event.to,
        isListUpdated: false, direction: _lastUpcomingSessionsEvent.direction);
    emit(state);
  }

  _onRefreshUpcomingSessionEvent(RefreshUpcomingSessionEvent event, emit) {
    emit(const LoadingActivityState());
    _lastUpcomingSessionsPageState == null;
    add(_UpcomingSessionsSelectedEvt.init());
  }
  _onHomeUpcomingSessionEvent(HomeUpcomingSessionEvent event, emit) async{
    emit(const LoadingActivityState());
    emit(await _baseRepo.getHomeUpcomingSessions( from: event.from,
        to: event.to));
  }

  _onRefreshPastSessionEvent(RefreshPastSessionEvent event, emit) {
    emit(const LoadingActivityState());
    _lastPastSessionsPageState == null;
    add(_PastSessionsSelectedEvt.init());
  }

  _onNoActivity(NoActivityEvt event, emit) async {
    emit(const NoActivityState());
  }

  _onCompensatedSession(CompensatedSessionActivityEvt event, emit) async {
    emit(const LoadingActivityState());
    emit(await _baseRepo.checkSessionCompensated(event.id));
  }

  _onCalculateSessionFees(
      CalculateSessionCancellationFeesActivityEvt event, emit) async {
    emit(const LoadingActivityState());
    emit(await _baseRepo.calculateSessionCancellationFees(event.id));
  }

  _onCancelPressed(CancelActivityEvt event, emit) async {
    emit(const LoadingActivityState());
    emit(await _baseRepo.cancelSession(event.id));
  }

  _onCompensatedRescheduleSession(
      CompensatedRescheduleSessionActivityEvt event, emit) async {
    emit(const LoadingActivityState());
    emit(await _baseRepo.checkSessionRescheduleCompensated(
        id: event.sessionId,
        therapistName: event.therapistName,
        therapistId: event.therapistId,
        sessionFees: event.sessionFees,
        image: event.image,
        currency: event.currency,
        sessionDate: event.sessionDate,
        therapistProfession: event.therapistProfession));
  }

  _onCalculateSessionRescheduleFees(
      CalculateSessionRescheduleFeesActivityEvt event, emit) async {
    emit(const LoadingActivityState());
    emit(await _baseRepo.calculateSessionRescheduleFees(
        therapistProfession: event.therapistProfession,
        sessionDate: event.sessionDate,
        currency: event.currency,
        image: event.image,
        therapistName: event.therapistName,
        sessionId: event.sessionId,
        therapistId: event.therapistId,
        sessionFees: event.sessionFees,
        slotId: event.slotId));
  }

  _onReschedulePressed(RescheduleActivityEvt event, emit) async {
    emit(const LoadingActivityState());
    emit(await _baseRepo.rescheduleSession(event.id, event.model,event.sessionDate));
  }

  _onAvailableSlotsSelected(AvailableSlotsEvt event, emit) async {
    emit(const LoadingActivityState());
    emit(await _baseRepo.getAvailableSlots(
      sessionFees: event.sessionFees,
      therapistName: event.therapistName,
      sessionId: event.sessionId,
      image: event.image,
      currency: event.currency,
      sessionDate: event.sessionDate,
      therapistProfession: event.therapistProfession,
      therapistId: event.therapistId,
    ));
  }

  _onConfirmStatus(ConfirmStatusEvent event, emit) async {
    emit(const LoadingActivityState());
    emit(await _baseRepo.confirmStatus(event.model));
  }

  _onRescheduleDetailsSuccessLoaded(LoadingRescheduleDetailsEvt event, emit) {
    emit(LoadingRescheduleDetailsSuccess());
  }

  _onRescheduleSuccessLoaded(LoadingRescheduleEvt event, emit) {
    emit(LoadingRescheduleSuccess());
  }

  _onRescheduleRequirePayment(RescheduleRequirePayment event, emit) {
    emit(RescheduleRequirePaymentState());
  }

  _onJoinSessionPressed(JoinSessionActivityEvt event, emit) async {
    emit(const LoadingActivityState());
    emit(await _baseRepo.joinSession(event.id));
  }

  _loadingActivity(LoadingActivityEvt event, emit) async {
    emit(const LoadingActivityState());
  }

  _onLaunchZoomPressed(LaunchZoomActivityEvt event, emit) async {
    _baseRepo.launchZoom();
    try {
      emit(const LaunchZoomState());
    } catch (e) {
      log(e.toString());
    }
  }

  _onNotificationPressed(NotificationActivityEvt event, emit) async {
    _baseRepo.notification();
    try {
      emit(const NotificationState());
    } catch (e) {
      log(e.toString());
    }
  }

  _onMessagePressed(MessageActivityEvt event, emit) async {
    _baseRepo.messages();
    try {
      emit(const MessageSessionState());
    } catch (e) {
      log(e.toString());
    }
  }

  _onApplyFilterPressed(ApplyFilterActivityEvt event, emit) async {
    _baseRepo.filter();
    try {
      emit(FilterSessionState(
        selectedServicesType: event.selectedServicesType,
        selectedSessionStatus: event.selectedSessionStatus,
      ));
    } catch (e) {
      log(e.toString());
    }
  }
}
