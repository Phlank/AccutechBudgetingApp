import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/history/month.dart';

class Budget {
  BudgetMap allottedSpending, actualSpending;
  double _monthlyIncome;
  TransactionList transactions;
  BudgetType _type;
  double wantsRatio, needsRatio;

  Budget(double monthlyIncome) {
    _populateBlankMaps();
    this._monthlyIncome = monthlyIncome;
  }

  void _populateBlankMaps() {
    allottedSpending = new BudgetMap();
    actualSpending = new BudgetMap();
    transactions = new TransactionList();
  }

  double setAllotment(BudgetCategory category, double amount) {
    allottedSpending.set(category, amount);
    return amount;
  }

  double getMonthlyIncome() {
    return _monthlyIncome;
  }

  double addTransaction(Transaction transaction) {
    if (transaction.category != null) {
      transactions.add(transaction);
      actualSpending.addTo(transaction.category, transaction.delta);
      return actualSpending.valueOf(transaction.category);
    }
    actualSpending.addTo(BudgetCategory.miscellaneous, transaction.delta);
    return actualSpending.valueOf(BudgetCategory.miscellaneous);
  }

  double getSpending(BudgetCategory category) {
    return actualSpending.valueOf(category);
  }

  double getAllotment(BudgetCategory category) {
    return allottedSpending.valueOf(category);
  }

  void setType(BudgetType type) {
    this._type = type;
  }

  BudgetType getType() {
    return _type;
  }

  static Budget fromOldAllottments(Budget old) {
    Budget b = new Budget(old._monthlyIncome);
    b.allottedSpending = old.allottedSpending;
    return b;
  }

  static Budget fromMonth(Month month) {
    // TODO redo this
    Budget b = new Budget(0.0);
    return b;
  }
}
