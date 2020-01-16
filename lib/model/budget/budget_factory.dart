import 'package:budgetflow/model/budget/budget.dart';

abstract class BudgetFactory {
	Budget newFromInfo();

	Budget newFromBudget();
}