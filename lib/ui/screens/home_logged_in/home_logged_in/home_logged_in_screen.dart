import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gr_zoom/gr_zoom.dart';

// import 'package:flutter_zoom_sdk/zoom_options.dart';
// import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/adjust_manager.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/mixpanel_manager.dart';
import 'package:o7therapy/api/models/available_slots/AvailableSlotsWrapper.dart';
import 'package:o7therapy/api/zoom_constants.dart';
import 'package:o7therapy/bloc/mixpanel_booking_bloc/mixpanel_booking_bloc.dart';
import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/activity/bloc/activity_bloc.dart';
import 'package:o7therapy/ui/screens/activity/reschedule_screen/reschedule_payment_screen.dart';
import 'package:o7therapy/ui/screens/activity/reschedule_screen/reschedule_screen.dart';
import 'package:o7therapy/ui/screens/activity/widgets/upcoming_session_card.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';

import 'package:o7therapy/ui/screens/booking/widgets/booking_screen_icon.dart';
import 'package:o7therapy/ui/screens/booking/widgets/one_on_one_sessions_page/therapist_card.dart';
import 'package:o7therapy/ui/screens/checkout/payment_details/payment_cancel_indebt.dart';
import 'package:o7therapy/ui/screens/checkout/success_payment_screen/success_payment_screen.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/faqs_widget.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/footer_widget.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/header_text_widget.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/how_it_works_widget.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/intro_mental_health_video.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/mental_health_video.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/reviews_card.dart';
import 'package:o7therapy/ui/screens/home_logged_in/home_screen_therapists_bloc/home_screen_therapists_bloc.dart';
import 'package:o7therapy/ui/screens/home_logged_in/widgets/book_a_session_button_in_home_logged_in.dart';
import 'package:o7therapy/ui/screens/home_logged_in/widgets/book_a_session_card.dart';
import 'package:o7therapy/ui/screens/home_logged_in/widgets/home_logged_in_therapist_list.dart';
import 'package:o7therapy/ui/screens/home_logged_in/widgets/home_screen_get_matching_card.dart';
import 'package:o7therapy/ui/screens/home_logged_in/widgets/how_to_book_a_session_logged_in_user.dart';
import 'package:o7therapy/ui/screens/home_logged_in/widgets/therapists_card.dart';
import 'package:o7therapy/ui/screens/profile/widgets/custom_rounded_button.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/rassel_trial_card_home_screen_logged_in_user.dart';
import 'package:o7therapy/ui/widgets/video_player/video_screen.dart';
import 'package:o7therapy/util/general.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:o7therapy/api/models/available_slots_datetime/Data.dart';
import 'package:o7therapy/util/ui/screen_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeLoggedInScreen extends BaseStatefulWidget {
  static const routeName = '/home-logged-in-screen';

  const HomeLoggedInScreen({Key? key}) : super(key: key);

  @override
  BaseState<BaseStatefulWidget> baseCreateState() => _HomeLoggedInScreenState();
}

