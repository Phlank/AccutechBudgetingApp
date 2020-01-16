import 'dart:convert';

import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/file_io/serializable.dart';
import 'package:budgetflow/model/history/month.dart';

class History implements Serializable {
  List<Month> _months;
  int year, month;
  Month currentMonth;
  Budget budget;
  bool newUser;

  History() {
    _months = new List<Month>();
  }

  void addMonth(Month m) {
    _months.add(m);
  }

  void save() {
    _updateCurrentMonth(budget);
    _months.forEach((Month m) => m.save());
  }

  void _updateCurrentMonth(Budget budget) {
    currentMonth = Month.fromBudget(budget);
  }

  Month getLatestMonth() {
    if (_months.contains(new Month(year, month, 0.0))) {
      currentMonth =
        _months.firstWhere((Month m) =>
        m.year == year && m.month == month);
      budget = Budget.fromMonth(currentMonth);
    } else {

    }
  }

  @override
  String serialize() {
    String output = "{";
    int i = 0;
    _months.forEach((Month m) {
      output += "\"" + i.toString() + "\":" + m.serialize();
      i++;
    });
    output += "}";
    return output;
  }

  static History unserialize(String serialized) {
    History output = new History();
    Map map = jsonDecode(serialized);
    map.forEach((dynamic s, dynamic d) {
      output._months.add(Month.unserializeMap(d));
    });
    return output;
  }
}
