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

  int getAge(){
    return age;
  }

  double setNeeds(needs) {
    this.needs = needs;
    this.needsAmount = income * needs;
  }

  double getNeeds(){
    return wants;
  }
  double getNeedsAmount(){
    return wantsAmount;
  }

  double setWants(Wants) {
    this.wants = Wants;
    this.wantsAmount = income * Wants;
  }

  double getWants(){
    return wants;
  }

  double getWantsAmount(){
    return wantsAmount;
  }

  double setSavings(savings) {
    this.savings = savings;
    this.savingsAmount = income * savings;
  }
  double getSavings() {
    return savings;
  }

  double getSavingsAmount(){
    return savingsAmount;
  }

  double setTargetNeeds(targetneeds) {
    this.targetNeeds = targetneeds;
  }

  double getTargetNeeds() {
    return targetNeeds;
  }

  double setTargetWants(targetwants) {
    this.targetWants = targetwants;
  }

  double getTargetWants() {
    return targetWants;
  }

  double setTargetSavings(targetsavings) {
    this.targetSavings = targetsavings;
  }

  double getTargetSavings() {
    return targetSavings;
  }


  double setRemainingWants(remainingwants) {
    this.remainingWants = remainingwants;
  }

  double getRemainingWants() {
    return remainingWants;
  }

  double setRemainingNeeds(remainingneeds) {
    this.remainingNeeds = remainingneeds;
  }

  double getRemainingNeeds(remainingneeds) {
    return remainingNeeds;
  }

  double setRemainingBudget() {
    this.remainingBudget = remainingNeeds + remainingWants;
  }

  double getRemainingBudget() {
    return remainingBudget;
  }
  BudgetType setBudgetType(budgetChoice) {
    this.budgetchoice = budgetChoice;
  }

  BudgetType getBudgetType(budgetChoice) {
    return budgetchoice;
  }

  double setDepletingBudget(double n, double w) {
    setNeeds(n);
    setWants(w);
  }

  double getDepletingBudget(double n, double w) {
    return setDepletingBudget(n, w);
  }

  double setDepletingTargetBudget(double n, double w) {
    setTargetNeeds(n);
    setTargetWants(w);
  }

  double getDepletingTargetBudget(double n, double w) {
    return setDepletingTargetBudget(n, w);
  }

  double setGrowthBudget(double n, double s, double w) {
    setNeeds(n);
    setSavings(s);
    setWants(w);
  }

  double getGrowthBudget(double n, double s, double w) {
    return setGrowthBudget(n, s, w);
  }

  double setTargetBudget(double n, double s, double w) {
    setTargetNeeds(n);
    setTargetSavings(s);
    setTargetSavings(w);
  }

  double getTargetBudget(double n, double s, double w) {
    return setTargetBudget(n, s, w);
  }

  void getBudgetPlan() {
    return BudgetPlan;
  }

  Budget setIncomingBudget(budget) {
    this.budget = budget;
  }

  Budget getIncomingBudget() {
    return budget;
  }

  Budget createBudget() {}
}
