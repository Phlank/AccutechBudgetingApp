import 'package:budgetflow/model/budget/allocation_list.dart';
import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/history/month_io.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:flutter/widgets.dart';

class Month implements Serializable {
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
    if (_actual == null) {
      _actual = await io.loadActual();
    }
    return _actual;
  }

  Future<AllocationList> get target async {
    if (_target == null) {
      _target = await io.loadTarget();
    }
    return _target;
  }

  Future<TransactionList> get transactions async {
    if (_transactions == null) {
      _transactions = await io.loadTransactions();
    }
    return _transactions;
  }

  void updateMonthData(Budget budget) {
    _allotted = budget.allotted;
    _actual = budget.actual;
    _transactions = budget.transactions;
    type = budget.type;
  }

  Future save() async {
    if (_allotted != null) await _saveAllottedSpending();
    if (_actual != null) await _saveActualSpending();
    if (_target != null) await _saveTargetSpending();
    if (_transactions != null) await _saveTransactions();
  }

  Future _saveAllottedSpending() async {
    if (_allotted != null) {
      io.saveAllotted(_allotted);
    }
  }

  Future _saveActualSpending() async {
    if (_actual != null) {
      io.saveActual(_actual);
    }
  }

  Future _saveTargetSpending() async {
    if (_target != null) {
      io.saveTarget(_target);
    }
  }

  Future _saveTransactions() async {
    if (_transactions != null) {
      io.saveTransactions(_transactions);
    }
  }

  MonthTime getMonthTime() => monthTime;

  double getIncome() => income;

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
        this._allotted == other._allotted &&
        this._actual == other._actual &&
        this._transactions == other._transactions;
  }

  int get hashCode =>
      monthTime.hashCode ^
      income.hashCode ^
      type.hashCode ^
      allotted.hashCode ^
      actual.hashCode ^
      transactions.hashCode;

  String toString() {
    return monthTime.year.toString() + "_" + monthTime.month.toString();
  }
}
