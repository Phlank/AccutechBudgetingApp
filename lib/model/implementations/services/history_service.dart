import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/service.dart';
import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/data_types/history.dart';
import 'package:budgetflow/model/data_types/month.dart';
import 'package:budgetflow/model/implementations/io/history_io.dart';
import 'package:budgetflow/model/implementations/priority_budget_factory.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';

class HistoryService implements Service {
  ServiceDispatcher _dispatcher;
  History _history = History();

  HistoryService(this._dispatcher);

  Future start() async {
    await load();
  }

  Future stop() async {
    await save();
  }

  Future<bool> historyFileExists() {
    return _dispatcher.getFileService().fileExists(historyFilepath);
  }

  Future load() async {
    if (await historyFileExists()) {
      HistoryIO io = HistoryIO(_dispatcher.getFileService());
      _history = await io.load();
    }
  }

  Future save() async {
    HistoryIO io = HistoryIO.fromHistory(
        _history, _dispatcher.getFileService());
    io.save();
  }

  Future<Budget> getLatestMonthBudget() async {
    var currentMonth = _history.getMonthFromDateTime(DateTime.now());
    if (currentMonth != null) {
      return Budget.fromMonth(currentMonth);
    } else {
      return _createNewMonthBudget();
    }
  }

  Month get currentMonth =>
      _history.firstWhere((month) {
        return month.timeIsInMonth(DateTime.now());
      }, orElse: null);

  Future<Budget> _createNewMonthBudget() async {
    Month lastMonth = _history.last;
    Budget lastBudget = await Budget.fromMonth(lastMonth);
    PriorityBudgetFactory factory = new PriorityBudgetFactory();
    Budget currentBudget = factory.newMonthBudget(lastBudget);
    var currentMonth = Month.fromBudget(currentBudget);
    currentMonth.updateMonthData(currentBudget);
    if (!_history.contains(currentMonth)) {
      _history.add(currentMonth);
    }
    return currentBudget;
  }

  void _updateCurrentMonth(Budget budget) {
    _history.getMonthFromDateTime(DateTime.now()).updateMonthData(budget);
  }

  void add(Month month) {
    _history.add(month);
  }

  void remove(Month month) {
    _history.remove(month);
  }
}
