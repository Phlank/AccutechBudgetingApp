import 'package:calendarro/date_utils.dart';

class Dates {
  static DateTime getStartOfWeek() {
    DateTime today = DateTime.now();
    DateTime sunday = today.subtract(Duration(days: today.weekday));
    DateTime weekStart = DateTime(sunday.year, sunday.month, sunday.day);
    DateTime monthStart = DateUtils.getFirstDayOfCurrentMonth();
    if (weekStart.isBefore(monthStart)) return monthStart;
    return weekStart;
  }

  static DateTime getEndOfWeek() {
    DateTime today = DateTime.now();
    DateTime saturday = today.add(Duration(days: 7 - today.weekday));
    DateTime weekEnd = DateTime(
      saturday.year,
      saturday.month,
      saturday.day,
      23, // Hour
      59, // Minute
      59, // Second
    );
    DateTime monthEnd = DateUtils.getLastDayOfCurrentMonth()
        .add(Duration(days: 1))
        .subtract(Duration(seconds: 1));
    if (weekEnd.isAfter(monthEnd)) return monthEnd;
    return weekEnd;
  }
}
