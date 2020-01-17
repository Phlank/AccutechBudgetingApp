class MonthTime {
  int year, month;

  MonthTime(int year, int month) {
    this.year = year;
    this.month = month;
  }

  MonthTime previous() {
    if (month > 1) {
      return new MonthTime(year, month - 1);
    }
    return new MonthTime(year - 1, 12);
  }

  MonthTime next() {
    if (month < 12) {
      return new MonthTime(year, month + 1);
    }
    return new MonthTime(year + 1, 1);
  }

  String getFilePathString() {
    return "$year" + "_" + "$month";
  }

  static MonthTime currentMonthTime() {
    DateTime now = DateTime.now();
    return new MonthTime(now.year, now.month);
  }

  @override
  bool operator ==(Object o) => o is MonthTime && this._equals(o);

  bool _equals(MonthTime o) => year == o.year && month == o.month;

  @override
  int get hashCode => year.hashCode ^ month.hashCode;
}
