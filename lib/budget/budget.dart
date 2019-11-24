import 'budget_category.dart';

class Budget {

  Map<BudgetCategory, double> allottedSpending, actualSpending;
  double monthlyIncome;

  Budget() {
    populateMaps();
  }

  void populateMaps() {
    allottedSpending = new Map();
    actualSpending = new Map();
    for (BudgetCategory category in BudgetCategory.values) {
      allottedSpending[category] = 0.0;
      actualSpending[category] = 0.0;
    }
  }

  double zero() {
    return 0.0;
  }

}
