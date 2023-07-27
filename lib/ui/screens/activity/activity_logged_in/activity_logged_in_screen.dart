import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gr_zoom/gr_zoom.dart';
// import 'package:flutter_zoom_sdk/zoom_options.dart';
// import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/models/activity/list.dart';
import 'package:o7therapy/api/models/activity/past_sessions/List.dart';
import 'package:o7therapy/api/models/available_slots/AvailableSlotsWrapper.dart';
import 'package:o7therapy/api/zoom_constants.dart';
import 'package:o7therapy/bloc/mixpanel_booking_bloc/mixpanel_booking_bloc.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/api/models/available_slots_datetime/Data.dart';
import 'package:o7therapy/ui/screens/activity/bloc/activity_bloc.dart';
import 'package:o7therapy/ui/screens/activity/reschedule_screen/reschedule_payment_screen.dart';
import 'package:o7therapy/ui/screens/activity/reschedule_screen/reschedule_screen.dart';
import 'package:o7therapy/ui/screens/activity/widgets/activity_filter_modal_bottom_sheet.dart';
import 'package:o7therapy/ui/screens/activity/widgets/empty_activity_logged_in_user.dart';
import 'package:o7therapy/ui/screens/activity/widgets/past_sessions_card.dart';
import 'package:o7therapy/ui/screens/activity/widgets/upcoming_session_card.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/checkout/payment_details/payment_cancel_indebt.dart';
import 'package:o7therapy/ui/screens/checkout/success_payment_screen/success_payment_screen.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/widgets/custom_error_widget.dart';
import 'package:o7therapy/util/date_time_helper.dart';
import 'package:o7therapy/util/general.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityLoggedInScreen extends BaseStatefulWidget {
  static const routeName = '/activity-logged-in-screen';

  const ActivityLoggedInScreen({Key? key}) : super(key: key);

  @override
  BaseState<ActivityLoggedInScreen> baseCreateState() =>
      _ActivityLoggedInScreenState();
}

