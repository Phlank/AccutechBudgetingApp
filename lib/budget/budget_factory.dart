
import 'package:budgetflow/budget/budget.dart';
import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/budget_creator_interface.dart';
import 'package:budgetflow/budget/budget_allocation.dart';
import 'package:budgetflow/budget/budget_type.dart';

abstract class budgetIncomeAndSavingsFactory implements budgetCreator, budgetIncomeandSavingsAllocation, Budget{
  Map<BudgetCategory, double> _allotedSpending, _actualSpending;
  double _expenditurePercentage;

  void startFactory(){
    if (budgetchoice ==  BudgetType.savingDepletion){
      setBudgetDepletionRatio();
    }
    else{
      budgetchoice = BudgetType.savingGrowth;
      setBudgetGrowthRatio();
    }
  }

  void categorizeBudget() {
    _expenditurePercentage = (_actualSpending[BudgetCategory.housing]) / income;
  }

  void setBudgetDepletionRatio() {
    categorizeBudget();

    if (_expenditurePercentage < 0 && _expenditurePercentage > .3) {
      BudgetPlan = "Stage 1-2";
      AllocateBudget();
    }

    else if (_expenditurePercentage < .3 && _expenditurePercentage > .5) {
      BudgetPlan = "Stage 2-2";
      AllocateBudget();
    }

    else if (_expenditurePercentage < .5 && _expenditurePercentage > .8) {
      BudgetPlan = "Stage 3-2";
      AllocateBudget();
    }

    else if (_expenditurePercentage < .8) {
      BudgetPlan = "Stage 4-2";
      AllocateBudget();
    }

    return;
  }

  void setBudgetGrowthRatio() {
    categorizeBudget();

    if (_expenditurePercentage < 0 && _expenditurePercentage > .3) {
      BudgetPlan = "Stage 1-1";
    }

    else if (_expenditurePercentage < .3 && _expenditurePercentage > .5) {
      BudgetPlan = "Stage 2-1";
    }

    else if (_expenditurePercentage < .5 && _expenditurePercentage > .8) {
      BudgetPlan = "Stage 3-1";
    }

    else if (_expenditurePercentage < .8) {
      BudgetPlan = "Stage 4-1";
    }

    return;
  }

  BudgetCategory setHousing(){

  }

  double setIncome(){
    this.income = budget.getMonthlyIncome();
  }

}