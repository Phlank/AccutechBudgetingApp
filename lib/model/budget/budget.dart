import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/category/category_list.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/util/dates.dart';
import 'package:calendarro/date_utils.dart';

import 'category/priority.dart';

class BudgetBuilder {
  CategoryList _categories;
  BudgetMap _allottedSpending, _actualSpending;
  BudgetType _type;
  TransactionList _transactions;
  double _expectedIncome;

  BudgetBuilder() {
    _categories = new CategoryList();
    _allottedSpending = new BudgetMap();
    _actualSpending = new BudgetMap();
    _transactions = new TransactionList();
  }

  BudgetBuilder setIncome(double income) {
    _expectedIncome = income;
    return this;
  }

  BudgetBuilder setType(BudgetType type) {
    _type = type;
    return this;
  }

  BudgetBuilder setAllottedSpending(BudgetMap allottedSpending) {
    _allottedSpending = allottedSpending;
    return this;
  }

  BudgetBuilder setActualSpending(BudgetMap actualSpending) {
    _actualSpending = actualSpending;
    return this;
  }

  BudgetBuilder setTransactions(TransactionList transactions) {
    _transactions = transactions;
    return this;
  }

  BudgetBuilder setCategories(CategoryList categories) {
    _categories = categories;
    return this;
  }

  Budget build() {
    if (_expectedIncome == null) throw new NullThrownError();
    if (_type == null) throw new NullThrownError();
    if (_allottedSpending == null) throw new NullThrownError();
    if (_actualSpending == null) throw new NullThrownError();
    if (_transactions == null) throw new NullThrownError();
    return new Budget._new(
        _allottedSpending, //
        _actualSpending, //
        _transactions, //
        _expectedIncome, //
        _type, //
        _categories);
  }
}

class Budget {
  CategoryList _categories;
  BudgetMap _allotted, _actual;
  TransactionList _transactions;
  double _income;
  BudgetType _type;

  // TODO turn this into a constructor with named arguments rather than using a builder
  Budget._new(this._allotted, this._actual, this._transactions, this._income,
      this._type, this._categories) {
    // TODO if there are transactions present and actual spending is empty, use transactions to update actual spending
  }

  // Makes a new budget based on the allocations of an old budget
  Budget.fromOldBudget(Budget old) {
    _income = old._income;
    _type = old._type;
    _allotted = Map.from(old._allotted);
    _actual = new BudgetMap();
    _transactions = new TransactionList();
  }

  // Makes a new budget based on data currently represented within a month
  // Used to load a budget object from disk
  static Future<Budget> fromMonth(Month month) async {
    BudgetBuilder builder = new BudgetBuilder();
    BudgetMap allotted = await month.allotted;
    BudgetMap actual = await month.actual;
    TransactionList transactions = await month.transactions;
    builder
        .setIncome(month.income)
        .setType(month.type)
        .setAllottedSpending(allotted)
        .setActualSpending(actual)
        .setTransactions(transactions);
    return builder.build();
  }

  double get income => _income;

  BudgetType get type => _type;

  BudgetMap get allotted => _allotted;

  BudgetMap get actual => _actual;

  TransactionList get transactions => _transactions;

  CategoryList get categories => _categories;

  double get spent {
    double spent = 0.0;
    for (Category category in CategoryList.defaultCategories) {
      spent += _actual[category];
    }
    return spent;
  }

  double get remaining => _income - spent;

  double setAllotment(Category category, double amount) {
    _allotted[category] = amount;
    return amount;
  }

  double getMonthlyIncome() {
    return _income;
  }

  void setMonthlyIncome(double income) {
    _income = income;
  }

  void addTransaction(Transaction transaction) {
    if (transaction.category != null) {
      _transactions.add(transaction);
      _actual[transaction.category] -= transaction.amount;
    } else {
      _actual[Category.uncategorized] -= transaction.amount;
    }
  }

  void setType(BudgetType type) {
    this._type = type;
  }

  double get netMonth {
    double net = 0.0;
    _transactions.forEach((t) {
      net += t.amount;
    });
    return net;
  }

  double get netWeek {
    double net = 0.0;
    _transactions.forEach((t) {
      if (t.time.isAfter(DateTime.now().subtract(Duration(days: 7)))) {
        net += t.amount;
      }
    });
    return net;
  }

  double get balanceMonth => income - spent;

  double get balanceWeek {
    return _getWeeklyIncome() - _getWeeklySpending();
  }

  double _getWeeklyIncome() {
    int numDaysInWeek =
        Dates.getEndOfWeek().difference(Dates.getStartOfWeek()).inDays;
    return income *
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
    _allotted.forEach((category, amount) {
      if (category.priority == priority) total += amount;
    });
    return total;
  }

  double getActualPriority(Priority priority) {
    double total = 0;
    _actual.forEach((category, amount) {
      if (category.priority == priority) total += amount;
    });
    return total;
  }

  double getRemainingPriority(Priority priority) {
    return getAllottedPriority(priority) - getActualPriority(priority);
  }

  double getAllottedCategory(Category category) {
    return _allotted[category];
  }

  double getActualCategory(Category category) {
    return _actual[category];
  }

  double getRemainingCategory(Category category) {
    return _allotted[category] - _actual[category];
  }

  List<Category> getCategoriesOfPriority(Priority priority) {
    List<Category> list = List();
    _allotted.forEach((category, double) {
//      print("Category: " + category.name + " has a priority of " +
//          category.priority.name);
//      print(priority.name + " == " + category.priority.name + " is " +
//          (category.priority == priority).toString());
      if (category.priority == priority) list.add(category);
    });
    return list;
  }

  void removeTransaction(Transaction transaction) {
    _transactions.remove(transaction);
  }
}
