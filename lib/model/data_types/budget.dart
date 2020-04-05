import 'package:budgetflow/model/data_types/allocation_list.dart';
import 'package:budgetflow/model/data_types/budget_type.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/data_types/transaction_list.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:flutter/widgets.dart';

import 'priority.dart';

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

  void setAllotment(Category category, double amount) {
    allotted.getCategory(category).value = amount;
  }

  void setIncome(double income) {
    expectedIncome = income;
  }

  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    if (transaction.category == null) {
      actual
          .getCategory(transaction.category)
          .value += transaction.amount.abs();
    }
    if (transaction.category == Category.income) {
      actualIncome += transaction.amount;
      actual.getCategory(transaction.category).value += transaction.amount;
    } else {
      actual
          .getCategory(transaction.category)
          .value += transaction.amount.abs();
    }
  }

  List<Category> getCategoriesOfPriority(Priority priority) {
    List<Category> list = List();
    allotted.forEach((allocation) {
      if (allocation.category.priority == priority)
        list.add(allocation.category);
    });
    return list;
  }

  void removeTransaction(Transaction transaction) {
    transactions.remove(transaction);
    // update income if it has category of income
    if (transaction.category == Category.income) {
      actualIncome -= transaction.amount;
    }
    // update actual of the category
    actual.getCategory(transaction.category).value -= transaction.amount;
  }
}
