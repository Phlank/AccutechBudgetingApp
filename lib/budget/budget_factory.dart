import 'package:budgetflow/budget/budget.dart';
import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/budget_creator_interface.dart';
import 'package:budgetflow/budget/budget_allocation.dart';
import 'package:budgetflow/budget/budget_type.dart';

abstract class BudgetFactory
    implements BudgetCreator, BudgetAllocation {
  Map<BudgetCategory, double> _allotedSpending, _actualSpending;
  double _expenditurePercentage;
  double _housing;

  Budget getBudget(){
    startFactory();
  }

  void startFactory() {
    if (budgetchoice == BudgetType.savingDepletion) {
      setBudgetDepletionRatio();
    } else {
      budgetchoice = BudgetType.savingGrowth;
      setBudgetGrowthRatio();
    }
  }

  void categorizeBudget() {
    setIncome();
    setHousing();
    _expenditurePercentage = (_actualSpending[BudgetCategory.housing]) / income;
  }

  void setBudgetDepletionRatio() {
    categorizeBudget();

    if (_expenditurePercentage < 0 && _expenditurePercentage > .3) {
      BudgetPlan = "Stage 1-2";
      AllocateBudget();
    } else if (_expenditurePercentage < .3 && _expenditurePercentage > .5) {
      BudgetPlan = "Stage 2-2";
      AllocateBudget();
    } else if (_expenditurePercentage < .5 && _expenditurePercentage > .8) {
      BudgetPlan = "Stage 3-2";
      AllocateBudget();
    } else if (_expenditurePercentage < .8) {
      BudgetPlan = "Stage 4-2";
      AllocateBudget();
    }

    return;
  }

  void setBudgetGrowthRatio() {
    categorizeBudget();

    if (_expenditurePercentage < 0 && _expenditurePercentage > .3) {
      BudgetPlan = "Stage 1-1";
      AllocateBudget();
    } else if (_expenditurePercentage < .3 && _expenditurePercentage > .5) {
      BudgetPlan = "Stage 2-1";
      AllocateBudget();
    } else if (_expenditurePercentage < .5 && _expenditurePercentage > .8) {
      BudgetPlan = "Stage 3-1";
      AllocateBudget();
    } else if (_expenditurePercentage < .8) {
      BudgetPlan = "Stage 4-1";
      AllocateBudget();
    }

    return;
  }

  double setHousing() {
    this._housing = (_actualSpending[BudgetCategory.housing]).toDouble();
  }

  double getHousing() {
    return _housing;
  }

  double setIncome() {
    this.income = budget.getMonthlyIncome();
  }

  double getIncome() {
    return income;
  }


}
