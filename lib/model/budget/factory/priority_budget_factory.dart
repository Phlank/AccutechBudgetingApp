import 'package:budgetflow/model/abstract/budget_factory.dart';
import 'package:budgetflow/model/data_types/allocation.dart';
import 'package:budgetflow/model/data_types/allocation_list.dart';
import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/data_types/budget_type.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/data_types/transaction_list.dart';

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
  static const _stage1Bound = .3;
  static const _stage2Bound = .5;
  static const _stage3Bound = .8;
  static const _stage4Bound = 1.0;

  double _housingRatio = 0.0,
      _income = 0.0,
      _underspending = 0.0,
      _overspending = 0.0;
  _NSW _currentDistribution, _targetDistribution;
  double _wantsRatio, _needsRatio, _savingsRatio;
  Budget _oldBudget;
  AllocationList _oldAllotmentRatios = AllocationList(),
      _oldActualRatios = AllocationList(),
      _spendingDiffs = AllocationList(),
      _newAllotmentRatios = AllocationList(),
      _allottedSpending = AllocationList.defaultCategories(),
      _targetSpending = AllocationList(),
      _deltas = AllocationList();

  PriorityBudgetFactory();

  @override
  Budget newFromInfo(double income, double housing, bool depletion,
      double savingsPull, bool kids, bool pets) {
    var type;
    if (depletion)
      type = BudgetType.depletion;
    else
      type = BudgetType.growth;
    _currentDistribution = new _NSW(0.0, 0.0, 0.0);
    _targetDistribution = new _NSW(0.0, 0.0, 0.0);
    _housingRatio = housing / income;
    _income = income;
    _decidePlan(type);
    _setAllotments(housing);
    return Budget(
      expectedIncome: income,
      type: type,
      target: _allottedSpending,
      allotted: _allottedSpending,
    );
  }

  void _decidePlan(BudgetType type) {
    switch (type) {
      case BudgetType.depletion:
        _setBudgetDepletionRatios();
        break;
      case BudgetType.growth:
        _setBudgetGrowthRatios();
        break;
    }
  }

  void _setBudgetDepletionRatios() {
    if (_housingRatio <= _stage1Bound) {
      _currentDistribution = _stage1Depletion;
      _targetDistribution = _stage1Depletion;
    } else if (_housingRatio <= _stage2Bound) {
      _currentDistribution = _stage2Depletion;
      _targetDistribution = _stage1Depletion;
    } else if (_housingRatio <= _stage3Bound) {
      _currentDistribution = _stage3Depletion;
      _targetDistribution = _stage2Depletion;
    } else if (_housingRatio <= _stage4Bound) {
      _currentDistribution = _stage4Depletion;
      _targetDistribution = _stage3Depletion;
    }
  }

  void _setBudgetGrowthRatios() {
    if (_housingRatio <= _stage1Bound) {
      _currentDistribution = _stage1Growth;
      _targetDistribution = _stage1Growth;
    } else if (_housingRatio <= _stage2Bound) {
      _currentDistribution = _stage2Growth;
      _targetDistribution = _stage1Growth;
    } else if (_housingRatio <= _stage3Bound) {
      _currentDistribution = _stage3Growth;
      _targetDistribution = _stage2Growth;
    } else if (_housingRatio <= _stage4Bound) {
      _currentDistribution = _stage4Growth;
      _targetDistribution = _stage3Growth;
    }
  }

  void _setAllotments(double housing) {
    // Allocate housing before anything else
    _allottedSpending.getCategory(Category.housing).value = housing;
    // Get number of categories in needs and wants
    // TODO finish
    _needsRatio = _currentDistribution.needs - _housingRatio;
    _wantsRatio = _currentDistribution.wants;
    _savingsRatio = _currentDistribution.savings;
    double dNeedsRatio = _income * _needsRatio / 4.0;
    double dWantsRatio = _income * _wantsRatio / 5.0;
    _allottedSpending.getCategory(Category.utilities).value = dNeedsRatio;
    _allottedSpending.getCategory(Category.groceries).value = dNeedsRatio;
    _allottedSpending.getCategory(Category.health).value = dNeedsRatio;
    _allottedSpending.getCategory(Category.transportation).value = dNeedsRatio;
    _allottedSpending.getCategory(Category.education).value = dWantsRatio;
    _allottedSpending.getCategory(Category.entertainment).value = dWantsRatio;
    _allottedSpending.getCategory(Category.kids).value = dWantsRatio;
    _allottedSpending.getCategory(Category.pets).value = dWantsRatio;
    _allottedSpending.getCategory(Category.miscellaneous).value = dWantsRatio;
    _allottedSpending.getCategory(Category.savings).value =
        _savingsRatio * _income;
  }

  @override
  Budget newFromBudget(Budget old) {
    _oldBudget = old;
    _income = old.expectedIncome;
    _allottedSpending = AllocationList.withCategoriesOf(old.allotted);
    if (_userExceededBudget()) {
      // Return the same budget as last month
      return Budget.from(old);
    }
    // Look at spending, see what fields were over and what were under
    _findSpendingDiffs();
    // Decide how much each allocation will change
    _calculateDeltas();
    // Execute change in allocations
    _reallocate();
    return Budget(
      expectedIncome: old.expectedIncome,
      type: old.type,
      // TODO update target based on old budget
      // This is wrong
      target: old.target,
      allotted: _allottedSpending,
      actual: AllocationList.withCategoriesOf(old.allotted),
      transactions: TransactionList(),
    );
  }

  bool _userExceededBudget() {
    double total = 0.0;
    _oldActualRatios.forEach((allocation) {
      total += allocation.value;
    });
    return total > _income;
  }

  void _findSpendingDiffs() {
    _spendingDiffs = AllocationList.withCategoriesOf(_oldBudget.allotted);
    _oldBudget.allotted.forEach((allotment) {
      if (allotment.category.isSpending) {
        Allocation actual = _oldBudget.actual.getCategory(allotment.category);
        _spendingDiffs
            .getCategory(allotment.category)
            .value =
            allotment.value.abs() - actual.value.abs();
      }
    });
  }

  void _calculateDeltas() {
    _deltas = AllocationList.withCategoriesOf(_allottedSpending);
    double toMove = 0;
    double overspending = 0;
    // Calculate the change happening in underspending allocations
    _deltas.forEach((allocation) {
      if (!allocation.category.isSpending) return; // Exit inst if not right cat
      // If not all money in category was spent
      double diff = _spendingDiffs
          .getWithSameCategory(allocation)
          .value;
      if (diff > 0) {
        double move = diff / 2;
        toMove += move;
        allocation.value = -move; // Take money away from underspending
      }
      // If overspending occurred
      else {
        overspending += diff.abs();
      }
    });
    // Currently, sum(deltas) = .5 * sum(_spendingDiffs | value > 0)
    // Currently, overspending = sum(_spendingDiffs | value <= 0)
    // Find the ratios of how much is being overspent in each category to the
    // total amount in toMove, and multiply that fraction by toMove to get the
    // dollar amount that the overspending categories should change by
    _deltas.forEach((allocation) {
      if (!allocation.category.isSpending) return;
      double diff = _spendingDiffs
          .getWithSameCategory(allocation)
          .value;
      if (diff < 0) {
        double ratioOfOverspending = diff.abs() / overspending;
        allocation.value = ratioOfOverspending * toMove;
      }
    });
  }

  void _reallocate() {
    _allottedSpending.forEach((allocation) {
      double oldValue = _oldBudget.allotted
          .getWithSameCategory(allocation)
          .value;
      double delta = _deltas
          .getWithSameCategory(allocation)
          .value;
      allocation.value = oldValue.abs() + delta;
    });
  }
}
