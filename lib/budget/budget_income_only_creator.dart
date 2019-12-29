import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/budget_creator_interface.dart';
import 'package:budgetflow/budget/budget_type.dart';


abstract class budgetIncomeCreator implements budgetCreator{
  Map<BudgetCategory, double> _allotedSpending, _actualSpending;
  double _monthlyIncome;
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
    _monthlyIncome = income;
    _expenditurePercentage = (_actualSpending[BudgetCategory.housing]) / _monthlyIncome;
  }

  void setBudgetGrowthRatio(Type double) {

    if (_expenditurePercentage < .8) {
      setBudget(0.9, 0.05, 0.05);
    }

    else if (_expenditurePercentage < 0 && _expenditurePercentage > .3) {
      setBudget(0.5,0.2,0.3);
    }

    else if (_expenditurePercentage < .3 && _expenditurePercentage > .5) {
      setBudget(0.65,0.2,0.15);
    }

    else if (_expenditurePercentage < .5 && _expenditurePercentage > .8) {
      setBudget(0.75,0.1,0.15);
    }
    return;
  }

  void setBudget(double n, double s, double w){
    needs = _monthlyIncome *n;
    savings = _monthlyIncome *s;
    wants = _monthlyIncome * w;
  }


}