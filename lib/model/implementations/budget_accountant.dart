import 'package:budgetflow/model/abstract/accountant.dart';
import 'package:budgetflow/model/data_types/allocation.dart';
import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/data_types/priority.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/utils/dates.dart';
import 'package:calendarro/date_utils.dart';

class BudgetAccountant implements Accountant {
  Budget _budget;

  BudgetAccountant(Budget budget) {
    _budget = budget;
  }

  double get spent {
    double spent = 0.0;
    for (Allocation allocation in _budget.actual.spendingAllocations) {
      if (allocation.category != Category.income)
        spent += allocation.value.abs();
    }
    return spent;
  }

  double get remaining => _budget.expectedIncome - spent;

  double get netMonth {
    double net = 0.0;
    _budget.transactions.forEach((t) {
      net += t.amount;
    });
    return net;
  }

  double get netWeek {
    double net = 0.0;
    _budget.transactions.forEach((t) {
      if (t.time.isAfter(DateTime.now().subtract(Duration(days: 7)))) {
        net += t.amount;
      }
    });
    return net;
  }

  double get balanceMonth => _budget.expectedIncome - spent;

  double get balanceWeek {
    return _getWeeklyIncome() - _getWeeklySpending();
  }

  double _getWeeklyIncome() {
    int numDaysInWeek =
        Dates.getEndOfWeek().difference((Dates.getStartOfWeek())).inDays;
    return _budget.expectedIncome *
        numDaysInWeek /
        DateUtils.getLastDayOfCurrentMonth().day.toDouble();
  }

  double _getWeeklySpending() {
    double weeklySpending = 0.0;
    for (Transaction transaction in _budget.transactions.spending) {
      if (transaction.time.isBefore(Dates.getEndOfWeek()) &&
          transaction.time.isAfter(Dates.getStartOfWeek())) {
        weeklySpending += transaction.amount;
      }
    }
    return weeklySpending;
  }

  double getAllottedOfPriority(Priority priority) {
    double total = 0.0;
    _budget.allotted.forEach((allocation) {
      if (allocation.category.priority == priority) total += allocation.value;
    });
    return total;
  }

  double getActualOfPriority(Priority priority) {
    double total = 0;
    _budget.actual.forEach((allocation) {
      if (allocation.category.priority == priority) total += allocation.value;
    });
    return total;
  }

  double getRemainingOfPriority(Priority priority) {
    return getAllottedOfPriority(priority) -
        getActualOfPriority(priority).abs();
  }

  double getAllottedOfCategory(Category category) {
    return _budget.allotted.firstWhere((element) {
      return element.category == category;
    }).value;
  }

  double getActualOfCategory(Category category) {
    return _budget.actual.firstWhere((element) {
      return element.category == category;
    }).value;
  }

  double getRemainingOfCategory(Category category) {
    return getAllottedOfCategory(category) -
        getActualOfCategory(category).abs();
  }
}
