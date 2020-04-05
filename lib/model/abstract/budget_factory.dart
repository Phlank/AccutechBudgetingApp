import 'package:budgetflow/model/data_types/budget.dart';

abstract class BudgetFactory {
  Budget newFromInfo(double income, double housing, bool depletion,
      double savingsPull, bool kids, bool pets);

  Budget newFromBudget(Budget old);
}
