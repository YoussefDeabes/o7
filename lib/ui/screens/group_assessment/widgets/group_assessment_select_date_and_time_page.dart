import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/screen_sizer.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/group_assessment/screen/group_assessment_screen.dart';
// import 'package:o7therapy/ui/screens/therapist_profile/bloc/therapist_profile_bloc.dart';
import 'package:o7therapy/ui/screens/therapist_profile/widgets/calendar_utils.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/api/models/available_slots_datetime/Data.dart';
import 'package:table_calendar/table_calendar.dart';

class GroupAssessmentSelectDateAndTimePage extends StatefulWidget {
  static _getStringDate(String date) {
    String dateWithT = '${date.substring(0, 8)}T${date.substring(8)}Z';
    return DateTime.parse(dateWithT).toLocal();
  }

  final List<Data> slots = [
    Data(
        id: 13237,
        from: _getStringDate("20221122063000"),
        to: _getStringDate("20221122064000")),
    Data(
        id: 13236,
        from: _getStringDate("20221129063000"),
        to: _getStringDate("20221129064000")),
    Data(
        id: 13237,
        from: _getStringDate("20221122063010"),
        to: _getStringDate("20221122064100")),
    Data(
        id: 13236,
        from: _getStringDate("20221129063100"),
        to: _getStringDate("20221129064100")),
    Data(
        id: 13237,
        from: _getStringDate("20221122064010"),
        to: _getStringDate("20221122064100")),
    Data(
        id: 13236,
        from: _getStringDate("20221129023100"),
        to: _getStringDate("20221129064100")),
  ];

  // final TherapistData therapistData;
  GroupAssessmentSelectDateAndTimePage({Key? key}) : super(key: key);

  @override
  State<GroupAssessmentSelectDateAndTimePage> createState() =>
      _GroupAssessmentSelectDateAndTimePageState();
}

class _GroupAssessmentSelectDateAndTimePageState
    extends State<GroupAssessmentSelectDateAndTimePage>
    with Translator, ScreenSizer {
  int selectedTime = -1;
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
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    initScreenSizer(context);
    return Column(
      children: [
        _bookingHeader(),
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            side: BorderSide(color: ConstColors.disabled),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _calendarWidget(),
                _getAvailableDatesContainer(),
                _getConfirmButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

//Header for what you will book for
  Widget _bookingHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Text(
        translate(LangKeys.selectDateAndTimeSuitableForYou),
        style: const TextStyle(
          color: ConstColors.app,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  //Get confirm booking button
  Widget _getConfirmButton() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24),
      child: SizedBox(
        width: width * 0.70,
        height: 45,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              GroupAssessmentScreen.routeName,
              arguments: GroupAssessmentPages.groupAssessmentDetailsPage,
            );
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(34.0),
          )),
          child: Text(translate(LangKeys.confirm)),
        ),
      ),
    );
  }

  Widget _getAvailableDatesContainer() {
    return ValueListenableBuilder<List<Data>>(
      valueListenable: _selectedEvents,
      builder: (context, value, _) {
        if (_selectedEvents.value.isEmpty) {
          return const SizedBox.shrink();
        }
        List<Data> aSlots = value;
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
                                selectedSlotDateString = _getStringDate(
                                    aSlots[index].from!.toString());
                              });
                            },
                            activeColor: ConstColors.accentColor),
                        Text(
                          translate(LangKeys.groupAssessment),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: ConstColors.text),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: width / 25, right: width / 25),
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
      },
    );
  }

  Widget _chooseTimeRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
        ],
      ),
    );
  }

  Widget _calendarWidget() {
    return TableCalendar<Data>(
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
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.zero)),
        todayDecoration: BoxDecoration(
            color: ConstColors.app.withOpacity(0.30),
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.zero)),
        markerDecoration: const BoxDecoration(
            color: ConstColors.accentColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(16))),
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
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
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
