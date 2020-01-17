import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/budget_factory.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/budget_type.dart';

class _SWN {
  double needs, savings, wants;

  _SWN(double needs, savings, wants) {
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
  static final _stage1Depletion = new _SWN(.6, .0, .4);
  static final _stage2Depletion = new _SWN(.75, .0, .25);
  static final _stage3Depletion = new _SWN(.9, .0, .1);
  static final _stage4Depletion = new _SWN(.95, .0, .05);
  static final _stage1Growth = new _SWN(.5, .2, .3);
  static final _stage2Growth = new _SWN(.65, .2, .15);
  static final _stage3Growth = new _SWN(.85, .05, .1);
  static final _stage4Growth = new _SWN(.94, .01, .05);
  static const _STAGE_1_BOUND = .3;
  static const _STAGE_2_BOUND = .5;
  static const _STAGE_3_BOUND = .8;
  static const _STAGE_4_BOUND = 1.0;

  double _housingRatio, _income, _underspending, _overspending;
  _SWN _currentDistribution, _targetDistribution;
  double _wantsRatio, _needsRatio, _savingsRatio;
  BudgetMap _oldAllotmentRatios,
    _oldActualRatios,
    _spendingDiffs,
    _newAllotmentRatios;

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
      _currentDistribution = _stage1Depletion;
      _targetDistribution = _stage1Depletion;
    } else if (_housingRatio <= _STAGE_2_BOUND) {
      _currentDistribution = _stage2Depletion;
      _targetDistribution = _stage1Depletion;
    } else if (_housingRatio <= _STAGE_3_BOUND) {
      _currentDistribution = _stage3Depletion;
      _targetDistribution = _stage2Depletion;
    } else if (_housingRatio <= _STAGE_4_BOUND) {
      _currentDistribution = _stage4Depletion;
      _targetDistribution = _stage3Depletion;
    }
  }

  void _setBudgetGrowthRatios() {
    if (_housingRatio <= _STAGE_1_BOUND) {
      _currentDistribution = _stage1Growth;
      _targetDistribution = _stage1Growth;
    } else if (_housingRatio <= _STAGE_2_BOUND) {
      _currentDistribution = _stage2Growth;
      _targetDistribution = _stage1Growth;
    } else if (_housingRatio <= _STAGE_3_BOUND) {
      _currentDistribution = _stage3Growth;
      _targetDistribution = _stage2Growth;
    } else if (_housingRatio <= _STAGE_4_BOUND) {
      _currentDistribution = _stage4Growth;
      _targetDistribution = _stage3Growth;
    }
  }

  void _updateWantsAndNeeds() {
    _currentDistribution.multiply(_income);
    _targetDistribution.multiply(_income);
  }

  Budget _createAllotments(Budget budget) {
    _needsRatio -= _housingRatio;
    double dNeedsRatio = _income * _needsRatio / 4.0;
    double dWantsRatio = _income * _wantsRatio / 5.0;
    budget.setAllotment(BudgetCategory.utilities, dNeedsRatio);
    budget.setAllotment(BudgetCategory.groceries, dNeedsRatio);
    budget.setAllotment(BudgetCategory.health, dNeedsRatio);
    budget.setAllotment(BudgetCategory.transportation, dNeedsRatio);
    budget.setAllotment(BudgetCategory.education, dWantsRatio);
    budget.setAllotment(BudgetCategory.entertainment, dWantsRatio);
    budget.setAllotment(BudgetCategory.kids, dWantsRatio);
    budget.setAllotment(BudgetCategory.pets, dWantsRatio);
    budget.setAllotment(BudgetCategory.miscellaneous, dWantsRatio);
    budget.setAllotment(BudgetCategory.savings, _income * _savingsRatio);
    return budget;
  }

  @override
  Budget newFromBudget(Budget old) {
    _income = old.getMonthlyIncome();
    Budget newBudget = new Budget(_income);
    _oldAllotmentRatios = old.allottedSpending.divide(_income);
    _oldActualRatios = old.actualSpending.divide(_income);
    if (_userExceededBudget()) {
      // Return the same budget as last month
      return Budget.fromOldAllottments(old);
    }
    // Look at spending, see what fields were over and what were under
    _findSpendingDiffs();
    _reallocate();
    newBudget = _setAllotments(newBudget);
    return newBudget;
  }

  bool _userExceededBudget() {
    double total;
    _oldActualRatios.forEach((BudgetCategory c, double d) {
      total += d;
    });
    return total > _income;
  }

  void _findSpendingDiffs() {
    _spendingDiffs = new BudgetMap();
    _oldAllotmentRatios.forEach((BudgetCategory c, double d) {
      double allotted = d;
      double spent = _oldActualRatios.valueOf(c);
      if (_oldActualRatios.valueOf(c) != d) {
        _spendingDiffs.set(c, spent - allotted);
      }
    });
  }

  void _reallocate() {
    _newAllotmentRatios = new BudgetMap();
    _spendingDiffs.forEach((BudgetCategory c, double d) {
      if (c != BudgetCategory.savings) {
        if (d < 0.0) _underspending += d;
        if (d > 0.0) _overspending += d;
      }
    });
    _spendingDiffs.forEach((BudgetCategory c, double d) {
      if (c != BudgetCategory.savings) {
        _reallocateCategory(c, d);
      }
    });
    double leftover = -_underspending;
    _newAllotmentRatios[BudgetCategory.savings] =
      _oldAllotmentRatios[BudgetCategory.savings] + leftover;
  }

  void _reallocateCategory(BudgetCategory c, double d) {
    if (d < 0.0) {
      _newAllotmentRatios.set(
        c, _oldAllotmentRatios.valueOf(c) + d / _overspending);
      _underspending -= d / _overspending;
    }
    if (d >= 0.0) {
      _newAllotmentRatios.set(c, _oldActualRatios.valueOf(c));
    }
  }

  Budget _setAllotments(Budget b) {
    for (BudgetCategory c in BudgetCategory.values) {
      b.setAllotment(c, _newAllotmentRatios[c] * _income);
    }
    return b;
  }
}
