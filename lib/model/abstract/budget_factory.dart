import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/utils/setup_agent.dart';

abstract class BudgetFactory {
  Budget newFromInfo(SetupAgent agent);

  Budget newMonthBudget(Budget old);
}
