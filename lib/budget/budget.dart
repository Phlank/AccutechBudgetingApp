import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/budget_month.dart';

class Budget {
	Map<BudgetCategory, double> allottedSpending, actualSpending;
	double monthlyIncome;

	Budget(double monthlyIncome) {
		populateMaps();
		this.monthlyIncome = monthlyIncome;
	}

	void populateMaps() {
		allottedSpending = new Map();
		actualSpending = new Map();
		for (BudgetCategory category in BudgetCategory.values) {
			allottedSpending[category] = 0.0;
			actualSpending[category] = 0.0;
		}
	}

	double setAllotment(BudgetCategory category, double amount) {
		double remove = allottedSpending.remove(category);
		allottedSpending[category] = amount;
		return remove;
	}

	BudgetMonth toBudgetMonth() {
		return null;
	}
}
