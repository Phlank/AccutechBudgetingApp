import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/data_types/priority.dart';
import 'package:budgetflow/model/util/dates.dart';
import 'package:calendarro/date_utils.dart';

class BudgetAccountant {
  Budget _budget;

  BudgetAccountant(Budget budget) {
    _budget = budget;
  }

  double get spent {
    double spent = 0.0;
    _budget.actual.spendingAllocations.forEach((allocation) {
      spent += allocation.value.abs();
    });
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
    _budget.transactions.forEach((transaction) {
      if (transaction.time.isBefore(Dates.getEndOfWeek()) &&
          transaction.time.isAfter(Dates.getStartOfWeek())) {
        if (transaction.category != Category.income) {
          weeklySpending += transaction.amount;
        }
      }
    });
    return weeklySpending;
  }

  double getAllottedPriority(Priority priority) {
    double total = 0.0;
    _budget.allotted.forEach((allocation) {
      if (allocation.category.priority == priority) total += allocation.value;
    });
    return total;
  }

  double getActualPriority(Priority priority) {
    double total = 0;
    _budget.actual.forEach((allocation) {
      if (allocation.category.priority == priority) total += allocation.value;
    });
    return total;
  }

  double getRemainingPriority(Priority priority) {
    return getAllottedPriority(priority) - getActualPriority(priority).abs();
  }

  double getAllottedCategory(Category category) {
    return _budget.allotted.firstWhere((element) {
      return element.category == category;
    }).value;
  }

  double getActualCategory(Category category) {
    return _budget.actual.firstWhere((element) {
      return element.category == category;
    }).value;
  }

  double getRemainingCategory(Category category) {
    return getAllottedCategory(category) - getActualCategory(category).abs();
  }
}
