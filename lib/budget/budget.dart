import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/budget_map.dart';
import 'package:budgetflow/budget/budget_type.dart';
import 'package:budgetflow/budget/transaction.dart';
import 'package:budgetflow/history/month.dart';

class Budget {
	BudgetMap _allottedSpending, _actualSpending;
    double _monthlyIncome;
    List<Transaction> _transactions;
	BudgetType _type;
	double wantsRatio, needsRatio;

    Budget(double monthlyIncome) {
        _populateBlankMaps();
        this._monthlyIncome = monthlyIncome;
    }

    void _populateBlankMaps() {
	    _allottedSpending = new BudgetMap();
	    _actualSpending = new BudgetMap();
    }

    double setAllotment(BudgetCategory category, double amount) {
	    _allottedSpending.set(category, amount);
	    return amount;
    }

    double getMonthlyIncome(){
        return _monthlyIncome;
    }

    double addTransaction(Transaction transaction) {
        if (transaction.category != null) {
            _transactions.add(transaction);
            _actualSpending.addTo(transaction.category, transaction.delta);
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

    Month toMonth() {
        // TODO implement
        return null;
    }

	void setType(BudgetType type) {
		this._type = type;
	}

	BudgetType getType() {
		return _type;
	}

	static Budget fromOldAllottments(Budget old) {
		Budget b = new Budget(old._monthlyIncome);
		b._allottedSpending = old._allottedSpending;
		return b;
	}
}
