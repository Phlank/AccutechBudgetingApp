import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_type.dart';

abstract class BudgetFactory {
  Budget newFromInfo(double income, double housing, BudgetType type);

  Budget newFromBudget(Budget old);
}