class _HomeLoggedInScreenState extends BaseState<HomeLoggedInScreen>
    with WidgetsBindingObserver {
  bool isBookedBefore = true;
  bool compensated = false;
  AvailableSlotsWrapper availableSlots = AvailableSlotsWrapper();
  double sessionFees = 0;
  String currency = "";
  int slotId = 0;
  late Timer timer;
  String therapistName = "";
  String sessionDate = "";
  int sessionId = 0;
  String therapistProfession = "";
  String image = "";
  bool requirePayment = true;
  bool dismissUpcoming = false;

  late final Mixpanel _mixpanel;

  @override
  void initState() {
    super.initState();
    // Track with event-name
    _initMixpanel();
    WidgetsBinding.instance.addObserver(this);
    AdjustManager.initPlatformState();
    context.read<ActivityBloc>().add(HomeUpcomingSessionEvent(
        from: DateTime.now().year.toString() +
            DateTime.now().month.toString() +
            DateTime.now().day.toString(),
        to: DateTime.now().year.toString() +
            DateTime.now().month.toString() +
            _getLastDayOfMonth(DateTime.now().month.toString())));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        Adjust.onResume();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  // Widget baseBuild(BuildContext context) {
  //   return Scaffold(
  //     body: _getBody(),
  //   );
  Widget baseBuild(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      switch (orientation) {
        case Orientation.portrait:
          return Scaffold(
            body: _getBody(),
          );
        case Orientation.landscape:
          return const MentalHealthVideo(
              videoUrl: 'https://www.youtube.com/watch?v=nKrpV2RI7-Y');
        default:
          return Scaffold(
            body: _getBody(),
          );
      }
    });
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

//Get the content of home guest screen
  Widget _getBody() {
    // return MentalHealthVideo(videoUrl: 'videoUrl');
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeScreenMatchingCallCard(),
            const RasselTrialCardHomeScreenLoggedInUser(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 20.0),
            //   child: SizedBox(width: width, height: 40, child: _searchField()),
            // ),
            // FilterWidget(
            //     filterList: [
            //       translate(LangKeys.sleeping),
            //       translate(LangKeys.anxiety),
            //       translate(LangKeys.stress),
            //       translate(LangKeys.depression),
            //       translate(LangKeys.angerManagement),
            //       translate(LangKeys.relationships),
            //       translate(LangKeys.grief)
            //     ],
            //     onPressed: () => Navigator.of(context)
            //         .pushNamed(FilteredGuestScreen.routeName)),
            dismissUpcoming
                ? const SizedBox.shrink()
                : BlocConsumer<ActivityBloc, ActivityState>(
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
                              LoginScreen.routeName,
                              (Route<dynamic> route) => false);
                        }
                        showToast(state.message);
                        // context
                        //     .read<ActivityBloc>()
                        //     .add(const RefreshUpcomingSessionEvent());
                      } else if (state is ErrorState) {
                        if (state.message == "Session expired") {
                          clearData();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              LoginScreen.routeName,
                              (Route<dynamic> route) => false);
                        }
                        showToast(state.message);
                        // context
                        //     .read<ActivityBloc>()
                        //     .add(const RefreshUpcomingSessionEvent());
                      }
                      if (state is CompensatedSessionState) {
                        if (state.sessionCompensated.data == true) {
                          compensated = true;
                        } else {
                          compensated = false;
                        }
                        context.read<ActivityBloc>().add(
                            CalculateSessionCancellationFeesActivityEvt(
                                state.sessionId));
                      }
                      if (state is CalculateSessionState) {
                        // check first is corporate or insurance or not
                        _checkIfCorporateOrInsuranceOrNot(state: state);
                      }
                      if (state is CancelSessionState) {
                        // _pagingController.refresh();
                        MixpanelBookingBloc.bloc(context)
                            .add(const SuccessfulCancelBookingEvent());

                        context.read<ActivityBloc>().add(
                            RefreshUpcomingSessionEvent(
                                from: DateTime.now().year.toString() +
                                    DateTime.now().month.toString() +
                                    DateTime.now().day.toString(),
                                to: DateTime.now().year.toString() +
                                    DateTime.now().month.toString() +
                                    _getLastDayOfMonth(
                                        DateTime.now().month.toString())));
                        showToast(
                            translate(LangKeys.sessionCancelledSuccessfully));
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
                                        child: Text(translate(LangKeys.oops),
                                            textAlign: TextAlign.center)),
                                    children: [
                                      SimpleDialogOption(
                                        child: Center(
                                          child: Text(
                                              "${state.therapistName} ${translate(LangKeys.noAvailableSlots)}",
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 4),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                context.read<ActivityBloc>().add(
                                                    RefreshUpcomingSessionEvent(
                                                        from: DateTime.now()
                                                                .year
                                                                .toString() +
                                                            DateTime.now()
                                                                .month
                                                                .toString() +
                                                            DateTime.now()
                                                                .day
                                                                .toString(),
                                                        to: DateTime.now()
                                                                .year
                                                                .toString() +
                                                            DateTime.now()
                                                                .month
                                                                .toString() +
                                                            _getLastDayOfMonth(
                                                                DateTime.now()
                                                                    .month
                                                                    .toString())));
                                              },
                                              child: Text(
                                                  translate(LangKeys.confirm))))
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
                        sessionFees =
                            state.calculateSessionFees.data!.feesAmount!;
                        currency =
                            state.calculateSessionFees.data!.currency ?? "";
                        slotId = state.slotId;
                        therapistName = state.therapistName;
                        sessionDate = state.sessionDate;
                        sessionId = state.sessionId;
                        therapistProfession = state.therapistProfession;
                        image = state.image;

                        if (compensated == true) {
                          if (state.calculateSessionFees.data!.feesPercentage! >
                              0) {
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
                                                translate(LangKeys
                                                    .sessionCannotBeCanceled),
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width / 4),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  context.read<ActivityBloc>().add(
                                                      RefreshUpcomingSessionEvent(
                                                          from: DateTime.now()
                                                                  .year
                                                                  .toString() +
                                                              DateTime.now()
                                                                  .month
                                                                  .toString() +
                                                              DateTime.now()
                                                                  .day
                                                                  .toString(),
                                                          to: DateTime.now()
                                                                  .year
                                                                  .toString() +
                                                              DateTime.now()
                                                                  .month
                                                                  .toString() +
                                                              _getLastDayOfMonth(
                                                                  DateTime.now()
                                                                      .month
                                                                      .toString())));
                                                },
                                                child: Text(translate(
                                                    LangKeys.confirm))))
                                      ],
                                    ));
                          } else {
                            requirePayment = false;
                            //todo: confirm rescheduling
                            showDialogAlert(
                              title: translate(LangKeys
                                  .areYouSureYouWantToRescheduleThisSession),
                              message: translate(LangKeys.rescheduleAtNoCharge),
                              navigation: () {
                                List<Data> slots = [];
                                for (var element in availableSlots.data!) {
                                  slots.add(Data(
                                      id: element.id,
                                      from: _getDate(element.from!),
                                      to: _getDate(element.to!)));
                                }
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed(
                                    RescheduleScreen.routeName,
                                    arguments: {
                                      "therapistId": state.therapistId,
                                      'availableSlots': slots,
                                      'sessionId': state.sessionId.toString(),
                                      "therapistName": state.therapistName,
                                      "therapistProfession":
                                          state.therapistProfession,
                                      "sessionDate": state.sessionDate,
                                      "currency": state.currency,
                                      "sessionFees": 0.0,
                                      "image": state.image,
                                      "requirePayment": false
                                    }).then((value) {
                                  // _pagingController.refresh();
                                  context.read<ActivityBloc>().add(
                                      RefreshUpcomingSessionEvent(
                                          from: DateTime.now().year.toString() +
                                              DateTime.now().month.toString() +
                                              DateTime.now().day.toString(),
                                          to: DateTime.now().year.toString() +
                                              DateTime.now().month.toString() +
                                              _getLastDayOfMonth(DateTime.now()
                                                  .month
                                                  .toString())));
                                });
                              },
                            );
                          }
                        } else {
                          if (state.calculateSessionFees.data!.feesPercentage ==
                              0) {
                            requirePayment = false;
                            //todo: confirm rescheduling
                            showDialogAlert(
                              title: translate(LangKeys
                                  .areYouSureYouWantToRescheduleThisSession),
                              message: translate(LangKeys.rescheduleAtNoCharge),
                              navigation: () {
                                List<Data> slots = [];
                                for (var element in availableSlots.data!) {
                                  slots.add(Data(
                                      id: element.id,
                                      from: _getDate(element.from!),
                                      to: _getDate(element.to!)));
                                }
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed(
                                    RescheduleScreen.routeName,
                                    arguments: {
                                      "therapistId": state.therapistId,
                                      'availableSlots': slots,
                                      'sessionId': state.sessionId.toString(),
                                      "therapistName": state.therapistName,
                                      "therapistProfession":
                                          state.therapistProfession,
                                      "sessionDate": state.sessionDate,
                                      "currency": state.currency,
                                      "sessionFees": 0.0,
                                      "image": state.image,
                                      "requirePayment": false
                                    }).then((value) {
                                  // _pagingController.refresh();
                                  context.read<ActivityBloc>().add(
                                      RefreshUpcomingSessionEvent(
                                          from: DateTime.now().year.toString() +
                                              DateTime.now().month.toString() +
                                              DateTime.now().day.toString(),
                                          to: DateTime.now().year.toString() +
                                              DateTime.now().month.toString() +
                                              _getLastDayOfMonth(DateTime.now()
                                                  .month
                                                  .toString())));
                                });
                              },
                            );
                          } else {
                            if (state.calculateSessionFees.data!.flatRate ==
                                true) {
                              //todo: require payment
                              requirePayment = true;
                              sessionFees =
                                  state.calculateSessionFees.data!.feesAmount!;
                              showDialogAlert(
                                title: translate(LangKeys
                                    .areYouSureYouWantToRescheduleThisSession),
                                message: translate(LangKeys
                                    .rescheduleWithin6HoursBeforeSession),
                                navigation: () {
                                  List<Data> slots = [];
                                  for (var element in availableSlots.data!) {
                                    slots.add(Data(
                                        id: element.id,
                                        from: _getDate(element.from!),
                                        to: _getDate(element.to!)));
                                  }
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamed(
                                      RescheduleScreen.routeName,
                                      arguments: {
                                        "therapistId": state.therapistId,
                                        'availableSlots': slots,
                                        'sessionId': state.sessionId.toString(),
                                        "therapistName": state.therapistName,
                                        "therapistProfession":
                                            state.therapistProfession,
                                        "sessionDate": state.sessionDate,
                                        "currency": state.currency,
                                        "sessionFees": state
                                            .calculateSessionFees
                                            .data!
                                            .feesAmount,
                                        "image": state.image,
                                        "requirePayment": true
                                      }).then((value) {
                                    // _pagingController.refresh();
                                    context.read<ActivityBloc>().add(
                                        RefreshUpcomingSessionEvent(
                                            from: DateTime.now()
                                                    .year
                                                    .toString() +
                                                DateTime.now()
                                                    .month
                                                    .toString() +
                                                DateTime.now().day.toString(),
                                            to: DateTime.now().year.toString() +
                                                DateTime.now()
                                                    .month
                                                    .toString() +
                                                _getLastDayOfMonth(
                                                    DateTime.now()
                                                        .month
                                                        .toString())));
                                  });
                                },
                              );
                            } else {
                              //todo: go to payment page
                              requirePayment = true;
                              showDialogAlert(
                                title: translate(LangKeys
                                    .areYouSureYouWantToRescheduleThisSession),
                                message:
                                    '${translate(LangKeys.a)} ${state.calculateSessionFees.data!.feesPercentage!} ${translate(LangKeys.rescheduleFeeWillBeApplied)}',
                                navigation: () {
                                  List<Data> slots = [];
                                  for (var element in availableSlots.data!) {
                                    slots.add(Data(
                                        id: element.id,
                                        from: _getDate(element.from!),
                                        to: _getDate(element.to!)));
                                  }
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamed(
                                      RescheduleScreen.routeName,
                                      arguments: {
                                        "therapistId": state.therapistId,
                                        'availableSlots': slots,
                                        'sessionId': state.sessionId.toString(),
                                        "therapistName": state.therapistName,
                                        "therapistProfession":
                                            state.therapistProfession,
                                        "sessionDate": state.sessionDate,
                                        "currency": state.currency,
                                        "sessionFees": state
                                            .calculateSessionFees
                                            .data!
                                            .feesAmount,
                                        "image": state.image,
                                        "requirePayment": true
                                      }).then((value) {
                                    // _pagingController.refresh();
                                    context.read<ActivityBloc>().add(
                                        RefreshUpcomingSessionEvent(
                                            from: DateTime.now()
                                                    .year
                                                    .toString() +
                                                DateTime.now()
                                                    .month
                                                    .toString() +
                                                DateTime.now().day.toString(),
                                            to: DateTime.now().year.toString() +
                                                DateTime.now()
                                                    .month
                                                    .toString() +
                                                _getLastDayOfMonth(
                                                    DateTime.now()
                                                        .month
                                                        .toString())));
                                  });
                                },
                              );
                            }
                          }
                        }
                      }
                      if (state is RescheduleSessionState) {
                        if (state.rescheduleSession.data!.requirePayment ==
                            false) {
                          showToast(translate(
                              LangKeys.sessionRescheduledSuccessfully));

                          /// send event to mixpanel
                          MixpanelBookingBloc.bloc(context).add(
                            SuccessfulSessionRescheduleEvent(
                              newSessionId: state.sessionId.toString(),
                              newSlotStringDateTimeInUtc:
                                  getUtcDateTimeFromBackEndLocalTimeString(
                                state.sessionDate,
                              ),
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
                              navigation: () => Navigator.of(context)
                                      .pushReplacementNamed(
                                          ReschedulePaymentScreen.routeName,
                                          arguments: {
                                        "slotId": slotId.toString(),
                                        "sessionFees": sessionFees,
                                        "sessionDate": sessionDate,
                                        "currency": currency,
                                        "therapistName": therapistName,
                                        "therapistProfession":
                                            therapistProfession,
                                        "image": image,
                                        "sessionId": sessionId
                                      }),
                              title:
                                  translate(LangKeys.youHaveAccumulativeFees),
                              message:
                                  '${translate(LangKeys.youHaveAccumulativeFees)} $sessionFees');
                        }
                      }

                      if (state is ConfirmStatusState) {
                        context.read<ActivityBloc>().add(RefreshPastSessionEvent(
                            from: DateTime.now().year.toString() +
                                DateTime.now().month.toString() +
                                _getLastDayOfMonth(
                                    DateTime.now().month.toString()),
                            to: "${DateTime.now().year}${DateTime.now().month}01"));
                      }
                      if (state is JoinSessionState) {
                        _setZoomURl(
                            state.joinSession.data!.participantMeetingUrl ??
                                "");
                        if (state.joinSession.data!.enforceSwitch == true) {
                          _launchUrl(
                              state.joinSession.data!.participantMeetingUrl!);
                        } else {
                          _launchUrl(
                              state.joinSession.data!.participantMeetingUrl!);
                          // joinMeeting(
                          //     context,
                          //     state.joinSession.data!.meetingId!,
                          //     state.joinSession.data!.meetingPassword ?? "");
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is HomeUpcomingSessionsState &&
                          state.sessions.isNotEmpty) {
                        isBookedBefore = true;
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                HeaderWidget(
                                  text: translate(LangKeys.upcomingSessions),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                              HomeMainLoggedInScreen.routeName,
                                              (route) => false,
                                              arguments: HomeMainLoggedInPages
                                                  .activityLoggedInScreen,
                                            );
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                            translate(LangKeys.seeAll),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: ConstColors.secondary,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: height / 4,
                                child: UpcomingSessionCard(
                                    sessions: state.sessions.first)),
                          ],
                        );
                      } else {
                        isBookedBefore = false;
                        return BookASessionCard(
                          onPressed: () {
                            ///Track events
                            _mixpanel.track("Book a Session");
                            Adjust.trackEvent(AdjustManager.buildSimpleEvent(
                                eventToken: ApiKeys.bookASessionEventToken));

                            Navigator.of(context).pushNamedAndRemoveUntil(
                              HomeMainLoggedInScreen.routeName,
                              (route) => false,
                              arguments: HomeMainLoggedInPages.bookingScreen,
                            );
                          },
                          translate: translate,
                        );
                      }
                    },
                  ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     HeaderWidget(text: translate(LangKeys.yourMatchedTherapists)),
            //     Padding(
            //       padding: const EdgeInsets.only(top: 17.0, bottom: 5),
            //       child: _getTextButton(translate(LangKeys.dismiss), () {}),
            //     ),
            //   ],
            // ),
            // _topTherapistsListHorizontal(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     HeaderWidget(text: translate(LangKeys.mentalHealthJourney)),
            //     Padding(
            //       padding: const EdgeInsets.only(top: 17.0, bottom: 5),
            //       child: _getTextButton(translate(LangKeys.seeAll), () {}),
            //     ),
            //   ],
            // ),
            // MentalHealthJourneyCard(
            //   context: context,
            // ),
            // isBookedBefore ? Container() : _takeTheTestCard(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     HeaderWidget(text: translate(LangKeys.pickedForYou)),
            //     _getTextButton(translate(LangKeys.seeAll), () {}),
            //   ],
            // ),
            // DiscoverWidget(
            //     titles: ['How Deep Is Your Sleep?', 'How Deep Is Your Sleep?'],
            //     date: ['Published 01-01-2022', 'Published 01-01-2022'],
            //     readTime: ['7 min read', '7 min read']),

            const HowToBookASessionLoggedInUser(),
            const IntroMentalHealthVideo(),
            const ReviewsCardWidget(),
            // HeaderWidget(text: translate(LangKeys.ourServices)),
            // ServicesWidget(
            //   servicesTitle: [
            //     translate(LangKeys.oneOnOneSessions),
            //     translate(LangKeys.couplesTherapy),
            //     translate(LangKeys.assessmentsAndTesting),
            //     translate(LangKeys.workshops),
            //     translate(LangKeys.groupTherapy),
            //     translate(LangKeys.programs)
            //   ],
            //   servicesIcons: const [
            //     AssPath.oneOnOne,
            //     AssPath.coupleTherapy,
            //     AssPath.assessmentAndTesting,
            //     AssPath.workshopsAndWebinar,
            //     AssPath.groupTherapy,
            //     AssPath.programs
            //   ],
            // ),

            const HomeLoggedInTherapistList(),
            const BookASessionButtonInHomeLoggedIn(),
            const FaqsWidget(fromGuestScreen: false),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     HeaderWidget(text: translate(LangKeys.discover)),
            //     _getTextButton(translate(LangKeys.seeAll), () {}),
            //   ],
            // ),
            // DiscoverWidget(
            //     titles: ['How Deep Is Your Sleep?', 'How Deep Is Your Sleep?'],
            //     date: ['Published 01-01-2022', 'Published 01-01-2022'],
            //     readTime: ['7 min read', '7 min read']),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return SizedBox(
      height: 0.06 * height,
      child: TextField(
        style: const TextStyle(fontSize: 14.0),
        onChanged: (value) {},
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: translate(LangKeys.search),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 0.04 * width, vertical: 0.012 * height),
            child: SvgPicture.asset(AssPath.searchIcon),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 0.03 * width, vertical: 0.002 * height),
            child: BookingScreenIcon(
              assetPath: AssPath.filterIcon,
              onTap: () {
                // TODO :: The group icon in the serach bar clicked
                log("The group icon in the serach bar clicked");
              },
            ),
          ),
          border: const OutlineInputBorder(
              gapPadding: 9.0,
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
              borderSide: BorderSide(width: 1, color: ConstColors.disabled)),
          disabledBorder: const OutlineInputBorder(
              gapPadding: 9.0,
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
              borderSide: BorderSide(width: 1, color: ConstColors.disabled)),
          enabledBorder: const OutlineInputBorder(
              gapPadding: 9.0,
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
              borderSide: BorderSide(width: 1, color: ConstColors.disabled)),
        ),
      ),
    );
  }

