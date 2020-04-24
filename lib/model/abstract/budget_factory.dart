import 'package:budgetflow/model/data_types/budget.dart';

abstract class BudgetFactory {
  /// Returns a new budget based on user-provided info.
  Budget newFromInfo();

  /// Returns a new budget based on the values in an older budget.
  Budget newMonthBudget(Budget old);
}
