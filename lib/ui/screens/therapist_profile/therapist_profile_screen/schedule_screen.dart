import 'package:adjust_sdk/adjust.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:o7therapy/_base/screen_sizer.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/api/adjust_manager.dart';
import 'package:o7therapy/api/models/available_slots_datetime/Data.dart';
import 'package:o7therapy/bloc/lang/language_cubit.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/therapist_profile/widgets/calendar_utils.dart';
import 'package:o7therapy/ui/screens/therapist_profile/widgets/confirm_button_builder.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class ScheduleScreen extends StatefulWidget {
  final List<Data> slots;
  final TherapistData therapistData;
  final double height;
  final double width;

  const ScheduleScreen(
      {Key? key,
      required this.slots,
      required this.height,
      required this.width,
      required this.therapistData})
      : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with Translator, ScreenSizer, WidgetsBindingObserver {
  final TextEditingController _typeController = TextEditingController();
  int selectedType = 0;
  int selectedTime = -1;
  bool dateValue = false;
  int val = -1;
  int? selectedSlotId;
  DateTime? selectedSlotDate;
  String selectedSlotDateString = "";
  late final ValueNotifier<List<Data>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longPressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AdjustManager.initPlatformState();
    _typeController.text = "";
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
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
    _typeController.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    initScreenSizer(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            // margin: EdgeInsets.only(left: 0, right: 0),
            // shape: const RoundedRectangleBorder(
            //   borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(16),
            //     topRight: Radius.circular(16),
            //     bottomRight: Radius.circular(16),
            //     bottomLeft: Radius.circular(16),
            //   ),
            // side: BorderSide(color: ConstColors.disabled),
            // ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: _calendarWidget(),
            ),
          ),
          ConfirmButtonBuilder(
            therapistData: widget.therapistData,
            selectedSlotId: selectedSlotId,
            selectedSlotDate: selectedSlotDate,
            selectedSlotDateString: selectedSlotDateString,
          ),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

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
                            selectedSlotDate = aSlots[index].from;
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
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: ConstColors.text),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: widget.width / 25, right: widget.width / 25),
                  child: BlocBuilder<LanguageCubit, Locale>(
                      builder: (context, localeState) {
                    return FittedBox(
                      child: Text(
                        "${DateFormat(null, localeState.languageCode).add_jm().format(aSlots[index].from!)}- ${DateFormat(null, localeState.languageCode).add_jm().format(aSlots[index].to!)}",
                        style: const TextStyle(
                            color: ConstColors.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    );
                  }),
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
            return widget.slots
                .where((event) => isSameDay(event.from!, day))
                .toList();
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

  // Widget _therapiesTypes() {
  //   List<String> typesList = [
  //     translate(
  //       LangKeys.oneOnOne,
  //     ),
  //     translate(
  //       LangKeys.coupleTherapy,
  //     ),
  //     translate(
  //       LangKeys.drugReview,
  //     ),
  //     translate(
  //       LangKeys.clinicalAssessment,
  //     ),
  //   ];
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 20.0),
  //     child: SizedBox(
  //       height: 30,
  //       child: ListView.builder(
  //           itemCount: typesList.length,
  //           padding: const EdgeInsets.symmetric(horizontal: 24),
  //           scrollDirection: Axis.horizontal,
  //           itemBuilder: (context, index) => Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       selectedType = index;
  //                       _typeController.text = typesList[index];
  //                     });
  //                   },
  //                   child: Text(
  //                     typesList[index],
  //                     style: TextStyle(
  //                         color: selectedType == index
  //                             ? ConstColors.app
  //                             : ConstColors.textDisabled,
  //                         fontSize: 13,
  //                         fontWeight: FontWeight.w400),
  //                   ),
  //                   style: ButtonStyle(
  //                     elevation: MaterialStateProperty.all(0),
  //                     backgroundColor: selectedType == index
  //                         ? MaterialStateProperty.all(
  //                             ConstColors.app.withOpacity(0.10))
  //                         : MaterialStateProperty.all(ConstColors.appWhite),
  //                     // foregroundColor: MaterialStateProperty.all(
  //                     //     ConstColors.app.withOpacity(0.10)),
  //                   ),
  //                 ),
  //               )),
  //     ),
  //   );
  // }

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

      _selectedEvents.value = widget.slots
          .where((event) => isSameDay(event.from!, selectedDay))
          .toList();
    }
  }

  List<Data> _getEventsForDay(DateTime day) {
    List<Data> slots = [];
    slots = widget.slots.where((event) => isSameDay(event.from!, day)).toList();
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