// get the 2 icons of message and the bell
  Widget _getBellIconAndMessageIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BookingScreenIcon(
          assetPath: AssPath.messageSquareIcon,
          onTap: () {
            // TODO :: on pressed on the message icon
            log("the message icon Pressed");
          },
        ),
        // IconButton(
        //   // TODO :: on pressed on the message icon
        //   onPressed: () {},
        //   iconSize: 6,
        //   icon: Image.asset(AssPath.messageSquareIcon),
        // ),
        SizedBox(width: 0.05 * width),
        BookingScreenIcon(
          assetPath: AssPath.bellIcon,
          onTap: () {
            // TODO :: on pressed on the message icon
            log("the Bell icon Pressed");
          },
        ),
        // IconButton(
        //   // TODO :: on pressed on the Bell icon
        //   onPressed: () {},
        //   iconSize: 6,
        //   icon: Image.asset(AssPath.bellIcon),
        // ),
      ],
    );
  }

  Widget _takeTheTestCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Image.asset(AssPath.getStartedCardBg, matchTextDirection: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
              child: SizedBox(
                width: width * 0.40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _getTwoColoredText(),
                    _getText(),
                    _getStartedButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTwoColoredText() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '${translate(LangKeys.wellnessBeginsWithYour)} '),
          TextSpan(
            text: '${translate(LangKeys.mentalHealth)} ',
            style: const TextStyle(color: ConstColors.secondary),
          ),
          // TextSpan(text: translate(LangKeys.wellBeingStart)),
          const TextSpan(
              text: '.', style: TextStyle(color: ConstColors.accentColor)),
        ],
      ),
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w700, color: ConstColors.app),
    );
  }

  Widget _getText() {
    return Padding(
      padding: EdgeInsets.only(top: height / 50.0),
      child: Text(
        translate(LangKeys.wellBeingStartDesc),
        style: const TextStyle(
            fontWeight: FontWeight.w400, fontSize: 14, color: ConstColors.text),
      ),
    );
  }

  Widget _getStartedButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        top: height / 50,
      ),
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed: () {
            ///Track events
            _mixpanel.track("Book a Session");
            Adjust.trackEvent(AdjustManager.buildSimpleEvent(
                eventToken: ApiKeys.bookASessionEventToken));

            /// this will navigate the user to home main that contains app bar and bottom bar
            /// but with index 1 === is the booking screen
            Navigator.of(context).pushNamedAndRemoveUntil(
              HomeMainLoggedInScreen.routeName,
              (route) => false,
              arguments: HomeMainLoggedInPages.bookingScreen,
            );
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Text(translate(LangKeys.bookASession)),
        ),
      ),
    );
  }

  Widget _getTextButton(String buttonText, Function() onPressed) {
    return CustomRoundedButton(
        fontsize: 14,
        onPressed: onPressed,
        text: buttonText,
        widthValue: width * 0.64);
  }

