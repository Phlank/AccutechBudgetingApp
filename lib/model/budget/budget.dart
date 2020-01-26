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
  BudgetMap _allottedSpending, _actualSpending;
  TransactionList _transactions;
  double _income;
  BudgetType _type;

  Budget._new(this._allottedSpending, this._actualSpending, this._transactions,
      this._income, this._type);

  // Makes a new budget based on the allocations of an old budget
  Budget.fromOldBudget(Budget old) {
    _income = old._income;
    _type = old._type;
    _allottedSpending = BudgetMap.copyOf(old._allottedSpending);
    _actualSpending = new BudgetMap();
    _transactions = new TransactionList();
  }

  // Makes a new budget based on data currently represented within a month
  Budget.fromMonth(Month month) {
    _income = month.getIncome();
    _type = month.type;
    _allottedSpending = month.allotted;
    _actualSpending = month.actual;
    _transactions = month.transactions;
  }

  double get income => _income;

  BudgetType get type => _type;

  BudgetMap get allottedSpending => _allottedSpending;

  BudgetMap get actualSpending => _actualSpending;

  TransactionList get transactions => _transactions;

  double setAllotment(BudgetCategory category, double amount) {
    _allottedSpending.set(category, amount);
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
      _actualSpending.addTo(transaction.category, -transaction.delta);
      return _actualSpending.valueOf(transaction.category);
    }
    _actualSpending.addTo(BudgetCategory.miscellaneous, transaction.delta);
    return _actualSpending.valueOf(BudgetCategory.miscellaneous);
  }

  double getSpending(BudgetCategory category) {
    return _actualSpending.valueOf(category);
  }

  double getAllotment(BudgetCategory category) {
    return _allottedSpending.valueOf(category);
  }

  void setType(BudgetType type) {
    this._type = type;
  }

  BudgetType getType() {
    return _type;
  }
}
