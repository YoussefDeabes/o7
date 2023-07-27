import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/models/activity/list.dart';
import 'package:o7therapy/api/models/join_session/JoinSessionWrapper.dart';
import 'package:o7therapy/bloc/mixpanel_booking_bloc/mixpanel_booking_bloc.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/activity/bloc/activity_bloc.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';
import 'package:o7therapy/util/date_time_helper.dart';
import 'package:o7therapy/util/general.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/count_down_timer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class UpcomingSessionCard extends BaseStatefulWidget {
  final ListData sessions;

  const UpcomingSessionCard({Key? key, required this.sessions})
      : super(key: key);

  @override
  BaseState<UpcomingSessionCard> baseCreateState() =>
      _UpcomingSessionCardState();
}

class _UpcomingSessionCardState extends BaseState<UpcomingSessionCard> {
  JoinSessionWrapper joinSession = JoinSessionWrapper();

  @override
  void initState() {
    if (_getDifferenceInSeconds() != null && _getDifferenceInSeconds()! > 0) {
      Timer(Duration(seconds: _getDifferenceInSeconds()! - 300), () {
        if (mounted) {
          setState(() {});
        }
      });

      Timer(Duration(seconds: _getDifferenceInSeconds()!), () {
        if (mounted) {
          setState(() {});
        }
      });
    }
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4.0),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: _getCardShape(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            _dateContainer(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _therapistDetails(),
                                  const SizedBox(height: 10),
                                  _sessionDetails()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _therapistImageAndTime(),
                    ],
                  ),
                  lineDivider(width: width * 0.80),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _isSessionInTime()
                            ? const SizedBox.shrink()
                            // ? TextButton(
                            //     onPressed: _isSessionInTime() &&
                            //             widget.sessions.status == 2
                            //         ? () async {
                            //             final url =
                            //                 await PrefManager.getZoomUrl();
                            //             _launchUrl(url!);
                            //           }
                            //         : null,
                            //     child: Text(translate(LangKeys.launchZoom)))
                            : const SizedBox.shrink(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _isSessionInTime()
                                ? Container()
                                : _cancelButton(state),
                            const SizedBox(
                              width: 20,
                            ),
                            _isSessionInTime()
                                ? _joinSessionButton(state)
                                : _rescheduleButton(state)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
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

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  ShapeBorder _getCardShape() {
    return RoundedRectangleBorder(
        borderRadius: Directionality.of(context).index == 1
            ? const BorderRadius.only(
                bottomLeft: Radius.zero,
                bottomRight: Radius.circular(16),
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16))
            : const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.zero,
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16)),
        side: const BorderSide(color: ConstColors.disabled));
  }

  Widget _dateContainer() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.zero,
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16)),
      child: Container(
        height: height / 9,
        width: width / 7,
        color: ConstColors.app.withOpacity(0.10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat("dd").format(
                DateTime.parse(DateTimeHelper.getFormattedDateString(
                        widget.sessions.dateFrom!))
                    .toLocal(),
              ),
              style: const TextStyle(
                  color: ConstColors.app,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              DateFormat("MMM").format(
                DateTime.parse(DateTimeHelper.getFormattedDateString(
                        widget.sessions.dateFrom!))
                    .toLocal(),
              ),
              style: const TextStyle(
                  color: ConstColors.app,
                  fontSize: 11,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _therapistDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.sessions.therapistName!,
          style: const TextStyle(
              color: ConstColors.app,
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
        Wrap(
          children: [
            SizedBox(
              width: width * 0.35,
              child: Text(
                widget.sessions.therapistProfession!,
                maxLines: 1,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: ConstColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sessionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(LangKeys.fiftyMinutes),
          style: const TextStyle(
              color: ConstColors.app,
              fontSize: 12,
              fontWeight: FontWeight.w600),
        ),
        Text(
          translate(LangKeys.oneOnOneSession),
          style: const TextStyle(
              color: ConstColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _therapistImageAndTime() {
    CountdownTimer? countdownTimer;
    if (_getDifferenceInSeconds() != null &&
        _getDifferenceInSeconds()! <= 300 &&
        _getDifferenceInSeconds()! > 0) {
      countdownTimer = CountdownTimer(seconds: _getDifferenceInSeconds()!);
    }
    return Column(
      children: [
        SizedBox(
          height: width / 6,
          width: width / 6,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: CachedNetworkImage(
              imageUrl: ApiKeys.baseUrl + widget.sessions.therapistImage!.url!,
              fit: BoxFit.fitHeight,
              placeholder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.black12,
                highlightColor: Colors.white,
                child: Container(
                  height: double.infinity,
                  width: 0.27 * width,
                  decoration: const BoxDecoration(color: Colors.black26),
                ),
              ),
              errorWidget: (context, url, error) => const SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(child: Icon(Icons.error))),
            ),
          ),
        ),
        SizedBox(
          height: height / 90,
        ),
        _getDifferenceInSeconds() != null &&
                _getDifferenceInSeconds()! <= 300 &&
                _getDifferenceInSeconds()! > 0
            ? StreamBuilder<int>(
                stream: countdownTimer!.countdown(),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    int seconds = snapshot.data!;
                    String timeSec = '00:00';
                    if (snapshot.hasData) {
                      timeSec =
                          '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
                    }
                    return Text(
                      timeSec,
                      style: const TextStyle(
                          color: ConstColors.counterColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    );
                  }
                  return const SizedBox();
                },
              )
            : Text(
                _isSessionInTime()
                    ? '00:00'
                    : DateFormat().add_jm().format(DateTime.parse(
                            DateTimeHelper.getFormattedDateString(
                                widget.sessions.dateFrom!))
                        .toLocal()),
                style: TextStyle(
                    color: _isSessionInTime()
                        ? ConstColors.counterColor
                        : ConstColors.accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              )
      ],
    );
  }

  Widget _cancelButton(ActivityState state) {
    return ElevatedButton(
      onPressed: () {
        /// session try to cancel
        MixpanelBookingBloc.bloc(context).add(
          CancelOrRescheduleButtonClickedEvent(
            slotDateTimeInUtc:
                getUtcDateTimeFromBackEndString(widget.sessions.dateFrom!),
            therapistName: widget.sessions.therapistName!,
            sessionId: widget.sessions.id.toString(),
            currency: widget.sessions.currency ?? "",
            total: widget.sessions.fees ?? 0.0,
          ),
        );

        context
            .read<ActivityBloc>()
            .add(CompensatedSessionActivityEvt(widget.sessions.id!));
      },
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor:
              MaterialStateProperty.all<Color>(ConstColors.appWhite),
          foregroundColor:
              MaterialStateProperty.all<Color>(ConstColors.textSecondary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: const BorderSide(color: ConstColors.textSecondary)))),
      child: Text(translate(LangKeys.cancel)),
    );
  }

  Widget _rescheduleButton(ActivityState state) {
    return ElevatedButton(
      onPressed: () {
        /// on try to reschedule
        MixpanelBookingBloc.bloc(context).add(
          CancelOrRescheduleButtonClickedEvent(
            slotDateTimeInUtc:
                getUtcDateTimeFromBackEndString(widget.sessions.dateFrom!),
            therapistName: widget.sessions.therapistName!,
            sessionId: widget.sessions.id.toString(),
            currency: widget.sessions.currency ?? "",
            total: widget.sessions.fees ?? 0.0,
          ),
        );

        context.read<ActivityBloc>().add(AvailableSlotsEvt(
            sessionId: widget.sessions.id!,
            therapistName: widget.sessions.therapistName!,
            therapistId: widget.sessions.therapistId!,
            image: widget.sessions.therapistImage!.url!,
            sessionFees: widget.sessions.fees!,
            currency: widget.sessions.currency!,
            sessionDate: widget.sessions.dateFrom!,
            therapistProfession: widget.sessions.therapistProfession!));
      },
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
      child: Text(translate(LangKeys.reschedule)),
    );
  }

  Widget _joinSessionButton(ActivityState state) {
    return BlocConsumer<ActivityBloc, ActivityState>(
      listener: (context, state) {
        if (state is LoadingActivityState) {
          showLoading();
        } else {
          hideLoading();
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            /// trigger event on mixpanel when user join the session
            MixpanelBookingBloc.bloc(context).add(
              JoinSessionActionEvent(
                sessionId: widget.sessions.id.toString(),
                therapistName: widget.sessions.therapistName,
                sessionDateAndTimeInUtc:
                    getUtcDateTimeFromBackEndString(widget.sessions.dateFrom!),
              ),
            );
            context
                .read<ActivityBloc>()
                .add(JoinSessionActivityEvt(id: widget.sessions.id!));
          },
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ))),
          child: Text(translate(LangKeys.joinSession)),
        );
      },
    );
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////

  bool _isSessionToday() {
    DateTime now = DateTime.now().toLocal();
    final today = DateTime(now.year, now.month, now.day).toLocal();
    final dateToCheck = DateTime.parse(
            DateTimeHelper.getFormattedDateString(widget.sessions.dateFrom!))
        .toLocal();
    final aDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    return aDate == today;
  }

  // returns true if current time is in between given timestamps
  //openTime HH:MMAM or HH:MMPM same for closedTime
  // bool _isSessionInTime() {
  //   if (_isSessionToday()) {
  //     String sessionDateFormatted =
  //         DateTimeHelper.getFormattedDateString(widget.sessions.dateFrom!);
  //     String startTime = DateFormat("", "en_US")
  //         .add_jm()
  //         .format(DateTime.parse(sessionDateFormatted).toLocal())
  //         .replaceAll(" ", "")
  //         .padLeft(7, '0');
  //     String endTime = DateFormat("", "en_US")
  //         .add_jm()
  //         .format(DateTime.parse(sessionDateFormatted)
  //             .toLocal()
  //             .add(const Duration(minutes: 90)))
  //         .replaceAll(" ", "")
  //         .padLeft(7, '0');
  //     TimeOfDay timeNow = TimeOfDay.now();
  //     String openHr = startTime.substring(0, 2);
  //     String openMin = startTime.substring(3, 5);
  //     String openAmPm = startTime.substring(5);
  //     TimeOfDay timeOpen;
  //     if (openAmPm == "AM") {
  //       //am case
  //       if (openHr == "12") {
  //         //if 12AM then time is 00
  //         timeOpen = TimeOfDay(hour: 00, minute: int.parse(openMin));
  //       } else {
  //         timeOpen =
  //             TimeOfDay(hour: int.parse(openHr), minute: int.parse(openMin));
  //       }
  //     } else {
  //       //pm case
  //       if (openHr == "12") {
  //         //if 12PM means as it is
  //         timeOpen =
  //             TimeOfDay(hour: int.parse(openHr), minute: int.parse(openMin));
  //       } else {
  //         //add +12 to conv time to 24hr format
  //         timeOpen = TimeOfDay(
  //             hour: int.parse(openHr) + 12, minute: int.parse(openMin));
  //       }
  //     }
  //
  //     String closeHr = endTime.substring(0, 2);
  //     String closeMin = endTime.substring(3, 5);
  //     String closeAmPm = endTime.substring(5);
  //
  //     TimeOfDay timeClose;
  //
  //     if (closeAmPm == "AM") {
  //       //am case
  //       if (closeHr == "12") {
  //         timeClose = TimeOfDay(hour: 0, minute: int.parse(closeMin));
  //       } else {
  //         timeClose =
  //             TimeOfDay(hour: int.parse(closeHr), minute: int.parse(closeMin));
  //       }
  //     } else {
  //       //pm case
  //       if (closeHr == "12") {
  //         timeClose =
  //             TimeOfDay(hour: int.parse(closeHr), minute: int.parse(closeMin));
  //       } else {
  //         timeClose = TimeOfDay(
  //             hour: int.parse(closeHr) + 12, minute: int.parse(closeMin));
  //       }
  //     }
  //
  //     int nowInMinutes = timeNow.hour * 60 + timeNow.minute;
  //     int openTimeInMinutes = timeOpen.hour * 60 + timeOpen.minute;
  //     int closeTimeInMinutes = timeClose.hour * 60 + timeClose.minute;
  //
  //     //handling day change ie pm to am
  //     if ((closeTimeInMinutes - openTimeInMinutes) < 0) {
  //       closeTimeInMinutes = closeTimeInMinutes + 1440;
  //       if (nowInMinutes >= 0 && nowInMinutes < openTimeInMinutes) {
  //         nowInMinutes = nowInMinutes + 1440;
  //       }
  //       if (openTimeInMinutes <= nowInMinutes &&
  //           nowInMinutes <= closeTimeInMinutes) {
  //         return true;
  //       }
  //     } else if (openTimeInMinutes <= nowInMinutes &&
  //         nowInMinutes <= closeTimeInMinutes) {
  //       return true;
  //     }
  //     return false;
  //   } else {
  //     return false;
  //   }
  // }

  int? _getDifferenceInSeconds() {
    int? seconds;
    if (_isSessionToday()) {
      //handling showing timer and remaining seconds
      int differenceInSeconds = DateTimeHelper.differenceInSeconds(
          DateTime.now().toLocal(),
          DateTimeHelper.getLocalDate(widget.sessions.dateFrom!));
      seconds = differenceInSeconds;
    }
    return seconds;
  }

  bool _isSessionInTime() {
    DateTime fromDate = DateTimeHelper.getLocalDate(widget.sessions.dateFrom!);
    DateTime toDate = fromDate.add(const Duration(minutes: 90));
    return DateTimeHelper.isDateTimeWithinInterval(fromDate, toDate);
  }
}
