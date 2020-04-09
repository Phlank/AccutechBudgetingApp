import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/budget_factory.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/data_types/encrypted.dart';
import 'package:budgetflow/model/data_types/month.dart';
import 'package:budgetflow/model/data_types/month_time.dart';
import 'package:budgetflow/model/impl/priority_budget_factory.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:quiver/collection.dart';

class History extends DelegatingList<Month> implements Serializable {
  List<Month> _months;
  Month currentMonth;
  Budget budget;
  bool newUser;

  List<Month> get delegate => _months;

  History() {
    _months = [];
  }

  void save(Budget current) {
    _updateCurrentMonth(current);
    for (int i = 0; i < _months.length; i++) {
      _months[i].save();
    }
    Encrypted e = BudgetControl.crypter.encrypt(serialize);
    BudgetControl.fileIO.writeFile(historyFilepath, e.serialize);
  }

  void _updateCurrentMonth(Budget budget) {
    getMonthFromMonthTime(MonthTime.now()).updateMonthData(budget);
  }

  Future<Budget> getLatestMonthBudget() async {
    currentMonth = getMonthFromMonthTime(MonthTime.now());
    if (currentMonth != null) {
      return Budget.fromMonth(currentMonth);
    } else {
      return _createNewMonthBudget();
    }
  }

  Future<Budget> _createNewMonthBudget() async {
    Month lastMonth = _months[_months.length - 1];
    Budget lastBudget = await Budget.fromMonth(lastMonth);
    BudgetFactory factory = new PriorityBudgetFactory();
    Budget currentBudget = factory.newMonthBudget(lastBudget);
    currentMonth = Month.fromBudget(currentBudget);
    currentMonth.updateMonthData(currentBudget);
    if (!_months.contains(currentMonth)) _months.add(currentMonth);
    return currentBudget;
  }

  /// Returns the Month in History that matches the given MonthTime. If no match is found, returns null.
  Month getMonthFromMonthTime(MonthTime mt) {
    return _months.firstWhere((Month m) => m.monthTime == mt, orElse: null);
  }

  /// Returns the Month in History that matches the given DateTime. If no match is found, returns null.
  Month getMonthFromDateTime(DateTime dt) {
    return _months.firstWhere((Month m) => m.timeIsInMonth(dt), orElse: null);
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
    String cipher = await BudgetControl.fileIO.readFile(historyFilepath);
    Encrypted e = Serializer.unserialize(encryptedKey, cipher);
    String plaintext = BudgetControl.crypter.decrypt(e);
    History h = Serializer.unserialize(historyKey, plaintext);
    return h;
  }
}
