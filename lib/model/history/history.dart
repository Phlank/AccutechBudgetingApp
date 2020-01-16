import 'dart:convert';

import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_factory.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/priority_budget_factory.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/crypt/encrypted.dart';
import 'package:budgetflow/model/file_io/saveable.dart';
import 'package:budgetflow/model/file_io/serializable.dart';
import 'package:budgetflow/model/history/month.dart';

class History implements Serializable, Saveable {
  static const String HISTORY_PATH = "history";

  List<Month> _months;
  int _year, _month;
  Month currentMonth;
  Budget budget;
  bool newUser;

  History() {
    _months = new List<Month>();
  }

  @override
  void save() {
    _updateCurrentMonth(budget);
    _months.forEach((Month m) => m.save());
    Encrypted e = BudgetControl.crypter.encrypt(serialize());
    BudgetControl.fileIO.writeFile(HISTORY_PATH, e.serialize());
  }

  void _updateCurrentMonth(Budget budget) {
    currentMonth = Month.fromBudget(budget);
  }

  Budget getLatestMonthBudget() {
    currentMonth = _months.firstWhere(_monthHasSameTime, orElse: () => null);
    if (currentMonth != null) {
      return Budget.fromMonth(currentMonth);
    } else {
      return _createNewMonthBudget();
    }
  }

  bool _monthHasSameTime(Month m) {
    return m.year == _year && m.month == _month;
  }

  Budget _createNewMonthBudget() {
    Month lastMonth = _months[_months.length - 1];
    currentMonth = new Month(_year, _month, lastMonth.income);
    Budget lastBudget = Budget.fromMonth(lastMonth);
    BudgetFactory factory = new PriorityBudgetFactory();
    Budget currentBudget = factory.newFromBudget(lastBudget);
    currentMonth.updateMonthData(currentBudget);
    return currentBudget;
  }

  bool _monthMatchesYearAndMonth(Month m, int year, int month) {
    return m.year == year && m.month == month;
  }

  BudgetMap getAllottedSpendingFromMonth(int year, int month) {
    Month m = _months.firstWhere((Month m) =>
      _monthMatchesYearAndMonth(m, year, month));
    return m.getAllottedSpendingData();
  }

  BudgetMap getActualSpendingFromMonth(int year, int month) {
    Month m = _months.firstWhere((Month m) =>
      _monthMatchesYearAndMonth(m, year, month));
    return m.getActualSpendingData();
  }

  TransactionList getTransactionsFromMonth(int year, int month) {
    Month m = _months.firstWhere((Month m) =>
      _monthMatchesYearAndMonth(m, year, month));
    return m.getTransactionData();
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

  static History load() {
    History h;
    BudgetControl.fileIO.readFile(HISTORY_PATH).then((String content) {
      h = unserialize(content);
    });
    return h;
  }
}
