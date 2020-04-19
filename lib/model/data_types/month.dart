import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/allocation_list.dart';
import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/data_types/budget_type.dart';
import 'package:budgetflow/model/data_types/transaction_list.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter/widgets.dart';

class Month implements Serializable {
  AllocationList allotted, actual, target;
  TransactionList transactions;
  DateTime time;
  double income;
  BudgetType type;

  Month({
    @required this.time,
    @required this.income,
    @required this.type,
    this.allotted,
    this.actual,
    this.target,
    this.transactions,
  }) {
    if (allotted != null) allotted = allotted;
    if (actual != null) actual = actual;
    if (target != null) target = target;
    if (transactions != null) transactions = transactions;
  }

  Month.fromBudget(Budget b) {
    time = DateTime.now();
    income = b.expectedIncome;
    type = b.type;
    allotted = b.allotted;
    actual = b.actual;
    target = b.target;
    transactions = b.transactions;
  }

  bool timeIsInMonth(DateTime input) {
    return input.year == time.year && input.month == time.month;
  }

  void updateMonthData(Budget budget) {
    allotted = budget.allotted;
    actual = budget.actual;
    transactions = budget.transactions;
    type = budget.type;
  }

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(timeKey, time.toIso8601String());
    serializer.addPair(incomeKey, income);
    serializer.addPair(typeKey, type);
    serializer.addPair(allottedKey, allotted);
    serializer.addPair(actualKey, actual);
    serializer.addPair(targetKey, target);
    serializer.addPair(transactionsKey, transactions);
    return serializer.serialize;
  }

  bool operator ==(Object other) => other is Month && this._equals(other);

  bool _equals(Month other) {
    return this.time.year == other.time.year &&
        this.time.month == other.time.month &&
        this.income == other.income &&
        this.type == other.type &&
        this.allotted == other.allotted &&
        this.actual == other.actual &&
        this.transactions == other.transactions;
  }

  int get hashCode =>
      time.year.hashCode ^
      time.month.hashCode ^
      income.hashCode ^
      type.hashCode ^
      allotted.hashCode ^
      actual.hashCode ^
      transactions.hashCode;

  String toString() {
    return time.year.toString() + "_" + time.month.toString();
  }
}
