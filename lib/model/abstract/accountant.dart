import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/data_types/priority.dart';

/// Used to provide functionality to complicated data structures, like [Budget].
abstract class Accountant {

  /// The money spent.
  double get spent;

  /// The money remaining.
  double get remaining;

  /// Total sum of all transactions and expected income in this month.
  double get netMonth;

  /// Total sum of all transactions and expected income in this week.
  double get netWeek;

  /// Amount remaining for the month with expected income considered.
  double get balanceMonth;

  /// Amount remaining for the week with expected income considered
  double get balanceWeek;

  double getAllottedOfPriority(Priority priority);

  double getActualOfPriority(Priority priority);

  double getRemainingOfPriority(Priority priority);

  double getAllottedOfCategory(Category category);

  double getActualOfCategory(Category category);

  double getRemainingOfCategory(Category category);
}