//Top therapists widget
  Widget _topTherapistsList() {
    // return SizedBox();
    return BlocBuilder<HomeScreenTherapistsBloc, HomeScreenTherapistsState>(
      builder: (context, state) {
        if (state is LoadedHomeScreenTherapistsState) {
          return ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: state.therapists.length,
              itemBuilder: (context, index) =>
                  TherapistCard(therapistModel: state.therapists[index]));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _topTherapistsListHorizontal() {
    return SizedBox(
      height: height / 5.2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        primary: false,
        itemCount: therapists.length,
        itemBuilder: (ctx, index) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            width: width * 0.85,
            child: TherapistCardHorizontal(
              therapistModel: therapists[index],
            )),
      ),
    );
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////

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
                          context.read<ActivityBloc>().add(
                              RefreshUpcomingSessionEvent(
                                  from: DateTime.now().year.toString() +
                                      DateTime.now().month.toString() +
                                      DateTime.now().day.toString(),
                                  to: DateTime.now().year.toString() +
                                      DateTime.now().month.toString() +
                                      _getLastDayOfMonth(
                                          DateTime.now().month.toString())));
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

  void _setZoomURl(String url) async {
    await PrefManager.setZoomUrl(url);
  }

  // /// API KEY & SECRET is required for below methods to work
  // /// Join Meeting With Meeting ID & Password
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
  //             context
  //                 .read<ActivityBloc>()
  //                 .add(const RefreshUpcomingSessionEvent());
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
  //             zoom.meetingStatus(meetingOptions.meetingId!).then((status) {
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

  DateTime _getDate(String date) {
    String year = date.substring(0, 4);
    String month = date.substring(4, 6);
    String day = date.substring(6, 8);
    String hour = date.substring(8, 10);
    String minute = date.substring(10, 12);
    String second = date.substring(12, 14);
    String formattedDate = "$year-$month-${day}T$hour:$minute:${second}Z";
    return DateTime.parse(formattedDate).toLocal();
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
      // flat rate == false mean cancel fees will be deducted from your session balance if cancel before 24 h.
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
          "currency": currency,
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
              from: DateTime.now().year.toString() +
                  DateTime.now().month.toString() +
                  DateTime.now().day.toString(),
              to: DateTime.now().year.toString() +
                  DateTime.now().month.toString() +
                  _getLastDayOfMonth(DateTime.now().month.toString())));
        });
  }

  _showDialogCancelCorporate({required CalculateSessionState state}) {
    showDialogAlert(
        title: translate(LangKeys.areYouSureYouWantToCancelThisSession),
        message:
            "${translate(LangKeys.a)} ${state.calculateSessionFees.data?.feesPercentage ?? ""} ${translate(LangKeys.cancellationFeeWillBeApplied)} ${state.calculateSessionFees.data?.refundAmount} ${translateCurrency(state.calculateSessionFees.data?.currency)} ${translate(LangKeys.willBeRefundedToOriginalMethod)}",
        navigation: () {
          context.read<ActivityBloc>().add(CancelActivityEvt(state.sessionId));
          Navigator.of(context).pop();
          context.read<ActivityBloc>().add(RefreshUpcomingSessionEvent(
              from: DateTime.now().year.toString() +
                  DateTime.now().month.toString() +
                  DateTime.now().day.toString(),
              to: DateTime.now().year.toString() +
                  DateTime.now().month.toString() +
                  _getLastDayOfMonth(DateTime.now().month.toString())));
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
            from: DateTime.now().year.toString() +
                DateTime.now().month.toString() +
                DateTime.now().day.toString(),
            to: DateTime.now().year.toString() +
                DateTime.now().month.toString() +
                _getLastDayOfMonth(DateTime.now().month.toString())));
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
                                  from: DateTime.now().year.toString() +
                                      DateTime.now().month.toString() +
                                      DateTime.now().day.toString(),
                                  to: DateTime.now().year.toString() +
                                      DateTime.now().month.toString() +
                                      _getLastDayOfMonth(
                                          DateTime.now().month.toString())));
                        },
                        child: Text(translate(LangKeys.confirm))))
              ],
            ));
  }

  _showDialogCancelWithAmountToSubtract(
      {required CalculateSessionState state}) {
    showDialogAlert(
      title: translate(LangKeys.areYouSureYouWantToCancelThisSession),
      message:
          "${translate(LangKeys.a)} ${state.calculateSessionFees.data?.feesPercentage ?? ""} ${translate(LangKeys.cancellationFeeWillBeApplied)} ${state.calculateSessionFees.data?.refundAmount} ${translateCurrency(state.calculateSessionFees.data?.currency)} ${translate(LangKeys.willBeRefundedToOriginalMethod)}",
      navigation: () {
        context.read<ActivityBloc>().add(CancelActivityEvt(state.sessionId));
        Navigator.of(context).pop();
        context.read<ActivityBloc>().add(RefreshUpcomingSessionEvent(
            from: DateTime.now().year.toString() +
                DateTime.now().month.toString() +
                DateTime.now().day.toString(),
            to: DateTime.now().year.toString() +
                DateTime.now().month.toString() +
                _getLastDayOfMonth(DateTime.now().month.toString())));
      },
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      const snackBar = SnackBar(
        content: Text("Please, Install Zoom First"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
  }

  //Get last day of month
  String _getLastDayOfMonth(String month) {
    switch (month) {
      case "01":
        return "31";
      case "02":
        return DateTime(DateTime.now().year, 3, 0).day.toString();
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
