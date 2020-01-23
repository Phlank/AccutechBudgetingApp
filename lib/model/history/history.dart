import 'dart:convert';

import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_factory.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/priority_budget_factory.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/crypt/encrypted.dart';
import 'package:budgetflow/model/file_io/serializable.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/history/month_time.dart';

class History implements Serializable {
  static const String HISTORY_PATH = "history";

  List<Month> _months;
  int _year, _month;
  Month currentMonth;
  Budget budget;
  bool newUser;

  History() {
    print('built output');
    _months = new List<Month>();
    print('list built');
  }

  void save(Budget current) {
    _updateCurrentMonth(current);
    _months.forEach((Month m) => m.save());
    Encrypted e = BudgetControl.crypter.encrypt(serialize());
    BudgetControl.fileIO.writeFile(HISTORY_PATH, e.serialize());
  }

  void _updateCurrentMonth(Budget budget) {
    currentMonth = Month.fromBudget(budget);
  }

  Budget getLatestMonthBudget() {
    currentMonth = _months.firstWhere(_monthHasCurrentTime, orElse: () => null);
    if (currentMonth != null) {
      return Budget.fromMonth(currentMonth);
    } else {
      return _createNewMonthBudget();
    }
  }

  bool _monthHasCurrentTime(Month m) {
    return m.getMonthTime() == MonthTime.now();
  }

  Budget _createNewMonthBudget() {
    Month lastMonth = _months[_months.length - 1];
    currentMonth = new Month(MonthTime.now(), lastMonth.getIncome());
    Budget lastBudget = Budget.fromMonth(lastMonth);
    BudgetFactory factory = new PriorityBudgetFactory();
    Budget currentBudget = factory.newFromBudget(lastBudget);
    currentMonth.updateMonthData(currentBudget);
    return currentBudget;
  }

  bool _monthMatchesMonthTime(Month m, MonthTime mt) {
    return m.getMonthTime() == mt;
  }

  BudgetMap getAllottedSpendingFromMonthTime(MonthTime mt) {
    Month m = _months
      .firstWhere((Month m) => _monthMatchesMonthTime(m, mt));
    return m.getAllottedSpendingData();
  }

  BudgetMap getActualSpendingFromMonthTime(MonthTime mt) {
    Month m = _months
      .firstWhere((Month m) => _monthMatchesMonthTime(m, mt));
    return m.getActualSpendingData();
  }

  TransactionList getTransactionsFromMonthTime(MonthTime mt) {
    print(mt.toString()+' geting transaaction');
    Month m = _months
      .firstWhere((Month m) {
        print('inside');
        return _monthMatchesMonthTime(m, mt);
      });
    print('returnin');
    return m.getTransactionData();
  }

  int getNumberOfMonths() {
    return _months.length;
  }

  Month getMonth(MonthTime mt) {
    return _months
      .firstWhere((Month m) => _monthMatchesMonthTime(m, mt));
  }

  void addMonth(Month m) {
    _months.add(m);
  }

  @override
  String serialize() {
    String output = '{';
    int i = 0;
    _months.forEach((Month m) {
      output += '"' + i.toString() + '":' + m.serialize();
      i++;
    });
    output += '}';
    return output;
  }

  static History unserialize(String serialized) {
    print('unserialize');
    History output = new History();
    Map map = jsonDecode(serialized);
    print(map);
    map.forEach((dynamic s, dynamic d) async {
      output._months.add(await Month.unserializeMap(d));
    });
    return output;
  }

  static Future<String> getHistoryInfo() async => BudgetControl.fileIO.readFile(HISTORY_PATH);

  static Future<History> load() async {
    String cipher = await BudgetControl.fileIO.readFile(HISTORY_PATH);
    Encrypted e = Encrypted.unserialize(cipher);
    String plaintext = BudgetControl.crypter.decrypt(e);
    History h = History.unserialize(plaintext);
    return h;
  }
}
