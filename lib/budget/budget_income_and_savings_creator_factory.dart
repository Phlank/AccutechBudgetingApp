import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/budget_creator_interface.dart';
import 'package:budgetflow/budget/budget_type.dart';

abstract class budgetIncomeOnlyCreatorFactory implements budgetCreator {
  Map<BudgetCategory, double> _allotedSpending, _actualSpending;
  double _monthlyIncome;
  double _expenditurePercentage;

  void startFactory(){
    if (budgetchoice ==  BudgetType.savingDepletion){
      setBudgetDepletionRatio(double);
    }
    else{
      budgetchoice = BudgetType.savingGrowth;
    }
  }

  void categorizeBudget() {
    _monthlyIncome = income;
    _expenditurePercentage = (_actualSpending[BudgetCategory.housing]) / _monthlyIncome;
  }


  void setBudgetDepletionRatio(Type double) {
    categorizeBudget();

    if (_expenditurePercentage < .8) {
      setDepletingBudget(0.95, 0.5);
    }

    else if (_expenditurePercentage < 0 && _expenditurePercentage > .3) {
      setDepletingBudget(0.6, 0.4);
    }

    else if (_expenditurePercentage < .3 && _expenditurePercentage > .5) {
      setDepletingBudget(0.75, 0.25);
    }

    else if (_expenditurePercentage < .5 && _expenditurePercentage > .8) {
      setDepletingBudget(0.85, 0.15);
    }
    return;
  }


  void setDepletingBudget(double n, double w){
    needs = _monthlyIncome *n;
    wants = _monthlyIncome *w;
  }


}