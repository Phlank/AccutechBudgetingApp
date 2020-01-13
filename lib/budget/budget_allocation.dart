import 'package:budgetflow/budget/budget_creator_interface.dart';

abstract class BudgetAllocation implements BudgetCreator {
  void AllocateBudget() {
    switch (BudgetPlan) {
      case ("Stage 1-2"):
        {
          setDepletingBudget(0.6, 0.4);
          getDepletingBudget();
        }
        break;

      case ("Stage 2-2"):
        {
          setDepletingBudget(0.75, 0.25);
          getDepletingBudget();
          setDepletingTargetBudget(0.6, 0.4);
          getDepletingTargetBudget();
        }
        break;

      case ("Stage 3-2"):
        {
          setDepletingBudget(0.85, 0.15);
          getDepletingBudget();
          setDepletingTargetBudget(0.75, 0.25);
          getDepletingTargetBudget();
        }
        break;

      case ("Stage 4-2"):
        {
          setDepletingBudget(0.95, 0.05);
          getDepletingBudget();
          setDepletingTargetBudget(0.85, 0.15);
          getDepletingTargetBudget();
        }
        break;

      case ("Stage 1-1"):
        {
          setGrowthBudget(0.5, 0.2, 0.3);
          getGrowthBudget();
        }
        break;

      case ("Stage 2-1"):
        {
          setGrowthBudget(0.65, 0.2, 0.15);
          getGrowthBudget();
          setTargetBudget(0.5, 0.2, 0.3);
          getTargetBudget();
        }
        break;

      case ("Stage 3-1"):
        {
          setGrowthBudget(0.75, 0.1, 0.15);
          getGrowthBudget();
          setTargetBudget(0.65, 0.2, 0.15);
          getTargetBudget();
        }
        break;

      case ("Stage 4-1"):
        {
          setGrowthBudget(0.9, 0.05, 0.05);
          getGrowthBudget();
          setTargetBudget(0.75, 0.1, 0.15);
          getTargetBudget();
        }
        break;

      default:{}
    }
  }
}
