import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/budget_income_and_savings_creator_factory.dart';
import 'package:budgetflow/budget/budget_type.dart';

import 'budget.dart';

class budgetCreator {
  Map<BudgetCategory, double> _allotedSpending, _actualSpending;
  double income;
  double wants;
  double needs;
  double savings;
  int age;
  BudgetType budgetchoice;

  void setIncome(income){
    this.income = income;
  }

  void setAge(age){
    this.age = age;
  }

  void setNeeds(needs){
    this.needs = needs;
  }

  void setWants(wants) {
    this.wants = wants;
  }

  void setSavings(savings){
    this.savings = savings;
  }

  void setBudgetType(budgetchoice){
    this.budgetchoice = budgetchoice;
  }

    Budget createBudget() {

  }



}