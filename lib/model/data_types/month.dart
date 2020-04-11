import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/budget_period.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/allocation_list.dart';
import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/data_types/budget_type.dart';
import 'package:budgetflow/model/data_types/month_time.dart';
import 'package:budgetflow/model/data_types/transaction_list.dart';
import 'package:budgetflow/model/implementations/month_io.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter/widgets.dart';

class Month implements Serializable, BudgetPeriod {
  MonthIO io;
  AllocationList _allotted, _actual, _target;
  TransactionList _transactions;
  MonthTime monthTime;
  double income;
  BudgetType type;

  Month({
    @required this.monthTime,
    @required this.income,
    @required this.type,
    AllocationList allotted,
    AllocationList actual,
    AllocationList target,
    TransactionList transactions,
  }) {
    io = MonthIO(this);
    if (allotted != null) _allotted = allotted;
    if (actual != null) _actual = actual;
    if (target != null) _target = target;
    if (transactions != null) _transactions = transactions;
  }

  Month.fromBudget(Budget b) {
    monthTime = MonthTime.now();
    income = b.expectedIncome;
    type = b.type;
    _allotted = b.allotted;
    _actual = b.actual;
    _transactions = b.transactions;
    io = MonthIO(this);
  }

  Future<AllocationList> get allotted async {
    if (_allotted == null) {
      _allotted = await io.loadAllotted();
    }
    return _allotted;
  }

  Future<AllocationList> get actual async {
    if (actual == null) {
      _actual = await io.loadActual();
    }
    return _actual;
  }

  Future<AllocationList> get target async {
    if (target == null) {
      _target = await io.loadTarget();
    }
    return _target;
  }

  Future<TransactionList> get transactions async {
    if (transactions == null) {
      _transactions = await io.loadTransactions();
    }
    return _transactions;
  }

  bool timeIsInMonth(DateTime input) {
    return input.year == monthTime.year && input.month == monthTime.month;
  }

  void updateMonthData(Budget budget) {
    _allotted = budget.allotted;
    _actual = budget.actual;
    _transactions = budget.transactions;
    type = budget.type;
  }

  Future save() async {
    if (allotted != null) await _saveAllottedSpending();
    if (actual != null) await _saveActualSpending();
    if (target != null) await _saveTargetSpending();
    if (transactions != null) await _saveTransactions();
  }

  Future _saveAllottedSpending() async {
    if (allotted != null) {
      io.saveAllotted();
    }
  }

  Future _saveActualSpending() async {
    if (actual != null) {
      io.saveActual();
    }
  }

  Future _saveTargetSpending() async {
    if (target != null) {
      io.saveTarget();
    }
  }

  Future _saveTransactions() async {
    if (_transactions != null) {
      io.saveTransactions();
    }
  }

  MonthTime getMonthTime() => monthTime;

  double getIncome() => income;

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(yearKey, monthTime.year);
    serializer.addPair(monthKey, monthTime.month);
    serializer.addPair(incomeKey, income);
    serializer.addPair(typeKey, type);
    return serializer.serialize;
  }

  bool operator ==(Object other) => other is Month && this._equals(other);

  bool _equals(Month other) {
    return this.monthTime == other.monthTime &&
        this.income == other.income &&
        this.type == other.type &&
        this.allotted == other.allotted &&
        this.actual == other.actual &&
        this.transactions == other.transactions;
  }

  int get hashCode =>
      monthTime.hashCode ^
      income.hashCode ^
      type.hashCode ^
      _allotted.hashCode ^
      _actual.hashCode ^
      transactions.hashCode;

  String toString() {
    return monthTime.year.toString() + "_" + monthTime.month.toString();
  }
}
