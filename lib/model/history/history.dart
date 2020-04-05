import 'package:budgetflow/model/abstract/budget_factory.dart';
import 'package:budgetflow/model/budget/factory/priority_budget_factory.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/data_types/allocation_list.dart';
import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/data_types/encrypted.dart';
import 'package:budgetflow/model/data_types/transaction_list.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

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
    Encrypted e = BudgetControl.crypter.encrypt(serialize);
    BudgetControl.fileIO.writeFile(HISTORY_PATH, e.serialize);
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
    Month lastMonth = _months[_months.length - 1];
    currentMonth = _buildCurrentMonth();
    Budget lastBudget = await Budget.fromMonth(lastMonth);
    BudgetFactory factory = new PriorityBudgetFactory();
    Budget currentBudget = factory.newFromBudget(lastBudget);
    currentMonth.updateMonthData(currentBudget);
    return currentBudget;
  }

  Month _buildCurrentMonth() {
    // TODO THIS
  }

  bool _monthMatchesMonthTime(Month m, MonthTime mt) {
    return m.getMonthTime() == mt;
  }

  Future<AllocationList> getAllottedSpendingFromMonthTime(MonthTime mt) async {
    Month m = _months.firstWhere((Month m) => _monthMatchesMonthTime(m, mt));
    return await m.allotted;
  }

  Future<AllocationList> getActualSpendingFromMonthTime(MonthTime mt) async {
    Month m = _months.firstWhere((Month m) => _monthMatchesMonthTime(m, mt));
    return await m.actual;
  }

  Future<TransactionList> getTransactionsFromMonthTime(MonthTime mt) async {
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
  String get serialize {
    Serializer serializer = Serializer();
    int i = 0;
    _months.forEach((Month m) {
      serializer.addPair(i, m);
      i++;
    });
    return serializer.serialize;
  }

  static Future<History> load() async {
    String cipher = await BudgetControl.fileIO.readFile(HISTORY_PATH);
    Encrypted e = Serializer.unserialize(encryptedKey, cipher);
    String plaintext = BudgetControl.crypter.decrypt(e);
    History h = Serializer.unserialize(historyKey, plaintext);
    return h;
  }
}
