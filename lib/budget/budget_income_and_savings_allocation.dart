import 'package:budgetflow/budget/budget_creator_interface.dart';

abstract class budgetIncomeandSavingsAllocation implements budgetCreator {

  void AllocateBudget() {
    switch (BudgetPlan) {
      case ("Stage 1"):{
        setDepletingBudget(0.6, 0.4);
        }
        break;

      case ("Stage 2"):{
        setDepletingBudget(0.75, 0.25);
        setDepletingTargetBudget(0.6, 0.4);
      }
      break;

      case ("Stage 3"):{
        setDepletingBudget(0.85, 0.15);
        setDepletingTargetBudget(0.75, 0.25);
      }
      break;

      case ("Stage 4"):{
        setDepletingBudget(0.95, 0.05);
        setDepletingTargetBudget(0.85, 0.15);
      }
      break;

      default:{

      }
    }
  }
}