import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/screen_sizer.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/activity/bloc/activity_bloc.dart';
import 'package:o7therapy/ui/screens/activity/reschedule_screen/reschedule_details.dart';
import 'package:o7therapy/ui/screens/activity/reschedule_screen/reschedule_details_payment.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/therapist_profile/widgets/calendar_utils.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:o7therapy/api/models/available_slots_datetime/Data.dart';

class RescheduleScreen extends BaseScreenWidget {
  static const routeName = '/reschedule-screen';

  const RescheduleScreen({Key? key}) : super(key: key);

  @override
  BaseState<RescheduleScreen> screenCreateState() => _RescheduleScreenState();
}

class _RescheduleScreenState extends BaseScreenState<RescheduleScreen>
    with Translator, ScreenSizer, RouteAware {
  final TextEditingController _typeController = TextEditingController();
  int selectedType = 0;
  int selectedTime = -1;
  bool dateValue = false;
  int val = -1;
  int? selectedSlotId;
  DateTime? selectedSlotDate;
  String selectedSlotDateString = "";
  ValueNotifier<List<Data>> _selectedEvents = ValueNotifier([]);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longPressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String therapistId = "";
  String sessionId = "";
  String therapistName = "";
  String therapistProfession = "";
  String sessionDate = "";
  double sessionFees = 0;
  String currency = "";
  String imageUrl = "";
  String promoCode = "";
  bool requirePayment = false;
  List<Data> slots = [];

  @override
  void initState() {
    super.initState();
    context.read<ActivityBloc>().add(LoadingRescheduleEvt());
    _typeController.text = "";
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void didChangeDependencies() {
    context.read<ActivityBloc>().add(LoadingRescheduleEvt());
    Future.delayed(Duration.zero).then((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      therapistId = args['therapistId'] as String;
      sessionId = args['sessionId'] as String;
      slots = args['availableSlots'] as List<Data>;
      therapistName = args['therapistName'] as String;
      therapistProfession = args['therapistProfession'] as String;
      sessionDate = args['sessionDate'] as String;
      sessionFees = args['sessionFees'] as double;
      currency = args['currency'] as String;
      imageUrl = args['image'] as String;
      requirePayment = args['requirePayment'] as bool;
    });

    context.read<ActivityBloc>().add(LoadingRescheduleEvt());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _typeController.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBarForMoreScreens(
        title:
            '${translate(LangKeys.reschedule)} ${translate(LangKeys.session)}',
      ),
      body: SafeArea(
        child: BlocConsumer<ActivityBloc, ActivityState>(
          listener: (context, state) {
            if (state is NetworkError) {
              if (state.message == "Session expired") {
                clearData();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.routeName, (Route<dynamic> route) => false);
              }
              showToast(state.message);
            }
            if (state is ErrorState) {
              if (state.message == "Session expired") {
                clearData();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.routeName, (Route<dynamic> route) => false);
              }
              showToast(state.message);
            }

            if (state is LoadingActivityState) {
              showLoading();
            } else {
              hideLoading();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _stepsSlide(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Text(
                      translate(LangKeys.selectDateAndTimeSuitableForYou),
                      style: const TextStyle(
                          color: ConstColors.app,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(left: 0, right: 0),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        side: BorderSide(color: ConstColors.disabled)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: _calendarWidget(),
                    ),
                  ),
                  _getConfirmButton()
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////
  Widget _stepsSlide() {
    return Padding(
      padding: EdgeInsets.only(top: height / 40, bottom: height / 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Container(
                  color: ConstColors.accentColor,
                  width: width / 3,
                  height: 3.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Container(
                  color: ConstColors.accentColor.withOpacity(0.30),
                  width: width / 3,
                  height: 3.5),
            ),
          ),
        ],
      ),
    );
  }

  //Get confirm booking button
  Widget _getConfirmButton() {
    return Container(
      alignment: Alignment.center,
      padding:
          const EdgeInsets.only(top: 20.0, left: 24, right: 24, bottom: 20),
      child: SizedBox(
        width: width * 0.70,
        height: 45,
        child: ElevatedButton(
          onPressed: selectedSlotId == null
              ? null
              : requirePayment
                  ? () => Navigator.of(context).pushReplacementNamed(
                          RescheduleDetailsPaymentScreen.routeName,
                          arguments: {
                            "sessionFees": sessionFees,
                            "slotId": selectedSlotId.toString(),
                            "therapistName": therapistName,
                            "therapistProfession": therapistProfession,
                            "sessionDate": selectedSlotDateString,
                            "currency": currency,
                            "sessionId": sessionId,
                            "image": imageUrl,
                            "requirePayment": requirePayment
                          })
                  : () => Navigator.of(context).pushReplacementNamed(
                          RescheduleDetailsScreen.routeName,
                          arguments: {
                            "sessionFees": sessionFees,
                            "slotId": selectedSlotId.toString(),
                            "therapistName": therapistName,
                            "therapistProfession": therapistProfession,
                            "sessionDate": selectedSlotDateString,
                            "currency": currency,
                            "sessionId": sessionId,
                            "image": imageUrl,
                            "requirePayment": requirePayment
                          }),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Text(translate(LangKeys.next)),
        ),
      ),
    );
  }

  Widget _getAvailableDatesContainer(List<Data> aSlots) {
    return Column(
      children: [
        _chooseTimeRow(),
        GridView.builder(
          itemCount: aSlots.length,
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 2,
          ),
          itemBuilder: (context, index) => Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
                side: const BorderSide(color: ConstColors.app)),
            elevation: 0,
            color: selectedTime == index
                ? ConstColors.app.withOpacity(0.10)
                : ConstColors.appWhite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<int>(
                        value: index + 1,
                        groupValue: val,
                        onChanged: (int? value) {
                          setState(() {
                            val = value!;
                            selectedTime = index;
                            selectedSlotId = aSlots[index].id;
                            // selectedSlotDate = aSlots[index].from;
                            selectedSlotDateString =
                                _getStringDate(aSlots[index].from!.toString());
                          });
                        },
                        activeColor: ConstColors.accentColor),
                    // Text(_typeController.text,
                    //     style: const TextStyle(
                    //         color: ConstColors.text,
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w400))
                    Text(
                      translate(LangKeys.fiftyMinOneOnOne),
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: ConstColors.text),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: width / 25, right: width / 25),
                  child: Text(
                    "${DateFormat().add_jm().format(aSlots[index].from!)}- ${DateFormat().add_jm().format(aSlots[index].to!)}",
                    style: const TextStyle(
                        color: ConstColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _chooseTimeRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            translate(LangKeys.chooseTime),
            style: const TextStyle(
                color: ConstColors.app,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          // Text(
          //   _typeController.text,
          //   style: const TextStyle(
          //       color: ConstColors.accentColor,
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500),
          // )
        ],
      ),
    );
  }

  Widget _calendarWidget() {
    return Column(
      children: [
        TableCalendar<Data>(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          availableGestures: AvailableGestures.horizontalSwipe,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          calendarFormat: _calendarFormat,
          rangeSelectionMode: _rangeSelectionMode,
          eventLoader: (day) {
            return slots.where((event) => isSameDay(event.from!, day)).toList();
          },
          startingDayOfWeek: StartingDayOfWeek.sunday,
          calendarStyle: CalendarStyle(
            // Use `CalendarStyle` to customize the UI
            outsideDaysVisible: false,
            weekendDecoration: _calendarDecoration(),
            holidayDecoration: _calendarDecoration(),
            defaultDecoration: _calendarDecoration(),
            selectedDecoration: const BoxDecoration(
                color: ConstColors.app,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                    bottomLeft: Radius.zero)),
            todayDecoration: BoxDecoration(
                color: ConstColors.app.withOpacity(0.30),
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                    bottomLeft: Radius.zero)),
            markerDecoration: const BoxDecoration(
                color: ConstColors.accentColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(17))),
            markersMaxCount: 1,
            markersAnchor: 1.3,
            markerSizeScale: 0.18,
          ),
          onDaySelected: _onDaySelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0),
        ValueListenableBuilder<List<Data>>(
          valueListenable: _selectedEvents,
          builder: (context, value, _) {
            if (_selectedEvents.value.isEmpty) {
              return Container();
            } else {
              return _getAvailableDatesContainer(value);
            }
          },
        ),
      ],
    );
  }

  BoxDecoration _calendarDecoration() {
    return const BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(7),
            topRight: Radius.circular(7),
            bottomRight: Radius.circular(7),
            bottomLeft: Radius.zero));
  }

///////////////////////////////////////////////////////////
//////////////////// Helper methods ///////////////////////
///////////////////////////////////////////////////////////

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        // _rangeStart = null; // Important to clean those
        // _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value =
          slots.where((event) => isSameDay(event.from!, selectedDay)).toList();
    }
  }

  List<Data> _getEventsForDay(DateTime day) {
    List<Data> slots = [];
    slots = slots.where((event) => isSameDay(event.from!, day)).toList();
    return slots;
  }

  _getStringDate(String date) {
    return date
        .replaceAll(" ", "")
        .replaceAll(":", "")
        .replaceAll('-', "")
        .replaceAll(".000", "");
  }
}
