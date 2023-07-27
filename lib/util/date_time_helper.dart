/// [DateTimeHelper] used to handle the date time from back end
class DateTimeHelper {
  /// get the String date that able to convert it to DateTime
  /// ex: "$year-$month-${day}T$hour:$minute:${second}Z"
  static String getFormattedDateString(String date) {
    final String year = date.substring(0, 4);
    final String month = date.substring(4, 6);
    final String day = date.substring(6, 8);
    final String hour = date.substring(8, 10);
    final String minute = date.substring(10, 12);
    final String second = date.substring(12, 14);
    final String formattedDate = "$year-$month-${day}T$hour:$minute:${second}Z";
    return formattedDate;
  }

  /// get the date time in local from the back end String
  static DateTime getLocalDate(String date) {
    final String formattedDateString = getFormattedDateString(date);
    return DateTime.parse(formattedDateString).toLocal();
  }

  static int differenceInSeconds(DateTime start, DateTime end) {
    return end.difference(start).inSeconds;
  }

  static bool isDateTimeWithinInterval(DateTime start, DateTime end) {
    final now = DateTime.now();
    var endTime = end.subtract(const Duration(seconds: 2));
    var startTime = start.subtract(const Duration(seconds: 2));
    var isBetween = now.isAfter(startTime) && now.isBefore(endTime);
    return isBetween;
  }
}
