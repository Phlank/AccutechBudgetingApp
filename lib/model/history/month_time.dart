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
}
