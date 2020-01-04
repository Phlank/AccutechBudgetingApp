import 'package:budgetflow/budget/budget_creator_interface.dart';

abstract class budgetIncomeOnlyAllocation implements budgetCreator{

  void StageOneBudgetAllocation(){
    setBudget(0.5,0.2,0.3);
  }

  void StageTwoBudgetAllocation(){
    setBudget(0.65,0.2,0.15);
    setTargetBudget(0.5,0.2,0.3);
  }

  void StageThreeBudgetAllocation(){
    setBudget(0.75,0.1,0.15);
    setTargetBudget(0.65,0.2,0.15);
  }

  void StageFourBudgetAllocation(){
    setBudget(0.9, 0.05, 0.05);
    setTargetBudget(0.75,0.1,0.15);
  }

}