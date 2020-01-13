import 'package:budgetflow/budget/budget_creator_interface.dart';
import 'package:budgetflow/budget/budget_allocation.dart';
import 'package:budgetflow/budget/budget_factory.dart';

import 'budget_type.dart';

abstract class budgetIncomeAndSavingsUpdate implements budgetIncomeandSavingsAllocation, budgetIncomeAndSavingsFactory, budgetCreator {

  String fr;
  double UsedBudget;
  double UsedNeeds;
  double UsedWants;
  double UsedSavings;
  double NewWants;
  double NewNeeds;
  double NewSavings;
  double NewBudgetSplit;
  double RemainingPercentage;
  double RemainingMoney;

  void ProfileBudget() {
    if (budgetchoice == BudgetType.savingDepletion) {
    checkProgress();
    }

    else {
      budgetchoice = BudgetType.savingGrowth;

    }
  }

  void checkProgress() {
    getRemainingExpenditure();
    checkForSwitch();
    getNewBudgetSplits();
  }

  void getRemainingExpenditure() {
    setRemainingBudget();
    if (remainingBudget >= 0) {
      UsedBudget = income - remainingBudget;
      UsedNeeds = UsedBudget * needs;
      UsedWants = UsedBudget * wants;
    }
    else {
      print(fr);
    }
    return;
  }

  void getNewBudgetSplits() {
    NewNeeds = UsedNeeds / income;
    NewWants = UsedWants / income;
    NewBudgetSplit = NewWants + NewNeeds;
    RemainingPercentage = 1 - NewBudgetSplit;
    RemainingMoney = income * RemainingPercentage;
  }

  void checkForSwitch() {
    if (NewWants < wants && NewNeeds < needs){
      switch (BudgetPlan){

        case ("Stage 1-2"):{
          BudgetPlan = "Stage 1-2";
          AllocateBudget();
        }
        break;

        case ("Stage 2-2"):{
          BudgetPlan = "Stage 1-2";
          AllocateBudget();
        }
        break;

        case ("Stage 3-2"):{
          BudgetPlan = "Stage 2-2";
          AllocateBudget();
        }
        break;

        case ("Stage 4-2"):{
          BudgetPlan = "Stage 3-2";
          AllocateBudget();
        }
        break;

        case("Stage 1-1"):{
          BudgetPlan = "Stage 1-1";
          AllocateBudget();
        }
        break;

        case("Stage 2-1"):{
          BudgetPlan = "Stage 1-1";
          AllocateBudget();
        }
        break;

        case("Stage 3-1"):{
          BudgetPlan = "Stage 2-1";
          AllocateBudget();
        }
        break;

        case ("Stage 4-1"):{
          BudgetPlan = "Stage 3-1";
          AllocateBudget();
        }
        break;

        default:{

        }
      }


    }

      //TODO implement method to reset Budget Allocation after a certain threshold.
  }

    void bruh() {

    }

}