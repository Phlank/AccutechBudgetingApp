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

  static DateTime getNthPreviousMonthTime(int n) {
    DateTime output = DateTime.now();
    for (int i = 0; i < n; i++) {
      output = _stepDateTimeBackOneMonth(output);
    }
    return output;
  }

  static DateTime _stepDateTimeBackOneMonth(DateTime dt) {
    // Subtracts number of days + 1 from input time to give output time at last day
    return dt.subtract(Duration(days: dt.day + 1));
  }
}
