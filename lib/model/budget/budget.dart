import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/category/category_list.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/history/month.dart';

class BudgetBuilder {
  CategoryList _categories;
  BudgetMap _allottedSpending, _actualSpending;
  BudgetType _type;
  TransactionList _transactions;
  double _income;

  BudgetBuilder() {
    _categories = new CategoryList();
    _allottedSpending = new BudgetMap();
    _actualSpending = new BudgetMap();
    _transactions = new TransactionList();
  }

  BudgetBuilder setIncome(double income) {
    _income = income;
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
    if (_income == null) throw new NullThrownError();
    if (_type == null) throw new NullThrownError();
    if (_allottedSpending == null) throw new NullThrownError();
    if (_actualSpending == null) throw new NullThrownError();
    if (_transactions == null) throw new NullThrownError();
    return new Budget._new(
        _allottedSpending, //
        _actualSpending, //
        _transactions, //
        _income, //
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

  Budget._new(this._allotted, this._actual, this._transactions, this._income,
      this._type, this._categories);

  // Makes a new budget based on the allocations of an old budget
  Budget.fromOldBudget(Budget old) {
    _income = old._income;
    _type = old._type;
    _allotted = BudgetMap.copyOf(old._allotted);
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
      _actual.addTo(transaction.category, -transaction.delta);
    } else {
      _actual.addTo(Category.miscellaneous, -transaction.delta);
    }
  }

  void setType(BudgetType type) {
    this._type = type;
  }
}
