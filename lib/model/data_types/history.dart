import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/budget_factory.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/data_types/encrypted.dart';
import 'package:budgetflow/model/data_types/month.dart';
import 'package:budgetflow/model/implementations/priority_budget_factory.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:quiver/collection.dart';

class History extends DelegatingList<Month> implements Serializable {
  List<Month> months;
  Month currentMonth;
  Budget budget;
  bool newUser;

  List<Month> get delegate => months;

  History() {
    months = [];
  }

  void save(Budget current) {
    _updateCurrentMonth(current);
    for (int i = 0; i < months.length; i++) {
      months[i].save();
    }
    Encrypted e = BudgetControl.crypter.encrypt(serialize);
    BudgetControl.fileIO.writeFile(historyFilepath, e.serialize);
  }

  void _updateCurrentMonth(Budget budget) {
    getMonthFromDateTime(DateTime.now()).updateMonthData(budget);
  }

  Future<Budget> getLatestMonthBudget() async {
    currentMonth = getMonthFromDateTime(DateTime.now());
    if (currentMonth != null) {
      return Budget.fromMonth(currentMonth);
    } else {
      return _createNewMonthBudget();
    }
  }

  Future<Budget> _createNewMonthBudget() async {
    Month lastMonth = months[months.length - 1];
    Budget lastBudget = await Budget.fromMonth(lastMonth);
    BudgetFactory factory = new PriorityBudgetFactory();
    Budget currentBudget = factory.newMonthBudget(lastBudget);
    currentMonth = Month.fromBudget(currentBudget);
    currentMonth.updateMonthData(currentBudget);
    if (!months.contains(currentMonth)) months.add(currentMonth);
    return currentBudget;
  }

  /// Returns the Month in History that matches the given DateTime. If no match is found, returns null.
  Month getMonthFromDateTime(DateTime dt) {
    return months.firstWhere((Month m) => m.timeIsInMonth(dt), orElse: null);
  }

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    int i = 0;
    months.forEach((Month m) {
      serializer.addPair(i, m.time.millisecondsSinceEpoch);
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
