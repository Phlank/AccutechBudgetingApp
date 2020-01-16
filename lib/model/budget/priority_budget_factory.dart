import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/budget_factory.dart';
import 'package:budgetflow/model/budget/budget_type.dart';

class _Trio {
  double needs, savings, wants;

  _Trio(double needs, savings, wants) {
    this.needs = needs;
    this.savings = savings;
    this.wants = wants;
  }

  void multiply(double n) {
    needs *= n;
    savings *= n;
    wants *= n;
  }

  void divide(double n) {
    if (n == 0) return;
    needs /= n;
    savings /= n;
    wants /= n;
  }
}

class PriorityBudgetFactory implements BudgetFactory {
  static final _STAGE_1_DEPLETION = new _Trio(.6, .0, .4);
  static final _STAGE_2_DEPLETION = new _Trio(.75, .0, .25);
  static final _STAGE_3_DEPLETION = new _Trio(.9, .0, .1);
  static final _STAGE_4_DEPLETION = new _Trio(.95, .0, .05);
  static final _STAGE_1_GROWTH = new _Trio(.5, .2, .3);
  static final _STAGE_2_GROWTH = new _Trio(.65, .2, .15);
  static final _STAGE_3_GROWTH = new _Trio(.85, .05, .1);
  static final _STAGE_4_GROWTH = new _Trio(.94, .01, .05);
  static const _STAGE_1_BOUND = .3;
  static const _STAGE_2_BOUND = .5;
  static const _STAGE_3_BOUND = .8;
  static const _STAGE_4_BOUND = 1.0;

  double _housingRatio;
  String _budgetPlan;

  double _income;
  _Trio _currentDistribution;
  _Trio _targetDistribution;
  double wantsRatio;
  double needsRatio;
  double savingsRatio;
  double wantsAmount;
  double needsAmount;
  double savingsAmount;
  double targetWantsAmount;
  double targetNeedsAmount;
  double targetNeedsRatio;
  double targetWantsRatio;
  double targetSavingsRatio;
  double remainingNeedsRatio;
  double remainingWantsRatio;
  double remainingBudgetRatio;

  double usedBudget;
  double usedNeeds;
  double usedWants;
  double UsedSavings;
  double newWants;
  double newNeeds;
  double NewSavings;
  double NewBudgetSplit;
  double RemainingPercentage;
  double RemainingMoney;

  PriorityBudgetFactory() {}

  @override
  Budget newFromInfo(double income, double housing, BudgetType type) {
    _housingRatio = housing / income;
    income = income;
    _decidePlan(type);
    Budget newBudget = new Budget(income);
    newBudget.setType(type);
    newBudget.setAllotment(BudgetCategory.housing, housing);
    _updateWantsAndNeeds();
    newBudget = _createAllotments(newBudget);
    return newBudget;
  }

  void _decidePlan(BudgetType type) {
    switch (type) {
      case BudgetType.savingDepletion:
        _setBudgetDepletionRatios();
        break;
      case BudgetType.savingGrowth:
        _setBudgetGrowthRatios();
        break;
    }
  }

  void _setBudgetDepletionRatios() {
    if (_housingRatio <= _STAGE_1_BOUND) {
      _currentDistribution = _STAGE_1_DEPLETION;
      _targetDistribution = _STAGE_1_DEPLETION;
    } else if (_housingRatio <= _STAGE_2_BOUND) {
      _currentDistribution = _STAGE_2_DEPLETION;
      _targetDistribution = _STAGE_1_DEPLETION;
    } else if (_housingRatio <= _STAGE_3_BOUND) {
      _currentDistribution = _STAGE_3_DEPLETION;
      _targetDistribution = _STAGE_2_DEPLETION;
    } else if (_housingRatio <= _STAGE_4_BOUND) {
      _currentDistribution = _STAGE_4_DEPLETION;
      _targetDistribution = _STAGE_3_DEPLETION;
    }
  }

  void _setBudgetGrowthRatios() {
    if (_housingRatio <= _STAGE_1_BOUND) {
      _currentDistribution = _STAGE_1_GROWTH;
      _targetDistribution = _STAGE_1_GROWTH;
    } else if (_housingRatio <= _STAGE_2_BOUND) {
      _currentDistribution = _STAGE_2_GROWTH;
      _targetDistribution = _STAGE_1_GROWTH;
    } else if (_housingRatio <= _STAGE_3_BOUND) {
      _currentDistribution = _STAGE_3_GROWTH;
      _targetDistribution = _STAGE_2_GROWTH;
    } else if (_housingRatio <= _STAGE_4_BOUND) {
      _currentDistribution = _STAGE_4_GROWTH;
      _targetDistribution = _STAGE_3_GROWTH;
    }
  }

  double setDepletingTargetBudget(double needs, double wants) {
    targetNeedsRatio = needs;
    targetWantsRatio = wants;
  }

  void setGrowthBudget(double needs, double savings, double wants) {
    needsRatio = needs;
    savingsRatio = savings;
    wantsRatio = wants;
  }

  double setTargetBudget(double needs, double savings, double wants) {
    targetNeedsRatio = needs;
    targetSavingsRatio = savings;
    targetWantsRatio = wants;
  }

  void _updateWantsAndNeeds() {
    _currentDistribution.multiply(_income);
    _targetDistribution.multiply(_income);
  }

