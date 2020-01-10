import 'dart:collection';

import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/budget_creator_interface.dart';
import 'package:budgetflow/budget/budget_income_and_savings_allocation.dart';
import 'package:budgetflow/budget/budget_type.dart';

abstract class budgetIncomeAndSavingsFactory implements budgetCreator, budgetIncomeandSavingsAllocation {
  Map<BudgetCategory, double> _allotedSpending, _actualSpending;
  double _expenditurePercentage;
  var BudgetPlan;

  void startFactory(){
    if (budgetchoice ==  BudgetType.savingDepletion){
      setBudgetDepletionRatio();
    }
    else{
      budgetchoice = BudgetType.savingGrowth;
    }
  }

  void categorizeBudget() {
    _expenditurePercentage = (_actualSpending[BudgetCategory.housing]) / income;
  }


  void setBudgetDepletionRatio() {
    categorizeBudget();

    if (_expenditurePercentage < 0 && _expenditurePercentage > .3) {
      StageOneBudgetAllocation();
    }

    else if (_expenditurePercentage < .3 && _expenditurePercentage > .5) {
      StageTwoBudgetAllocation();
    }

    else if (_expenditurePercentage < .5 && _expenditurePercentage > .8) {
      StageThreeBudgetAllocation();
    }

    else if (_expenditurePercentage < .8) {
      StageFourBudgetAllocation();
    }

    return;
  }

}