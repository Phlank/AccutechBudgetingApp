import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/budget_creator_interface.dart';
import 'package:budgetflow/budget/budget_income_only_allocation.dart';
import 'package:budgetflow/budget/budget_type.dart';


abstract class budgetIncomeOnlyFactory implements budgetCreator, budgetIncomeOnlyAllocation{
  Map<BudgetCategory, double> _allotedSpending, _actualSpending;
  double _expenditurePercentage;

  void startFactory(){
    if (budgetchoice ==  BudgetType.savingGrowth){
      setBudgetGrowthRatio(double);
    }
    else{
      budgetchoice = BudgetType.savingDepletion;
    }
  }

  void categorizeBudget() {
    _expenditurePercentage = (_actualSpending[BudgetCategory.housing]) / income;
  }

  void setBudgetGrowthRatio(Type double) {
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