  Budget _createAllotments(Budget budget) {
    needsRatio -= _housingRatio;
    double dNeedsRatio = _income * needsRatio / 4.0;
    double dWantsRatio = _income * wantsRatio / 5.0;
    budget.setAllotment(BudgetCategory.utilities, dNeedsRatio);
    budget.setAllotment(BudgetCategory.groceries, dNeedsRatio);
    budget.setAllotment(BudgetCategory.health, dNeedsRatio);
    budget.setAllotment(BudgetCategory.transportation, dNeedsRatio);
    budget.setAllotment(BudgetCategory.education, dWantsRatio);
    budget.setAllotment(BudgetCategory.entertainment, dWantsRatio);
    budget.setAllotment(BudgetCategory.kids, dWantsRatio);
    budget.setAllotment(BudgetCategory.pets, dWantsRatio);
    budget.setAllotment(BudgetCategory.miscellaneous, dWantsRatio);
    budget.setAllotment(BudgetCategory.savings, _income * savingsRatio);
    return budget;
  }

  double setNeeds(needs) {
    this.needsRatio = needs;
    this.needsAmount = _income * needs;
  }

  double setWants(Wants) {
    this.wantsRatio = Wants;
    this.wantsAmount = _income * Wants;
  }

  double setRemainingBudget() {
    this.remainingBudgetRatio = remainingNeedsRatio + remainingWantsRatio;
  }

  @override
  Budget newFromBudget(Budget old) {
    _income = old.getMonthlyIncome();
    double remaining = calculateRemainingAllottment(old);
    _housingRatio = old.getAllotment(BudgetCategory.housing) / _income;
    double spent = _income - remaining;
    usedWants = spent * old.wantsRatio;
    usedNeeds = spent * old.needsRatio;
    if (spent > 0.0) {
      // They can't get their own budget working for them, need more time
      Budget newBudget = Budget.fromOldAllottments(old);
      return newBudget;
    }
    newWants = usedWants / _income;
    newNeeds = usedNeeds / _income;
    double remainingMoney = _income * (1 - newWants + newNeeds);
    checkForSwitch();
    Budget newBudget = new Budget(_income);
    _allocateBudget(_budgetPlan);
    newBudget = _createAllotments(newBudget);
    return newBudget;
  }

  void _allocateBudget(String s) {
    switch (s) {
      case ("Stage 1-2"):
        setDepletingBudget(0.6, 0.4);
        setDepletingTargetBudget(0.6, 0.4);
        break;
      case ("Stage 2-2"):
        setDepletingBudget(0.75, 0.25);
        setDepletingTargetBudget(0.6, 0.4);
        break;
      case ("Stage 3-2"):
        setDepletingBudget(0.85, 0.15);
        setDepletingTargetBudget(0.75, 0.25);
        break;
      case ("Stage 4-2"):
        setDepletingBudget(0.95, 0.05);
        setDepletingTargetBudget(0.85, 0.15);
        break;
      case ("Stage 1-1"):
        setGrowthBudget(0.5, 0.2, 0.3);
        setTargetBudget(0.5, 0.2, 0.3);
        break;
      case ("Stage 2-1"):
        setGrowthBudget(0.65, 0.2, 0.15);
        setTargetBudget(0.5, 0.2, 0.3);
        break;
      case ("Stage 3-1"):
        setGrowthBudget(0.75, 0.1, 0.15);
        setTargetBudget(0.65, 0.2, 0.15);
        break;
      case ("Stage 4-1"):
        setGrowthBudget(0.9, 0.05, 0.05);
        setTargetBudget(0.75, 0.1, 0.15);
        break;
      default:
        break;
    }
  }

  double calculateRemainingAllottment(Budget old) {
    double remainingNeeds = old.getAllotment(BudgetCategory.utilities) +
        old.getAllotment(BudgetCategory.groceries) +
        old.getAllotment(BudgetCategory.health) +
        old.getAllotment(BudgetCategory.transportation) -
        old.getSpending(BudgetCategory.utilities) +
        old.getSpending(BudgetCategory.groceries) +
        old.getSpending(BudgetCategory.health) +
        old.getSpending(BudgetCategory.transportation);
    double remainingWants = old.getAllotment(BudgetCategory.education) +
        old.getAllotment(BudgetCategory.entertainment) +
        old.getAllotment(BudgetCategory.kids) +
        old.getAllotment(BudgetCategory.pets) +
        old.getAllotment(BudgetCategory.miscellaneous) -
        old.getSpending(BudgetCategory.education) -
        old.getSpending(BudgetCategory.entertainment) -
        old.getSpending(BudgetCategory.kids) -
        old.getSpending(BudgetCategory.pets) -
        old.getSpending(BudgetCategory.miscellaneous);
    usedWants = remainingWants;
    usedNeeds = remainingNeeds;
    return remainingNeeds + remainingWants;
  }

  void checkForSwitch() {
    if (newWants < wantsRatio && newNeeds < needsRatio) {
      switch (_budgetPlan) {
        case ("Stage 1-2"):
          _budgetPlan = "Stage 1-2";
          _allocateBudget(_budgetPlan);
          break;
        case ("Stage 2-2"):
          _budgetPlan = "Stage 1-2";
          _allocateBudget(_budgetPlan);
          break;
        case ("Stage 3-2"):
          _budgetPlan = "Stage 2-2";
          _allocateBudget(_budgetPlan);
          break;
        case ("Stage 4-2"):
          _budgetPlan = "Stage 3-2";
          _allocateBudget(_budgetPlan);
          break;
        case ("Stage 1-1"):
          _budgetPlan = "Stage 1-1";
          _allocateBudget(_budgetPlan);
          break;
        case ("Stage 2-1"):
          _budgetPlan = "Stage 1-1";
          _allocateBudget(_budgetPlan);
          break;
        case ("Stage 3-1"):
          _budgetPlan = "Stage 2-1";
          _allocateBudget(_budgetPlan);
          break;
        case ("Stage 4-1"):
          _budgetPlan = "Stage 3-1";
          _allocateBudget(_budgetPlan);
          break;
        default:
          break;
      }
    }
  }

  void bruh() {}
}