class _ActivityLoggedInScreenState extends BaseState<ActivityLoggedInScreen>
    with WidgetsBindingObserver {
  int tabIndex = 0;
  DateTime initialDateFilter = DateTime.now();
  int _pageKey = 0;
  int _pastPageKey = 0;
  bool compensated = false;
  double sessionFees = 0;
  String currency = "";
  int slotId = 0;
  String therapistName = "";
  String sessionDate = "";
  int sessionId = 0;
  String therapistProfession = "";
  String image = "";
  AvailableSlotsWrapper availableSlots = AvailableSlotsWrapper();
  bool requirePayment = true;
  late Timer timer;
  late final ActivityBloc _activityBloc;
  final PagingController<int, ListData> _pagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, PastListData> _pastPagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _activityBloc = context.read<ActivityBloc>();
    _activityBloc.add(RefreshUpcomingSessionEvent(
        from: initialDateFilter.year.toString() +
            initialDateFilter.month.toString().padLeft(2, "0") +
            initialDateFilter.day.toString().padLeft(2, "0"),
        to: initialDateFilter.year.toString() +
            initialDateFilter.month.toString().padLeft(2, "0") +
            _getLastDayOfMonth(
                initialDateFilter.month.toString().padLeft(2, "0"))));
    _pagingController.addPageRequestListener((pageKey) {
      _activityBloc.add(GetMoreUpcomingSessionsEvent(
          from: initialDateFilter.year.toString() +
              initialDateFilter.month.toString().padLeft(2, "0") +
              initialDateFilter.day.toString().padLeft(2, "0"),
          to: initialDateFilter.year.toString() +
              initialDateFilter.month.toString().padLeft(2, "0") +
              _getLastDayOfMonth(
                  initialDateFilter.month.toString().padLeft(2, "0"))));
      _pageKey = pageKey;
    });
    _pastPagingController.addPageRequestListener((pageKey) {
      _activityBloc.add(GetMorePastSessionsEvent(
          from:
              "${initialDateFilter.year}${initialDateFilter.month.toString().padLeft(2, "0")}01",
          to: initialDateFilter.year.toString() +
              initialDateFilter.month.toString().padLeft(2, "0") +
              _getLastDayOfMonth(
                  initialDateFilter.month.toString().padLeft(2, "0"))));
      _pastPageKey = pageKey;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted) {
      switch (state) {
        case AppLifecycleState.resumed:
          debugPrint("app is in resumed state");
          break;
        case AppLifecycleState.inactive:
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomeMainLoggedInScreen.routeName,
            (Route<dynamic> route) => false,
          );
          debugPrint("app is in inactive state");
          break;
        case AppLifecycleState.paused:
          debugPrint("app is in paused state");
          break;
        case AppLifecycleState.detached:
          debugPrint("app has been removed");
          break;
      }
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _pastPagingController.dispose();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(top: height * 0.01),
        child: BlocBuilder<ActivityBloc, ActivityState>(
          builder: (context, state) {
            if (state is UpcomingSessionsState) {
              return Column(
                children: [
                  // _getDateFilter(true),
                  const SizedBox(height: 12.0),
                  _getTabs(),
                  Expanded(child: _getBody()),
                ],
              );
            } else if (state is PastSessionsState) {
              return Column(
                children: [
                  // _getDateFilter(false),
                  const SizedBox(height: 12.0),
                  _getTabs(),
                  Expanded(child: _getBody()),
                ],
              );
            } else {
              return Column(
                children: [
                  // _getDateFilter(true),
                  const SizedBox(height: 12.0),
                  _getTabs(),
                  Expanded(child: _getBody()),
                ],
              );
            }
          },
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _getBody() {
    return BlocConsumer<ActivityBloc, ActivityState>(
      listener: (context, state) {
        if (state is LoadingActivityState ||
            state is LoadingRescheduleSuccess ||
            state is LoadingRescheduleDetailsSuccess) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is NetworkError) {
          if (state.message == "Session expired") {
            clearData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          }
          showToast(state.message);
        } else if (state is ErrorState) {
          if (state.message == "Session expired") {
            clearData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          }
          showToast(state.message);
        }
        if (state is CompensatedSessionState) {
          compensated = state.sessionCompensated.data!;
          context.read<ActivityBloc>().add(
              CalculateSessionCancellationFeesActivityEvt(state.sessionId));
        }
        if (state is CalculateSessionState) {
          // check first is corporate or insurance or not
          _checkIfCorporateOrInsuranceOrNot(state: state);
        }
        if (state is CancelSessionState) {
          // _pagingController.refresh();

          MixpanelBookingBloc.bloc(context)
              .add(const SuccessfulCancelBookingEvent());

          _activityBloc.add(RefreshUpcomingSessionEvent(
              from: initialDateFilter.year.toString() +
                  initialDateFilter.month.toString().padLeft(2, "0") +
                  initialDateFilter.day.toString().padLeft(2, "0"),
              to: initialDateFilter.year.toString() +
                  initialDateFilter.month.toString().padLeft(2, "0") +
                  _getLastDayOfMonth(
                      initialDateFilter.month.toString().padLeft(2, "0"))));
          showToast(translate(LangKeys.sessionCancelledSuccessfully));
        }
        if (state is AvailableSlotsState) {
          if (state.availableSlots.data!.isNotEmpty) {
            availableSlots = state.availableSlots;
            context
                .read<ActivityBloc>()
                .add(CompensatedRescheduleSessionActivityEvt(
                  image: state.image,
                  therapistId: state.therapistId,
                  sessionId: int.parse(state.sessionId),
                  therapistName: state.therapistName,
                  therapistProfession: state.therapistProfession,
                  sessionDate: state.sessionDate,
                  currency: state.currency,
                  sessionFees: state.sessionFees,
                ));
          } else {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => SimpleDialog(
                      title: Center(
                          child: Text(
                        translate(LangKeys.oops),
                        textAlign: TextAlign.center,
                      )),
                      children: [
                        SimpleDialogOption(
                          child: Center(
                            child: Text(
                                "${state.therapistName} ${translate(LangKeys.noAvailableSlots)}",
                                textAlign: TextAlign.center),
                          ),
                        ),
                        Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: width / 4),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  context.read<ActivityBloc>().add(
                                      RefreshUpcomingSessionEvent(
                                          from: initialDateFilter.year
                                                  .toString() +
                                              initialDateFilter.month
                                                  .toString()
                                                  .padLeft(2, "0") +
                                              initialDateFilter.day
                                                  .toString()
                                                  .padLeft(2, "0"),
                                          to: initialDateFilter.year.toString() +
                                              initialDateFilter.month
                                                  .toString()
                                                  .padLeft(2, "0") +
                                              _getLastDayOfMonth(
                                                  initialDateFilter.month
                                                      .toString()
                                                      .padLeft(2, "0"))));
                                },
                                child: Text(translate(LangKeys.confirm))))
                      ],
                    ));
          }
        }
        if (state is RescheduleCompensatedSessionState) {
          compensated = state.sessionCompensated.data!;
          context.read<ActivityBloc>().add(
              CalculateSessionRescheduleFeesActivityEvt(
                  slotId: slotId,
                  therapistId: state.therapistId,
                  therapistName: state.therapistName,
                  sessionId: state.sessionId,
                  therapistProfession: state.therapistProfession,
                  sessionDate: state.sessionDate,
                  currency: state.currency,
                  sessionFees: state.sessionFees,
                  image: state.image));
        }

        if (state is RescheduleCalculateSessionState) {
          sessionFees = state.calculateSessionFees.data!.feesAmount!;
          currency = state.calculateSessionFees.data!.currency ?? "";
          slotId = state.slotId;
          therapistName = state.therapistName;
          sessionDate = state.sessionDate;
          sessionId = state.sessionId;
          therapistProfession = state.therapistProfession;
          image = state.image;

          if (compensated == true) {
            if (state.calculateSessionFees.data!.feesPercentage! > 0) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => SimpleDialog(
                        title: Center(
                            child: Text(
                                translate(LangKeys
                                    .areYouSureYouWantToRescheduleThisSession),
                                textAlign: TextAlign.center)),
                        children: [
                          SimpleDialogOption(
                            child: Center(
                              child: Text(
                                  translate(LangKeys.sessionCannotBeCanceled),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                          Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: width / 4),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    context.read<ActivityBloc>().add(
                                        RefreshUpcomingSessionEvent(
                                            from: initialDateFilter
                                                    .year
                                                    .toString() +
                                                initialDateFilter
                                                    .month
                                                    .toString()
                                                    .padLeft(2, "0") +
                                                initialDateFilter
                                                    .day
                                                    .toString()
                                                    .padLeft(2, "0"),
                                            to: initialDateFilter
                                                    .year
                                                    .toString() +
                                                initialDateFilter.month
                                                    .toString()
                                                    .padLeft(2, "0") +
                                                _getLastDayOfMonth(
                                                    initialDateFilter.month
                                                        .toString()
                                                        .padLeft(2, "0"))));
                                  },
                                  child: Text(translate(LangKeys.confirm))))
                        ],
                      ));
            } else {
              requirePayment = false;
              //todo: confirm rescheduling
              showDialogAlert(
                title: translate(
                    LangKeys.areYouSureYouWantToRescheduleThisSession),
                message: translate(LangKeys.rescheduleAtNoCharge),
                navigation: () {
                  List<Data> slots = [];
                  for (var element in availableSlots.data!) {
                    slots.add(Data(
                        id: element.id,
                        from: DateTimeHelper.getLocalDate(element.from!),
                        to: DateTimeHelper.getLocalDate(element.to!)));
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushNamed(RescheduleScreen.routeName, arguments: {
                    "therapistId": state.therapistId,
                    'availableSlots': slots,
                    'sessionId': state.sessionId.toString(),
                    "therapistName": state.therapistName,
                    "therapistProfession": state.therapistProfession,
                    "sessionDate": state.sessionDate,
                    "currency": state.currency,
                    "sessionFees": 0.0,
                    "image": state.image,
                    "requirePayment": false
                  }).then((value) {
                    // _pagingController.refresh();
                    _activityBloc.add(RefreshUpcomingSessionEvent(
                        from: initialDateFilter.year.toString() +
                            initialDateFilter.month.toString().padLeft(2, "0") +
                            initialDateFilter.day.toString().padLeft(2, "0"),
                        to: initialDateFilter.year.toString() +
                            initialDateFilter.month.toString().padLeft(2, "0") +
                            _getLastDayOfMonth(initialDateFilter.month
                                .toString()
                                .padLeft(2, "0"))));
                  });
                },
              );
            }
          } else {
            if (state.calculateSessionFees.data!.feesPercentage == 0) {
              requirePayment = false;
              //todo: confirm rescheduling
              showDialogAlert(
                title: translate(
                    LangKeys.areYouSureYouWantToRescheduleThisSession),
                message: translate(LangKeys.rescheduleAtNoCharge),
                navigation: () {
                  List<Data> slots = [];
                  for (var element in availableSlots.data!) {
                    slots.add(Data(
                        id: element.id,
                        from: DateTimeHelper.getLocalDate(element.from!),
                        to: DateTimeHelper.getLocalDate(element.to!)));
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushNamed(RescheduleScreen.routeName, arguments: {
                    "therapistId": state.therapistId,
                    'availableSlots': slots,
                    'sessionId': state.sessionId.toString(),
                    "therapistName": state.therapistName,
                    "therapistProfession": state.therapistProfession,
                    "sessionDate": state.sessionDate,
                    "currency": state.currency,
                    "sessionFees": 0.0,
                    "image": state.image,
                    "requirePayment": false
                  }).then((value) {
                    // _pagingController.refresh();
                    _activityBloc.add(RefreshUpcomingSessionEvent(
                        from: initialDateFilter.year.toString() +
                            initialDateFilter.month.toString().padLeft(2, "0") +
                            initialDateFilter.day.toString().padLeft(2, "0"),
                        to: initialDateFilter.year.toString() +
                            initialDateFilter.month.toString().padLeft(2, "0") +
                            _getLastDayOfMonth(initialDateFilter.month
                                .toString()
                                .padLeft(2, "0"))));
                  });
                },
              );
            } else {
              if (state.calculateSessionFees.data!.flatRate == true) {
                //todo: require payment
                requirePayment = true;
                sessionFees = state.calculateSessionFees.data!.feesAmount!;
                showDialogAlert(
                  title: translate(
                      LangKeys.areYouSureYouWantToRescheduleThisSession),
                  message:
                      translate(LangKeys.rescheduleWithin6HoursBeforeSession),
                  navigation: () {
                    List<Data> slots = [];
                    for (var element in availableSlots.data!) {
                      slots.add(Data(
                          id: element.id,
                          from: DateTimeHelper.getLocalDate(element.from!),
                          to: DateTimeHelper.getLocalDate(element.to!)));
                    }
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushNamed(RescheduleScreen.routeName, arguments: {
                      "therapistId": state.therapistId,
                      'availableSlots': slots,
                      'sessionId': state.sessionId.toString(),
                      "therapistName": state.therapistName,
                      "therapistProfession": state.therapistProfession,
                      "sessionDate": state.sessionDate,
                      "currency": state.currency,
                      "sessionFees":
                          state.calculateSessionFees.data!.feesAmount,
                      "image": state.image,
                      "requirePayment": true
                    }).then((value) {
                      // _pagingController.refresh();
                      _activityBloc.add(RefreshUpcomingSessionEvent(
                          from: initialDateFilter.year.toString() +
                              initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0") +
                              initialDateFilter.day.toString().padLeft(2, "0"),
                          to: initialDateFilter.year.toString() +
                              initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0") +
                              _getLastDayOfMonth(initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0"))));
                    });
                  },
                );
              } else {
                //todo: go to payment page
                requirePayment = true;
                showDialogAlert(
                  title: translate(
                      LangKeys.areYouSureYouWantToRescheduleThisSession),
                  message:
                      '${translate(LangKeys.a)} ${state.calculateSessionFees.data!.feesPercentage!} ${translate(LangKeys.rescheduleFeeWillBeApplied)}',
                  navigation: () {
                    List<Data> slots = [];
                    for (var element in availableSlots.data!) {
                      slots.add(Data(
                          id: element.id,
                          from: DateTimeHelper.getLocalDate(element.from!),
                          to: DateTimeHelper.getLocalDate(element.to!)));
                    }
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushNamed(RescheduleScreen.routeName, arguments: {
                      "therapistId": state.therapistId,
                      'availableSlots': slots,
                      'sessionId': state.sessionId.toString(),
                      "therapistName": state.therapistName,
                      "therapistProfession": state.therapistProfession,
                      "sessionDate": state.sessionDate,
                      "currency": state.currency,
                      "sessionFees":
                          state.calculateSessionFees.data!.feesAmount,
                      "image": state.image,
                      "requirePayment": true
                    }).then((value) {
                      // _pagingController.refresh();
                      _activityBloc.add(RefreshUpcomingSessionEvent(
                          from: initialDateFilter.year.toString() +
                              initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0") +
                              initialDateFilter.day.toString().padLeft(2, "0"),
                          to: initialDateFilter.year.toString() +
                              initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0") +
                              _getLastDayOfMonth(initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0"))));
                    });
                  },
                );
              }
            }
          }
        }
        if (state is RescheduleSessionState) {
          if (state.rescheduleSession.data!.requirePayment == false) {
            showToast(translate(LangKeys.sessionRescheduledSuccessfully));

            /// send event to mixpanel
            MixpanelBookingBloc.bloc(context).add(
              SuccessfulSessionRescheduleEvent(
                newSessionId: state.sessionId.toString(),
                newSlotStringDateTimeInUtc:
                    getUtcDateTimeFromBackEndLocalTimeString(state.sessionDate),
              ),
            );
            Navigator.of(context).pushReplacementNamed(
                SuccessPaymentScreen.routeName,
                arguments: {
                  "therapistName": therapistName,
                  "sessionDate": state.sessionDate,
                });
          } else {
            //todo: payment screen
            showDialogAlert(
                cancel: translate(LangKeys.payLater),
                confirm: translate(LangKeys.payNow),
                navigation: () => Navigator.of(context).pushReplacementNamed(
                        ReschedulePaymentScreen.routeName,
                        arguments: {
                          "slotId": slotId.toString(),
                          "sessionFees": sessionFees,
                          "sessionDate": state.sessionDate,
                          "currency": currency,
                          "therapistName": therapistName,
                          "therapistProfession": therapistProfession,
                          "image": image,
                          "sessionId": sessionId
                        }),
                title: translate(LangKeys.youHaveAccumulativeFees),
                message:
                    '${translate(LangKeys.youHaveAccumulativeFees)} $sessionFees');
          }
        }

        if (state is ConfirmStatusState) {
          context.read<ActivityBloc>().add(RefreshPastSessionEvent(
              from:
                  "${initialDateFilter.year}${initialDateFilter.month.toString().padLeft(2, "0")}01",
              to: initialDateFilter.year.toString() +
                  initialDateFilter.month.toString().padLeft(2, "0") +
                  _getLastDayOfMonth(
                      initialDateFilter.month.toString().padLeft(2, "0"))));
        }
        if (state is JoinSessionState) {
          _setZoomURl(state.joinSession.data!.participantMeetingUrl ?? "");
          if (state.joinSession.data!.enforceSwitch == true) {
            _launchUrl(state.joinSession.data!.participantMeetingUrl!);
          } else {
            _launchUrl(state.joinSession.data!.participantMeetingUrl!);
            // joinMeeting(context, state.joinSession.data!.meetingId!,
            //     state.joinSession.data!.meetingPassword ?? "");
          }
        }
      },
      builder: (context, state) {
        if (state is NoActivityState) {
          return EmptyActivityLoggedInUser();
        } else if (state is UpcomingSessionsState) {
          return _upcomingSessions(state);
        } else if (state is PastSessionsState) {
          return _pastSessions(state);
        } else if (state is NetworkError) {
          return CustomErrorWidget(state.message);
        } else if (state is ErrorState) {
          return CustomErrorWidget(state.message);
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _upcomingSessions(UpcomingSessionsState state) {
    // List<ListData> filteredList = [];
    // for (var element in state.sessions) {
    //   if (element.status != 3) {
    //     filteredList.add(element);
    //   }
    // }

    if (state.isListUpdated) {
      // _activityBloc.add(const RefreshUpcomingSessionEvent());
      _pagingController.refresh();
    }
    if (!state.hasMore) {
      _pagingController.appendLastPage(state.sessions);
    } else {
      final nextPageKey = _pageKey + state.sessions.length;
      _pagingController.appendPage(state.sessions, nextPageKey);
    }
    return state.sessions.isEmpty
        ? EmptyActivityLoggedInUser()
        : RefreshIndicator(
            onRefresh: () async {
              // _pagingController.refresh();
              _activityBloc.add(RefreshUpcomingSessionEvent(
                  from: initialDateFilter.year.toString() +
                      initialDateFilter.month.toString().padLeft(2, "0") +
                      initialDateFilter.day.toString().padLeft(2, "0"),
                  to: initialDateFilter.year.toString() +
                      initialDateFilter.month.toString().padLeft(2, "0") +
                      _getLastDayOfMonth(
                          initialDateFilter.month.toString().padLeft(2, "0"))));
            },
            child:
                CustomScrollView(shrinkWrap: false, primary: false, slivers: [
              PagedSliverList<int, ListData>(
                pagingController: _pagingController,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                addSemanticIndexes: false,
                shrinkWrapFirstPageIndicators: true,
                builderDelegate: PagedChildBuilderDelegate<ListData>(
                    noItemsFoundIndicatorBuilder: (context) =>
                        EmptyActivityLoggedInUser(),
                    itemBuilder: (context, item, index) => Container(
                      padding:const EdgeInsets.symmetric(horizontal: 16),
                          height: height / 4,
                          child: UpcomingSessionCard(sessions: item),
                        )),
              ),
            ]),
          );
  }

  Widget _pastSessions(PastSessionsState state) {
    if (state.isListUpdated) {
      _pastPagingController.refresh();
    }
    if (!state.hasMore) {
      _pastPagingController.appendLastPage(state.sessions);
    } else {
      final nextPageKey = _pastPageKey + state.sessions.length;
      _pastPagingController.appendPage(state.sessions, nextPageKey);
    }
    return state.sessions.isEmpty
        ? EmptyActivityLoggedInUser()
        : RefreshIndicator(
            onRefresh: () async {
              // _pastPagingController.refresh();
              _activityBloc.add(RefreshPastSessionEvent(
                  from:
                      "${initialDateFilter.year}${initialDateFilter.month.toString().padLeft(2, "0")}01",
                  to: initialDateFilter.year.toString() +
                      initialDateFilter.month.toString().padLeft(2, "0") +
                      _getLastDayOfMonth(
                          initialDateFilter.month.toString().padLeft(2, "0"))));
            },
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child:
                  CustomScrollView(shrinkWrap: false, primary: false, slivers: [
                PagedSliverList<int, PastListData>(
                  pagingController: _pastPagingController,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  addSemanticIndexes: false,
                  shrinkWrapFirstPageIndicators: true,
                  builderDelegate: PagedChildBuilderDelegate<PastListData>(
                      noItemsFoundIndicatorBuilder: (context) =>
                          EmptyActivityLoggedInUser(),
                      itemBuilder: (context, item, index) => SizedBox(
                            height: height / 4,
                            child: PastSessionsCard(sessions: item),
                          )),
                ),
              ]),
            ),
          );
  }

  Widget _getDateFilter(bool upcoming) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (upcoming &&
                      initialDateFilter.month == DateTime.now().month) {
                  } else {
                    setState(() {
                      initialDateFilter = DateTime(
                          initialDateFilter.year, initialDateFilter.month - 1);
                    });
                    if (upcoming) {
                      _activityBloc.add(GetMoreUpcomingSessionsEvent(
                          from: initialDateFilter.year.toString() +
                              initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0") +
                              initialDateFilter.day.toString().padLeft(2, "0"),
                          to: initialDateFilter.year.toString() +
                              initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0") +
                              _getLastDayOfMonth(initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0"))));
                    } else {
                      _activityBloc.add(GetMorePastSessionsEvent(
                          from:
                              "${initialDateFilter.year}${initialDateFilter.month.toString().padLeft(2, "0")}01",
                          to: initialDateFilter.year.toString() +
                              initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0") +
                              _getLastDayOfMonth(initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0"))));
                    }
                  }
                },
                icon: SvgPicture.asset(
                  AssPath.leftCircle,
                  matchTextDirection: true,
                  height: 50,
                ),
                color: ConstColors.app,
              ),
              SizedBox(
                width: width / 4,
                child: Center(
                  child: Text(
                    "${DateFormat('MMM').format(initialDateFilter)}, ${initialDateFilter.year}",
                    style: const TextStyle(
                        color: ConstColors.app,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (!upcoming &&
                      initialDateFilter.month == DateTime.now().month) {
                  } else {
                    setState(() {
                      initialDateFilter = DateTime(
                          initialDateFilter.year, initialDateFilter.month + 1);
                    });
                    if (upcoming) {
                      _activityBloc.add(GetMoreUpcomingSessionsEvent(
                          from: initialDateFilter.year.toString() +
                              initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0") +
                              initialDateFilter.day.toString().padLeft(2, "0"),
                          to: initialDateFilter.year.toString() +
                              initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0") +
                              _getLastDayOfMonth(initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0"))));
                    } else {
                      _activityBloc.add(GetMorePastSessionsEvent(
                          from:
                              "${initialDateFilter.year}${initialDateFilter.month.toString().padLeft(2, "0")}01",
                          to: initialDateFilter.year.toString() +
                              initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0") +
                              _getLastDayOfMonth(initialDateFilter.month
                                  .toString()
                                  .padLeft(2, "0"))));
                    }
                  }
                },
                icon: SvgPicture.asset(
                  AssPath.rightCircle,
                  matchTextDirection: true,
                  height: 50,
                ),
                color: ConstColors.app,
              ),
            ],
          ),
          _getFilterIcon(),
        ],
      ),
    );
  }

  Widget _getFilterIcon() {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          enableDrag: true,
          isDismissible: true,
          context: context,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(16),
              topStart: Radius.circular(16),
            ),
          ),
          builder: (context) => Container(
            color: Colors.transparent,
            height: height - 65,
            padding: const EdgeInsetsDirectional.only(start: 24, end: 24),
            child: const ActivityFilterModalBottomSheet(),
          ),
        );
      },
      icon: SvgPicture.asset(AssPath.filterIcon),
    );
  }

  Widget _getTabs() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: BlocBuilder<ActivityBloc, ActivityState>(
        builder: (context, state) {
          if (state is LoadingActivityState) {
            return Center(
              child: AbsorbPointer(
                child: ToggleSwitch(
                  initialLabelIndex: tabIndex,
                  textDirectionRTL: true,
                  totalSwitches: 2,
                  cornerRadius: 20.0,
                  // doubleTapDisable: true,
                  minWidth: width / 2,
                  inactiveBgColor: ConstColors.appWhite,
                  inactiveFgColor: ConstColors.textSecondary,
                  activeFgColor: ConstColors.appWhite,
                  radiusStyle: true,
                  borderColor: const [ConstColors.disabled],
                  borderWidth: 1,
                  labels: [
                    translate(LangKeys.upcomingSessions),
                    translate(LangKeys.pastSessions)
                  ],
                  onToggle: (index) {},
                ),
              ),
            );
          } else {
            return Center(
              child: ToggleSwitch(
                initialLabelIndex: tabIndex,
                textDirectionRTL: true,
                totalSwitches: 2,
                cornerRadius: 20.0,
                // doubleTapDisable: true,
                minWidth: width / 2,
                inactiveBgColor: ConstColors.appWhite,
                inactiveFgColor: ConstColors.textSecondary,
                activeFgColor: ConstColors.appWhite,
                radiusStyle: true,
                borderColor: const [ConstColors.disabled],
                borderWidth: 1,
                labels: [
                  translate(LangKeys.upcomingSessions),
                  translate(LangKeys.pastSessions)
                ],
                onToggle: (index) {
                  tabIndex = index!;
                  if (index == 0) {
                    // initialDateFilter = DateTime.now();
                    setState(() {
                      tabIndex = index;
                    });
                    _activityBloc.add(RefreshUpcomingSessionEvent(
                        from: initialDateFilter.year.toString() +
                            initialDateFilter.month.toString().padLeft(2, "0") +
                            initialDateFilter.day.toString().padLeft(2, "0"),
                        to: initialDateFilter.year.toString() +
                            initialDateFilter.month.toString().padLeft(2, "0") +
                            _getLastDayOfMonth(initialDateFilter.month
                                .toString()
                                .padLeft(2, "0"))));
                  } else if (index == 1) {
                    // initialDateFilter = DateTime.now();
                    setState(() {
                      tabIndex = index;
                    });
                    _activityBloc.add(RefreshPastSessionEvent(
                        from:
                            "${initialDateFilter.year}${initialDateFilter.month.toString().padLeft(2, "0")}01",
                        to: initialDateFilter.year.toString() +
                            initialDateFilter.month.toString().padLeft(2, "0") +
                            _getLastDayOfMonth(initialDateFilter.month
                                .toString()
                                .padLeft(2, "0"))));
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////

  void _setZoomURl(String url) async {
    await PrefManager.setZoomUrl(url);
  }

  // ///   API KEY & SECRET is required for below methods to work
  // ///   Join Meeting With Meeting ID & Password
  // joinMeeting(BuildContext context, String meetingID, String meetingPassword) {
  //   showLoading();
  //   bool _isMeetingEnded(String status) {
  //     var result = false;

  //     if (Platform.isAndroid) {
  //       result = status == "MEETING_STATUS_DISCONNECTING" ||
  //           status == "MEETING_STATUS_FAILED";
  //     } else {
  //       result = status == "MEETING_STATUS_IDLE";
  //     }

  //     return result;
  //   }

  //   if (true) {
  //     hideLoading();
  //     ZoomOptions zoomOptions = ZoomOptions(
  //       domain: "zoom.us",
  //       appKey: ZoomConstants.apiKey, //API KEY FROM ZOOM
  //       appSecret: ZoomConstants.appSecret, //API SECRET FROM ZOOM
  //     );
  //     var meetingOptions = ZoomMeetingOptions(
  //         userId: 'O7 Therapy Client',

  //         /// pass username for join meeting only --- Any name eg:- EVILRATT.
  //         meetingId: meetingID,

  //         /// pass meeting id for join meeting only
  //         meetingPassword: meetingPassword,

  //         /// pass meeting password for join meeting only
  //         disableDialIn: "true",
  //         disableDrive: "true",
  //         disableInvite: "true",
  //         disableShare: "true",
  //         noAudio: "false",
  //         noDisconnectAudio: "false");

  //     var zoom = Zoom();
  //     zoom.init(zoomOptions).then((results) {
  //       if (results[0] == 0) {
  //         zoom.onMeetingStateChanged.listen((status) {
  //           if (kDebugMode) {}
  //           if (_isMeetingEnded(status[0])) {
  //             _activityBloc.add(const RefreshUpcomingSessionEvent());
  //             if (kDebugMode) {}
  //             timer.cancel();
  //           }
  //         });
  //         if (kDebugMode) {
  //           print("listen on event channel");
  //         }
  //         showLoading();
  //         zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
  //           timer = Timer.periodic(const Duration(seconds: 2), (timer) {
  //             zoom.meetingStatus(meetingOptions.meetingId).then((status) {
  //               hideLoading();
  //               if (kDebugMode) {
  //                 print(
  //                     "[Meeting Status Polling] : + ${status[0]} - ${status[1]}");
  //               }
  //             });
  //           });
  //         });
  //       }
  //     }).catchError((error) {
  //       if (kDebugMode) {
  //         print("[Error Generated] : $error");
  //       }
  //     });
  //   }
  // }

  showDialogAlert(
      {required Function() navigation,
      required String title,
      required String message,
      String? confirm,
      String? cancel}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Center(
                    child: Text(title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ConstColors.app))),
              ),
              children: [
                SimpleDialogOption(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ConstColors.text),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ConstColors.appWhite),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                ConstColors.app),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: const BorderSide(
                                        color: ConstColors.app)))),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // _pagingController.refresh();
                          _activityBloc.add(RefreshUpcomingSessionEvent(
                              from: initialDateFilter.year.toString() +
                                  initialDateFilter.month
                                      .toString()
                                      .padLeft(2, "0") +
                                  initialDateFilter.day
                                      .toString()
                                      .padLeft(2, "0"),
                              to: initialDateFilter.year.toString() +
                                  initialDateFilter.month
                                      .toString()
                                      .padLeft(2, "0") +
                                  _getLastDayOfMonth(initialDateFilter.month
                                      .toString()
                                      .padLeft(2, "0"))));
                        },
                        child:
                            Text(confirm ?? translate(LangKeys.keepSession))),
                    const SizedBox(width: 20),
                    ElevatedButton(
                        onPressed: navigation,
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ))),
                        child: Text(cancel ?? translate(LangKeys.yesSure))),
                  ],
                )
              ],
            ));
  }

  _checkIfCorporateOrInsuranceOrNot({required CalculateSessionState state}) {
    if (state.calculateSessionFees.data?.corporateId != null ||
        state.calculateSessionFees.data?.insuranceId != null) {
      _checkCorporateAndInsuranceFees(state: state);
    } else {
      _checkFees(state: state);
    }
  }

  _checkCorporateAndInsuranceFees({required CalculateSessionState state}) {
    if (compensated == false &&
        state.calculateSessionFees.data!.feesPercentage! > 0 &&
        !state.calculateSessionFees.data!.flatRate! &&
        state.calculateSessionFees.data?.insuranceId != null) {
      _showDialogCancelInsurance(state: state);
    } else if (compensated == false &&
        state.calculateSessionFees.data!.feesPercentage! > 0 &&
        !state.calculateSessionFees.data!.flatRate! &&
        state.calculateSessionFees.data?.corporateId != null) {
      _showDialogCancelCorporate(state: state);
    } else if (compensated == false &&
        state.calculateSessionFees.data!.feesPercentage! == 0 &&
        !state.calculateSessionFees.data!.flatRate!) {
      // flat rate == false and cancel after 24 h so no fees needed .
      _showDialogCancel(state: state);
    } else if (compensated == false &&
        state.calculateSessionFees.data!.feesPercentage! > 0 &&
        state.calculateSessionFees.data!.flatRate!) {
      // flat rate == true mean cancel fees will take from my money so navigate to payment screen
      _showDialogAndNavigateToPayment(state: state);
    } else if (compensated == false &&
        state.calculateSessionFees.data!.feesPercentage == 0 &&
        state.calculateSessionFees.data!.flatRate!) {
      _showDialogCancel(state: state);
    } else if (compensated == true) {
      /// Will Not Cancel If "fees_percentage" == 0.0,
      /// else if "fees_percentage" > 0.0, or "fees_percentage" > 50.0, then will Not Canceled

      /// Compensated session can be cancelled >24 hr of session time
      /// Compensated session can’t be canceled <24 hr of session time
      if (state.calculateSessionFees.data!.feesPercentage! > 0.0) {
        _showDialogSessionCantBeCanceled();
      } else {
        _showDialogCancel(state: state);
      }
    }
  }

  _checkFees({required CalculateSessionState state}) {
    if (state.calculateSessionFees.data!.feesPercentage! > 0 &&
        compensated == true) {
      _showDialogSessionCantBeCanceled();
    } else if (state.calculateSessionFees.data!.feesPercentage! > 0 &&
        compensated == false) {
      _showDialogCancelWithAmountToSubtract(state: state);
    } else {
      _showDialogCancel(state: state);
    }
  }

  _showDialogAndNavigateToPayment({required CalculateSessionState state}) {
    showDialogAlert(
      title: translate(LangKeys.areYouSureYouWantToCancelThisSession),
      message: translate(LangKeys.cancellingWithin6Hours),
      navigation: () {
        context.read<ActivityBloc>().add(CancelActivityEvt(state.sessionId));
        Navigator.of(context).pop();
        Navigator.of(context)
            .pushNamed(PaymentCancelInDebtScreen.routeName, arguments: {
          "promoCode": "",
          "slotId": slotId.toString(),
          "sessionFees": state.calculateSessionFees.data!.feesAmount,
          "currency": state.calculateSessionFees.data!.currency,
          "sessionDate": sessionDate,
          "therapistName": therapistName,
          "therapistProfession": therapistProfession,
          "image": image
        });
      },
    );
  }

  _showDialogCancelInsurance({required CalculateSessionState state}) {
    showDialogAlert(
        title: translate(LangKeys.areYouSureYouWantToCancelThisSession),
        message: translate(LangKeys.cancelMsgPayedFromInsurance),
        navigation: () {
          context.read<ActivityBloc>().add(CancelActivityEvt(state.sessionId));
          Navigator.of(context).pop();
          context.read<ActivityBloc>().add(RefreshUpcomingSessionEvent(
              from: initialDateFilter.year.toString() +
                  initialDateFilter.month.toString().padLeft(2, "0") +
                  initialDateFilter.day.toString().padLeft(2, "0"),
              to: initialDateFilter.year.toString() +
                  initialDateFilter.month.toString().padLeft(2, "0") +
                  _getLastDayOfMonth(
                      initialDateFilter.month.toString().padLeft(2, "0"))));
        });
  }

  _showDialogCancel({required CalculateSessionState state}) {
    showDialogAlert(
      title: translate(LangKeys.areYouSureYouWantToCancelThisSession),
      message: translate(LangKeys.cancelAtNoCharge),
      navigation: () {
        context.read<ActivityBloc>().add(CancelActivityEvt(state.sessionId));
        Navigator.of(context).pop();
        context.read<ActivityBloc>().add(RefreshUpcomingSessionEvent(
            from: initialDateFilter.year.toString() +
                initialDateFilter.month.toString().padLeft(2, "0") +
                initialDateFilter.day.toString().padLeft(2, "0"),
            to: initialDateFilter.year.toString() +
                initialDateFilter.month.toString().padLeft(2, "0") +
                _getLastDayOfMonth(
                    initialDateFilter.month.toString().padLeft(2, "0"))));
      },
    );
  }

  _showDialogSessionCantBeCanceled() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(
              title: Center(
                  child: Text(
                translate(LangKeys.areYouSureYouWantToCancelThisSession),
                textAlign: TextAlign.center,
              )),
              children: [
                SimpleDialogOption(
                  child: Center(
                    child: Text(translate(LangKeys.sessionCannotBeCanceled),
                        textAlign: TextAlign.center),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: width / 4),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<ActivityBloc>().add(
                              RefreshUpcomingSessionEvent(
                                  from: initialDateFilter.year.toString() +
                                      initialDateFilter.month
                                          .toString()
                                          .padLeft(2, "0") +
                                      initialDateFilter.day
                                          .toString()
                                          .padLeft(2, "0"),
                                  to: initialDateFilter.year.toString() +
                                      initialDateFilter.month
                                          .toString()
                                          .padLeft(2, "0") +
                                      _getLastDayOfMonth(initialDateFilter.month
                                          .toString()
                                          .padLeft(2, "0"))));
                        },
                        child: Text(translate(LangKeys.confirm))))
              ],
            ));
  }

  _showDialogCancelCorporate({required CalculateSessionState state}) {
    showDialogAlert(
        title: translate(LangKeys.areYouSureYouWantToCancelThisSession),
        message:
            "${translate(LangKeys.a)} ${state.calculateSessionFees.data?.feesPercentage ?? ""} ${translate(LangKeys.cancellationFeeWillBeApplied)} ${state.calculateSessionFees.data?.refundAmount} ${state.calculateSessionFees.data?.currency} ${translate(LangKeys.willBeRefundedToOriginalMethod)}",
        navigation: () {
          context.read<ActivityBloc>().add(CancelActivityEvt(state.sessionId));
          Navigator.of(context).pop();
          context.read<ActivityBloc>().add(RefreshUpcomingSessionEvent(
              from: initialDateFilter.year.toString() +
                  initialDateFilter.month.toString().padLeft(2, "0") +
                  initialDateFilter.day.toString().padLeft(2, "0"),
              to: initialDateFilter.year.toString() +
                  initialDateFilter.month.toString().padLeft(2, "0") +
                  _getLastDayOfMonth(
                      initialDateFilter.month.toString().padLeft(2, "0"))));
        });
  }

  _showDialogCancelWithAmountToSubtract(
      {required CalculateSessionState state}) {
    showDialogAlert(
      title: translate(LangKeys.areYouSureYouWantToCancelThisSession),
      message:
          "${translate(LangKeys.a)} ${state.calculateSessionFees.data?.feesPercentage ?? ""} ${translate(LangKeys.cancellationFeeWillBeApplied)} ${state.calculateSessionFees.data?.refundAmount} ${state.calculateSessionFees.data?.currency} ${translate(LangKeys.willBeRefundedToOriginalMethod)}",
      navigation: () {
        context.read<ActivityBloc>().add(CancelActivityEvt(state.sessionId));
        Navigator.of(context).pop();
        context.read<ActivityBloc>().add(RefreshUpcomingSessionEvent(
            from: initialDateFilter.year.toString() +
                initialDateFilter.month.toString().padLeft(2, "0") +
                initialDateFilter.day.toString().padLeft(2, "0"),
            to: initialDateFilter.year.toString() +
                initialDateFilter.month.toString().padLeft(2, "0") +
                _getLastDayOfMonth(
                    initialDateFilter.month.toString().padLeft(2, "0"))));
      },
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)
          .whenComplete(() => context.read<ActivityBloc>().add(
              RefreshUpcomingSessionEvent(
                  from: initialDateFilter.year.toString() +
                      initialDateFilter.month.toString().padLeft(2, "0") +
                      initialDateFilter.day.toString().padLeft(2, "0"),
                  to: initialDateFilter.year.toString() +
                      initialDateFilter.month.toString().padLeft(2, "0") +
                      _getLastDayOfMonth(initialDateFilter.month
                          .toString()
                          .padLeft(2, "0")))));
      // _pagingController.refresh();
    } else {
      const snackBar = SnackBar(
        content: Text("Please, Install Zoom First"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  //Get last day of month
  String _getLastDayOfMonth(String month) {
    switch (month) {
      case "01":
        return "31";
      case "02":
        return DateTime(initialDateFilter.year, 3, 0).day.toString();
      case "03":
        return "31";
      case "04":
        return "30";
      case "05":
        return "31";
      case "06":
        return "30";
      case "07":
        return "31";
      case "08":
        return "31";
      case "09":
        return "30";
      case "10":
        return "31";
      case "11":
        return "30";
      case "12":
        return "31";
      default:
        return "30";
    }
  }
}
