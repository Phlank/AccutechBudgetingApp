import 'package:budgetflow/budget/budget_allocation.dart';
import 'package:budgetflow/budget/budget_creator_interface.dart';
import 'package:budgetflow/budget/budget_factory.dart';

abstract class BudgetUpdate
    implements
        BudgetAllocation,
        BudgetFactory,
        BudgetCreator {

}
