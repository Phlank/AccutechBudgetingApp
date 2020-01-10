import 'package:budgetflow/budget/budget_creator_interface.dart';
import 'package:budgetflow/budget/budget_income_and_savings_allocation.dart';
import 'package:budgetflow/budget/budget_income_and_savings_creator_factory.dart';

abstract class budgetIncomeAndSavingsUpdate implements budgetIncomeandSavingsAllocation, budgetIncomeAndSavingsFactory, budgetCreator{

  String fr;
  double UsedBudget;
  double UsedNeeds;
  double UsedWants;
  double NewWants;
  double NewNeeds;
  double NewBudgetSplit;
  double RemainingPercentage;
  double RemainingMoney;

  void checkProgress(){
    getRemainingExpenditure();
    checkForSwitch();
    getNewBudgetSplits();
  }

  void getRemainingExpenditure(){
    setRemainingBudget();
    if (remainingBudget >=0 ){
      UsedBudget = income - remainingBudget;
      UsedNeeds = UsedBudget * needs;
      UsedWants = UsedBudget * wants;

    }
    else{
      print(fr);
    }
    return;
  }

  void getNewBudgetSplits(){
    NewNeeds = UsedNeeds/income;
    NewWants = UsedWants/income;
    NewBudgetSplit = NewWants + NewNeeds + savings;
    RemainingPercentage = 1 - NewBudgetSplit;
    RemainingMoney = income * RemainingPercentage;
  }

  void checkForSwitch(){
    //TODO implement method to reset Budget Allocation after a certain threshold.
  }

  void bruh(){

  }

}