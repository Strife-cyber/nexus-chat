import 'package:intl/intl.dart';

class DateTimeInfo {
  final int year;
  final int month;
  final int date;
  final String day;
  final int hour;
  final int minute;
  final int second;
  final String period;

  DateTimeInfo(
      {required this.year,
      required this.month,
      required this.date,
      required this.day,
      required this.hour,
      required this.minute,
      required this.second,
      required this.period});

  @override
  String toString() {
    return '$day $date $month $year $hour:$minute:$second $period';
  }
}

DateTimeInfo parseDateTimeString(String dateTimeString) {
  try {
    // Parse the input string to a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Use DateFormat to get the day name and format the hour to 12-hour format
    String dayName =
        DateFormat('EEEE').format(dateTime); // Full day name, e.g., "Monday"
    String period = DateFormat('a').format(dateTime); // AM/PM

    return DateTimeInfo(
      year: dateTime.year,
      month: dateTime.month,
      date: dateTime.day,
      day: dayName,
      hour: dateTime.hour > 12
          ? dateTime.hour - 12
          : dateTime.hour == 0
              ? 12
              : dateTime.hour,
      minute: dateTime.minute,
      second: dateTime.second,
      period: period,
    );
  } catch (e) {
    throw FormatException('Invalid date-time string format: $e');
  }
}
