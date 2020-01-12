import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/budget_type.dart';

import 'budget.dart';

class budgetCreator {
  Map<BudgetCategory, double> _allotedSpending, _actualSpending;
  double income;
  double wants;
  double needs;
  double savings;
  double targetNeeds;
  double targetWants;
  double targetSavings;
  int age;
  BudgetType budgetchoice;

  void setIncome(income){
    this.income = income;
  }

  void setAge(age){
    this.age = age;
  }

  void setNeeds(needs){
    this.needs = income * needs;
  }

  void setWants(wants) {
    this.wants = income * wants;
  }

  void setSavings(savings){
    this.savings = income * savings;
  }

  void setTargetNeeds(targetneeds){
    this.targetNeeds = targetneeds;
  }

  void setTargetWants(targetwants){
    this.targetWants = targetwants;
  }

  void setTargetSavings(targetsavings){
    this.targetSavings = targetsavings;
  }

  void setBudgetType(budgetchoice){
    this.budgetchoice = budgetchoice;
  }

  void setDepletingBudget(double n, double w){
    setNeeds(n);
    setWants(w);
  }

  void setDepletingTargetBudget(double n, double w){
    setTargetNeeds(n);
    setTargetWants(w);
  }
  void setBudget(double n, double s, double w){
    setNeeds(n);
    setSavings(s);
    setWants(w);
  }

  void setTargetBudget(double n, double s, double w){
    setTargetNeeds(n);
    setTargetSavings(s);
    setTargetSavings(w);
  }

    Budget createBudget() {

  }



}