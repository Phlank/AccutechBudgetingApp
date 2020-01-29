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
    _months = new List<Month>();
  }

  void save(Budget current) {
    _updateCurrentMonth(current);
    for (int i = 0; i < _months.length; i++) {
      _months[i].save();
    }
    Encrypted e = BudgetControl.crypter.encrypt(serialize());
    BudgetControl.fileIO.writeFile(HISTORY_PATH, e.serialize());
  }

  void _updateCurrentMonth(Budget budget) {
    getMonth(MonthTime.now()).updateMonthData(budget);
  }

  Future<Budget> getLatestMonthBudget() async {
    currentMonth = _months.firstWhere(
            (Month m) => _monthMatchesMonthTime(m, MonthTime.now()),
        orElse: () => null);
    if (currentMonth != null) {
      return Budget.fromMonth(currentMonth);
    } else {
      return _createNewMonthBudget();
    }
  }

  Future<Budget> _createNewMonthBudget() async {
    //todo what if there is no month
    Month lastMonth = _months[_months.length - 1];
    currentMonth = _buildCurrentMonth();
    Budget lastBudget = await Budget.fromMonth(lastMonth);
    BudgetFactory factory = new PriorityBudgetFactory();
    Budget currentBudget = factory.newFromBudget(lastBudget);
    currentMonth.updateMonthData(currentBudget);
    return currentBudget;
  }

  Month _buildCurrentMonth() {}

  bool _monthMatchesMonthTime(Month m, MonthTime mt) {
    return m.getMonthTime() == mt;
  }

  Future<BudgetMap> getAllottedSpendingFromMonthTime(MonthTime mt) async {
    Month m = _months.firstWhere((Month m) => _monthMatchesMonthTime(m, mt));
    return await m.allotted;
  }

  Future<BudgetMap> getActualSpendingFromMonthTime(MonthTime mt) async {
    Month m = _months.firstWhere((Month m) => _monthMatchesMonthTime(m, mt));
    return await m.actual;
  }

  Future<TransactionList> getTransactionsFromMonthTime(MonthTime mt) async {
    //todo look here
    Month m = _months.firstWhere((Month m) => _monthMatchesMonthTime(m, mt));
    return await m.transactions;
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
      output += '"' + i.toString() + '":' + m.serialize() + ',';
      i++;
    });
    output += '}';
    output = output.replaceAll('},}', '}}');
    return output;
  }

  static History unserialize(String serialized) {
    print(serialized);
    History output = new History();
    Map map = jsonDecode(serialized);
    print(map);
    map.forEach((dynamic s, dynamic d) async {
      print("Building month: $s: $d");
      output.addMonth(Month.unserializeMap(d));
    });
    return output;
  }

  static Future<String> getHistoryInfo() async =>
      BudgetControl.fileIO.readFile(HISTORY_PATH);

  static Future<History> load() async {
    print("Loading history");
    String cipher = await BudgetControl.fileIO.readFile(HISTORY_PATH);
    print("History contents: " + cipher);
    Encrypted e = Encrypted.unserialize(cipher);
    String plaintext = BudgetControl.crypter.decrypt(e);
    print("History serialized: " + plaintext);
    History h = History.unserialize(plaintext);
    return h;
  }
}
