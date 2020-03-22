import 'package:budgetflow/model/budget/budget.dart';

abstract class BudgetFactory {
  Budget newFromInfo(double income, double housing, bool depletion,
      double savingsPull, bool kids, bool pets);

  Budget newFromBudget(Budget old);
}
