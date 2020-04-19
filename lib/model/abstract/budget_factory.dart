import 'package:budgetflow/model/data_types/budget.dart';

abstract class BudgetFactory {
  Budget newFromInfo();

  Budget newMonthBudget(Budget old);
}
