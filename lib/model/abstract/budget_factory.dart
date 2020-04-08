import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/setup_agent.dart';

abstract class BudgetFactory {
  Budget newFromInfo(SetupAgent agent);

  Budget newMonthBudget(Budget old);
}
