import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/budget_month.dart';
import 'package:budgetflow/budget/transaction.dart';

class Budget {
    Map<BudgetCategory, double> _allottedSpending, _actualSpending;
    double _monthlyIncome;
    List<Transaction> _transactions;

    Budget(double monthlyIncome) {
        _populateBlankMaps();
        this._monthlyIncome = monthlyIncome;
    }

    void _populateBlankMaps() {
        _allottedSpending = new Map();
        _actualSpending = new Map();
        for (BudgetCategory category in BudgetCategory.values) {
            _allottedSpending[category] = 0.0;
            _actualSpending[category] = 0.0;
        }
    }

    double setAllotment(BudgetCategory category, double amount) {
        double remove = _allottedSpending.remove(category);
        _allottedSpending[category] = amount;
        return remove;
    }

    double addTransaction(Transaction transaction) {
        if (transaction.category != null) {
            _transactions.add(transaction);
            _actualSpending[transaction.category] += transaction.delta;
            return _actualSpending[transaction.category];
        }
        _actualSpending[BudgetCategory.miscellaneous] += transaction.delta;
        return _actualSpending[BudgetCategory.miscellaneous];
    }

    double getSpending(BudgetCategory category) {
        return _actualSpending[category];
    }

    double getAllotment(BudgetCategory category) {
        return _allottedSpending[category];
    }

    BudgetMonth toBudgetMonth() {
        // TODO implement
        return null;
    }
}
