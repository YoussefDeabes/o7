// import 'dart:collection';
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:o7therapy/_base/translator.dart';
// import 'package:o7therapy/api/models/available_slots/AvailableSlotsWrapper.dart';
// import 'package:o7therapy/api/models/available_slots/Data.dart';
// import 'package:o7therapy/res/const_colors.dart';
// import 'package:o7therapy/util/lang/app_localization_keys.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:o7therapy/ui/screens/therapist_profile/widgets/calendar_utils.dart';
//
// class CalendarWidget extends StatefulWidget {
//   AvailableSlotsWrapper availableSlots;
//   double height;
//   double width;
//
//   CalendarWidget(
//       {Key? key,
//       required this.availableSlots,
//       required this.height,
//       required this.width})
//       : super(key: key);
//
//   @override
//   State<CalendarWidget> createState() => _CalendarWidgetState();
// }
//
// class _CalendarWidgetState extends State<CalendarWidget> with Translator {
//   // final _calendarControllerToday = AdvancedCalendarController.today();
//   // DateTime _selectedDay = DateTime.now();
//   // DateTime _focusedDay = DateTime.now();
//   // CalendarFormat _calendarFormat = CalendarFormat.month;
//   late final ValueNotifier<List<Data>> _selectedEvents;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
//       .toggledOff; // Can be toggled on/off by longpressing a date
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;
//
//   // Map<DateTime, List<Data>> _slots = {};
//
//   @override
//   void initState() {
//     super.initState();
//
//
//   }
//
//
//
//
//
//
//
//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _selectedDay = selectedDay;
//         _focusedDay = focusedDay;
//         _rangeStart = null; // Important to clean those
//         _rangeEnd = null;
//         _rangeSelectionMode = RangeSelectionMode.toggledOff;
//       });
//
//       _selectedEvents.value = _getEventsForDay(selectedDay);
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     initTranslator(context);
//     return
//   }
//
//   String _getDate(String date) {
//     String year = date.substring(0, 4);
//     String month = date.substring(4, 6);
//     String day = date.substring(6, 8);
//     String hour = date.substring(8, 10);
//     String minute = date.substring(10, 12);
//     String second = date.substring(12, 14);
//     String formattedDate = year +
//         '-' +
//         month +
//         "-" +
//         day +
//         "T" +
//         hour +
//         ":" +
//         minute +
//         ":" +
//         second +
//         "Z";
//     return formattedDate;
//   }
// }
//
// class _CalendarHeader extends StatelessWidget {
//   final DateTime focusedDay;
//   final VoidCallback onLeftArrowTap;
//   final VoidCallback onRightArrowTap;
//   final VoidCallback onTodayButtonTap;
//   final VoidCallback onClearButtonTap;
//   final bool clearButtonVisible;
//
//   const _CalendarHeader({
//     Key? key,
//     required this.focusedDay,
//     required this.onLeftArrowTap,
//     required this.onRightArrowTap,
//     required this.onTodayButtonTap,
//     required this.onClearButtonTap,
//     required this.clearButtonVisible,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final headerText = DateFormat.yMMM().format(focusedDay);
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           const SizedBox(width: 16.0),
//           SizedBox(
//             width: 120.0,
//             child: Text(
//               headerText,
//               style: TextStyle(fontSize: 26.0),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.calendar_today, size: 20.0),
//             visualDensity: VisualDensity.compact,
//             onPressed: onTodayButtonTap,
//           ),
//           if (clearButtonVisible)
//             IconButton(
//               icon: Icon(Icons.clear, size: 20.0),
//               visualDensity: VisualDensity.compact,
//               onPressed: onClearButtonTap,
//             ),
//           const Spacer(),
//           IconButton(
//             icon: Icon(Icons.chevron_left),
//             onPressed: onLeftArrowTap,
//           ),
//           IconButton(
//             icon: Icon(Icons.chevron_right),
//             onPressed: onRightArrowTap,
//           ),
//         ],
//       ),
//     );
//   }
// }
