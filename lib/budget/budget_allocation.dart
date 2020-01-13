import 'dart:html';

import 'package:budgetflow/budget/budget_creator_interface.dart';

abstract class budgetIncomeandSavingsAllocation implements budgetCreator {

  void AllocateBudget() {
    switch (BudgetPlan) {
      case ("Stage 1-2"):{
        setDepletingBudget(0.6, 0.4);
        }
        break;

      case ("Stage 2-2"):{
        setDepletingBudget(0.75, 0.25);
        setDepletingTargetBudget(0.6, 0.4);
      }
      break;

      case ("Stage 3-2"):{
        setDepletingBudget(0.85, 0.15);
        setDepletingTargetBudget(0.75, 0.25);
      }
      break;

      case ("Stage 4-2"):{
        setDepletingBudget(0.95, 0.05);
        setDepletingTargetBudget(0.85, 0.15);
      }
      break;

      case("Stage 1-1"):{
      setBudget(0.5,0.2,0.3);
      }
      break;

      case("Stage 2-1"):{
      setBudget(0.65,0.2,0.15);
      setTargetBudget(0.5,0.2,0.3);
      }
      break;

      case("Stage 3-1"):{
      setBudget(0.75,0.1,0.15);
      setTargetBudget(0.65,0.2,0.15);
      }
     break;

      case ("Stage 4-1"):{
      setBudget(0.9, 0.05, 0.05);
      setTargetBudget(0.75,0.1,0.15);
      }
    break;

      default:{

      }
    }
  }
}