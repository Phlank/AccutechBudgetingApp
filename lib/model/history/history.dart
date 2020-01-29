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
    _months.add(Month.fromBudget(budget));
  }

  Budget getLatestMonthBudget() {
    currentMonth = _months.firstWhere(_monthHasCurrentTime, orElse: () => null);
    if (currentMonth != null) {
      print('here');
      return Budget.fromMonth(currentMonth);
    } else {
      print('there');
      return _createNewMonthBudget();
    }
  }

  bool _monthHasCurrentTime(Month m) {
    return m.getMonthTime() == MonthTime.now();
  }

  Budget _createNewMonthBudget() {//todo what if there is no month
    Month lastMonth = _months[_months.length - 1];
    currentMonth = _buildCurrentMonth();
    Budget lastBudget = Budget.fromMonth(lastMonth);
    BudgetFactory factory = new PriorityBudgetFactory();
    Budget currentBudget = factory.newFromBudget(lastBudget);
    currentMonth.updateMonthData(currentBudget);
    return currentBudget;
  }

  Month _buildCurrentMonth() {}

  bool _monthMatchesMonthTime(Month m, MonthTime mt) {
    return m.getMonthTime() == mt;
  }

  BudgetMap getAllottedSpendingFromMonthTime(MonthTime mt) {
    Month m = _months.firstWhere((Month m) => _monthMatchesMonthTime(m, mt));
    return m.allotted;
  }

  BudgetMap getActualSpendingFromMonthTime(MonthTime mt) {
    Month m = _months.firstWhere((Month m) => _monthMatchesMonthTime(m, mt));
    return m.actual;
  }

  TransactionList getTransactionsFromMonthTime(MonthTime mt) {//todo look here
    Month m = _months.firstWhere((Month m) {
      return _monthMatchesMonthTime(m, mt);
    });
    return m.transactions;
  }

  int getNumberOfMonths() {
    return _months.length;
  }

  Month getMonth(MonthTime mt) {
    return _months.firstWhere((Month m) => _monthMatchesMonthTime(m, mt));
  }

  void addMonth(Month m) {
    _months.add(m);
  }

  @override
  String serialize() {
    String output = '{';
    int i = 0;
    _months.forEach((Month m) {
      output += '"' + i.toString() + '":' + m.serialize()+',';
      i++;
    });
    output += '}';
    output = output.replaceAll('},}', '}}');
    return output;
  }

  static History unserialize(String serialized) {
    History output = new History();
    Map map = jsonDecode(serialized);
    print(map);
    map.forEach((dynamic s, dynamic d) async {
      output._months.add(await Month.unserializeMap(d));
    });
    return output;
  }

  static Future<String> getHistoryInfo() async =>
      BudgetControl.fileIO.readFile(HISTORY_PATH);

  static Future<History> load() async {
    String cipher = await BudgetControl.fileIO.readFile(HISTORY_PATH);
    Encrypted e = Encrypted.unserialize(cipher);
    String plaintext = BudgetControl.crypter.decrypt(e);
    History h = History.unserialize(plaintext);
    return h;
  }
}
