import 'package:budgetflow/model/budget/budget.dart';

class BudgetAccountant {
  Budget _budget;

  BudgetAccountant(Budget budget) {
    _budget = budget;
  }

  double get spent {
    double spent = 0.0;
    _budget.actual.spendingAllocations.forEach((allocation) {
      spent += allocation.value.abs();
    });
    return spent;
  }

  double get remaining => _budget.expectedIncome - spent;
}
