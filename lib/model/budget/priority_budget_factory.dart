import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/budget_factory.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/budget_type.dart';

class _NSW {
  double needs, savings, wants;

  _NSW(double needs, savings, wants) {
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
  static _NSW _stage1Depletion = new _NSW(.6, .0, .4);
  static _NSW _stage2Depletion = new _NSW(.75, .0, .25);
  static _NSW _stage3Depletion = new _NSW(.9, .0, .1);
  static _NSW _stage4Depletion = new _NSW(.95, .0, .05);
  static _NSW _stage1Growth = new _NSW(.5, .2, .3);
  static _NSW _stage2Growth = new _NSW(.65, .2, .15);
  static _NSW _stage3Growth = new _NSW(.85, .05, .1);
  static _NSW _stage4Growth = new _NSW(.94, .01, .05);
  static const _STAGE_1_BOUND = .3;
  static const _STAGE_2_BOUND = .5;
  static const _STAGE_3_BOUND = .8;
  static const _STAGE_4_BOUND = 1.0;

  double _housingRatio = 0.0, _income = 0.0, _underspending = 0.0, _overspending = 0.0;
  _NSW _currentDistribution, _targetDistribution;
  double _wantsRatio, _needsRatio, _savingsRatio;
  BudgetMap _oldAllotmentRatios = new BudgetMap(),
      _oldActualRatios = new BudgetMap(),
      _spendingDiffs = new BudgetMap(),
      _newAllotmentRatios = new BudgetMap(),
      _allottedSpending = new BudgetMap();
  BudgetBuilder _builder = new BudgetBuilder();

  PriorityBudgetFactory();

  @override
  Budget newFromInfo(double income, double housing, BudgetType type) {
    _currentDistribution = new _NSW(0.0, 0.0, 0.0);
    _targetDistribution = new _NSW(0.0, 0.0, 0.0);
    _housingRatio = housing / income;
    _income = income;
    _decidePlan(type);
    _currentDistribution.multiply(_income);
    _targetDistribution.multiply(_income);
    _setAllotments(housing);
    return _builder.build();
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

  void _setAllotments(double housing) {
    _allottedSpending[BudgetCategory.housing] = housing;
    _needsRatio = _currentDistribution.needs - _housingRatio;
    _wantsRatio = _currentDistribution.wants;
    _savingsRatio = _currentDistribution.savings;
    double dNeedsRatio = _income * _needsRatio / 4.0;
    double dWantsRatio = _income * _wantsRatio / 5.0;
    _allottedSpending[BudgetCategory.utilities] = dNeedsRatio;
    _allottedSpending[BudgetCategory.groceries] = dNeedsRatio;
    _allottedSpending[BudgetCategory.health] = dNeedsRatio;
    _allottedSpending[BudgetCategory.transportation] = dNeedsRatio;
    _allottedSpending[BudgetCategory.education] = dWantsRatio;
    _allottedSpending[BudgetCategory.entertainment] = dWantsRatio;
    _allottedSpending[BudgetCategory.kids] = dWantsRatio;
    _allottedSpending[BudgetCategory.pets] = dWantsRatio;
    _allottedSpending[BudgetCategory.miscellaneous] = dWantsRatio;
    _allottedSpending[BudgetCategory.savings] = _savingsRatio * _income;
  }

  @override
  Budget newFromBudget(Budget old) {
    _income = old.getMonthlyIncome();
    _oldAllotmentRatios = old.allottedSpending.divide(_income);
    _oldActualRatios = old.actualSpending.divide(_income);
    if (_userExceededBudget()) {
      // Return the same budget as last month
      return Budget.fromOldBudget(old);
    }
    // Look at spending, see what fields were over and what were under
    _findSpendingDiffs();
    // Reorganize funds between over and under fields, put the rest into savings
    _reallocate();
    _setAllotmentsForNextMonth();
    _builder.setType(old.type);
    _builder.setIncome(old.income);
    _builder.setAllottedSpending(_allottedSpending);
    return _builder.build();
  }

  bool _userExceededBudget() {
    double total = 0.0;
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

  void _setAllotmentsForNextMonth() {
    for (BudgetCategory c in BudgetCategory.values) {
      _allottedSpending[c] = _newAllotmentRatios[c] * _income;
    }
  }
}
