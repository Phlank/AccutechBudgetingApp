import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/history/month.dart';

class BudgetBuilder {
  BudgetMap _allottedSpending, _actualSpending;
  BudgetType _type;
  TransactionList _transactions;
  double _income;

  BudgetBuilder() {
    _allottedSpending = new BudgetMap();
    _actualSpending = new BudgetMap();
    _transactions = new TransactionList();
  }

  void setIncome(double income) {
    _income = income;
  }

  void setType(BudgetType type) {
    _type = type;
  }

  void setAllottedSpending(BudgetMap allottedSpending) {
    _allottedSpending = allottedSpending;
  }

  void setActualSpending(BudgetMap actualSpending) {
    _actualSpending = actualSpending;
  }

  void setTransactions(TransactionList transactions) {
    _transactions = transactions;
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
        _type);
  }
}

class Budget {
  BudgetMap _allotted, _actual;
  TransactionList _transactions;
  double _income;
  BudgetType _type;

  Budget._new(this._allotted, this._actual, this._transactions,
      this._income, this._type);

  // Makes a new budget based on the allocations of an old budget
  Budget.fromOldBudget(Budget old) {
    _income = old._income;
    _type = old._type;
    _allotted = BudgetMap.copyOf(old._allotted);
    _actual = new BudgetMap();
    _transactions = new TransactionList();
  }

  // Makes a new budget based on data currently represented within a month
  Budget.fromMonth(Month month) {
    _income = month.getIncome();
    _type = month.type;
    _allotted = month.allotted;
    _actual = month.actual;
    _transactions = month.transactions;
  }

  double get income => _income;

  BudgetType get type => _type;

  BudgetMap get allotted => _allotted;

  BudgetMap get actual => _actual;

  TransactionList get transactions => _transactions;

  double get spent {
    double spent = 0.0;
    for (BudgetCategory category in BudgetCategory.values) {
      spent += _actual[category];
    }
    return spent;
  }

  double get remaining => _income - spent;

  double setAllotment(BudgetCategory category, double amount) {
    _allotted[category] = amount;
    return amount;
  }

  double getMonthlyIncome() {
    return _income;
  }

  void setMonthlyIncome(double income) {
    _income = income;
  }

  double addTransaction(Transaction transaction) {
    if (transaction.category != null) {
      _transactions.add(transaction);
      _actual.addTo(transaction.category, -transaction.delta);
      return _actual[transaction.category];
    }
    _actual.addTo(BudgetCategory.miscellaneous, transaction.delta);
    return _actual[BudgetCategory.miscellaneous];
  }

  void setType(BudgetType type) {
    this._type = type;
  }
}
