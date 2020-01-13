import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/budget_type.dart';
import 'package:budgetflow/budget/budget.dart';

class BudgetCreator {
  //Map<BudgetCategory, double> _allotedSpending, _actualSpending;
  double income;
  double wants;
  double needs;
  double savings;
  double wantsAmount;
  double needsAmount;
  double savingsAmount;
  double targetNeeds;
  double targetWants;
  double targetSavings;
  double remainingNeeds;
  double remainingWants;
  double remainingBudget;
  int age;
  var BudgetPlan;
  BudgetType budgetchoice;
  Budget budget;

  double setIncome() {
    //setIncomingBudget();
    this.income = budget.getMonthlyIncome();
    return income;
  }

  int setAge(age) {
    this.age = age;
  }

  double setNeeds(needs) {
    this.needs = needs;
    this.needsAmount = income * needs;
  }

  double setWants(wants) {
    this.wants = wants;
    this.wantsAmount = income * wants;
  }

  double setSavings(savings) {
    this.savings = savings;
    this.savings = income * savings;
  }

  double setTargetNeeds(targetneeds) {
    this.targetNeeds = targetneeds;
  }

  double setTargetWants(targetwants) {
    this.targetWants = targetwants;
  }

  double setTargetSavings(targetsavings) {
    this.targetSavings = targetsavings;
  }

  double setRemainingWants(remainingwants) {
    this.remainingWants = remainingwants;
  }

  double setRemainingNeeds(remainingneeds) {
    this.remainingNeeds = remainingneeds;
  }

  double setRemainingBudget() {
    this.remainingBudget = remainingNeeds + remainingWants;
  }

  BudgetType setBudgetType(budgetchoice) {
    this.budgetchoice = budgetchoice;
  }

  double setDepletingBudget(double n, double w) {
    setNeeds(n);
    setWants(w);
  }

  double setDepletingTargetBudget(double n, double w) {
    setTargetNeeds(n);
    setTargetWants(w);
  }

  double setBudget(double n, double s, double w) {
    setNeeds(n);
    setSavings(s);
    setWants(w);
  }

  double setTargetBudget(double n, double s, double w) {
    setTargetNeeds(n);
    setTargetSavings(s);
    setTargetSavings(w);
  }

  void getBudgetPlan() {
    return BudgetPlan;
  }

  Budget setIncomingBudget(budget) {
    this.budget = budget;
  }

  Budget createBudget() {}
}
