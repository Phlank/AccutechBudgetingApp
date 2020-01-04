import 'package:budgetflow/budget/budget_creator_interface.dart';

abstract class budgetIncomeandSavingsAllocation implements budgetCreator{

  void StageOneBudgetAllocation(){
    setDepletingBudget(0.6, 0.4);
  }

  void StageTwoBudgetAllocation(){
    setDepletingBudget(0.75, 0.25);
    setDepletingTargetBudget(0.6, 0.4);
  }

  void StageThreeBudgetAllocation(){
    setDepletingBudget(0.85, 0.15);
    setDepletingTargetBudget(0.75, 0.25);
  }

  void StageFourBudgetAllocation(){
    setDepletingBudget(0.95, 0.05);
    setDepletingTargetBudget(0.85, 0.15);
  }

}