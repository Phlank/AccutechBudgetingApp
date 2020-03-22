import 'package:budgetflow/model/budget/allocation.dart';
import 'package:budgetflow/model/budget/allocation_list.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/category/category_list.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/util/dates.dart';
import 'package:calendarro/date_utils.dart';
import 'package:flutter/widgets.dart';

import 'category/priority.dart';

class Budget {
  AllocationList allotted, actual, target;
  TransactionList transactions;
  double expectedIncome, actualIncome;
  BudgetType type;

  Budget({
    @required this.expectedIncome,
    @required this.type,
    @required this.target,
    @required this.allotted,
    this.actual,
    this.transactions,
    this.actualIncome = 0.0,
  }) {
    _resolveOptionalParameters();
  }

  void _resolveOptionalParameters() {
    if (actual == null) actual = AllocationList.withCategoriesOf(allotted);
    if (transactions == null) transactions = TransactionList();
  }

  // Makes a new budget based on the allocations of an old budget
  Budget.from(Budget old) {
    expectedIncome = old.expectedIncome;
    type = old.type;
    allotted = AllocationList.from(old.allotted);
    target = AllocationList.from(old.target);
    actual = AllocationList.withCategoriesOf(allotted);
    transactions = TransactionList();
  }

  // Makes a new budget based on data currently represented within a month
  // Used to load a budget object from disk
  static Future<Budget> fromMonth(Month month) async {
    return Budget(
      allotted: await month.allotted,
      actual: await month.actual,
      target: AllocationList(),
      transactions: await month.transactions,
      expectedIncome: month.income,
      actualIncome: 0.0,
      type: month.type,
    );
  }

  double setAllotment(Category category, double amount) {
    allotted
    .
  }

  void setIncome(double income) {
    expectedIncome = income;
  }

  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    if (transaction.category == null) {
      actual[Category.uncategorized] += -transaction.amount;
    }
    if (transaction.category == Category.income) {
      actualIncome += transaction.amount;
      actual[transaction.category] += transaction.amount;
    } else {
      actual[transaction.category] += -transaction.amount;
    }
  }

  double get netMonth {
    double net = 0.0;
    transactions.forEach((t) {
      net += t.amount;
    });
    return net;
  }

  double get netWeek {
    double net = 0.0;
    transactions.forEach((t) {
      if (t.time.isAfter(DateTime.now().subtract(Duration(days: 7)))) {
        net += t.amount;
      }
    });
    return net;
  }

  double get balanceMonth => expectedIncome - spent;

  double get balanceWeek {
    return _getWeeklyIncome() + _getWeeklySpending();
  }

  double _getWeeklyIncome() {
    int numDaysInWeek =
        Dates.getEndOfWeek().difference(Dates.getStartOfWeek()).inDays;
    return expectedIncome *
        numDaysInWeek /
        DateUtils.getLastDayOfCurrentMonth().day.toDouble();
  }

  double _getWeeklySpending() {
    double weeklySpending = 0.0;
    transactions.forEach((transaction) {
      if (transaction.time.isBefore(Dates.getEndOfWeek()) &&
          transaction.time.isAfter(Dates.getStartOfWeek())) {
        if (transaction.category != Category.income)
          weeklySpending += transaction.amount;
      }
    });
    return weeklySpending;
  }

  double getAllottedPriority(Priority priority) {
    double total = 0;
    allotted.forEach((category, amount) {
      if (category.priority == priority) total += amount;
    });
    return total;
  }

  double getActualPriority(Priority priority) {
    double total = 0;
    actual.forEach((category, amount) {
      if (category.priority == priority) total += amount;
    });
    return total;
  }

  double getRemainingPriority(Priority priority) {
    return getAllottedPriority(priority) - getActualPriority(priority);
  }

  double getAllottedCategory(Category category) {
    return allotted[category];
  }

  double getActualCategory(Category category) {
    return actual[category];
  }

  double getRemainingCategory(Category category) {
    return allotted[category] - actual[category];
  }

  List<Category> getCategoriesOfPriority(Priority priority) {
    List<Category> list = List();
    allotted.forEach((category, double) {
//      print("Category: " + category.name + " has a priority of " +
//          category.priority.name);
//      print(priority.name + " == " + category.priority.name + " is " +
//          (category.priority == priority).toString());
      if (category.priority == priority) list.add(category);
    });
    return list;
  }

  void removeTransaction(Transaction transaction) {
    transactions.remove(transaction);
    // TODO update income if it has category of income
  }
}
