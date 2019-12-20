import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/budget_type.dart';

class budgetWriter {
  Map<BudgetCategory, double> _allotedSpending, _actualSpending;
  double _monthlyIncome;
  double _expenditurePercentage;
  double _needs;
  double _savings;
  double _wants;

  void categorizeBudget() {
    _expenditurePercentage = (_actualSpending[BudgetCategory.housing]) / _monthlyIncome;
  }

  void identifyBudgetType(){
    switch (BudgetType.savingGrowth) {

      case BudgetType.savingGrowth:
        setBudgetGrowthRatio(double);
        break;

      case BudgetType.savingDepletion:
        setBudgetDepletionRatio(double);
        break;
    }
  }

  void setBudgetGrowthRatio(double) {
      categorizeBudget();

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

  void setBudgetDepletionRatio(double) {
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

  void setBudget(double n, double s, double w){
    _needs = _monthlyIncome *n;
    _savings = _monthlyIncome *s;
    _wants = _monthlyIncome * w;
  }

  void setDepletingBudget(double n, double w){
    _needs = _monthlyIncome *n;
    _wants = _monthlyIncome *w;
  }

}