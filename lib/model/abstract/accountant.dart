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

  /// Returns the total amount of money allotted to all categories belonging to [priority].
  double getAllottedOfPriority(Priority priority);

  /// Returns the total amount of money spent or received in all categories belonging to [priority].
  double getActualOfPriority(Priority priority);

  /// Returns the total amount of money remaining for all categories belonging to [priority].
  double getRemainingOfPriority(Priority priority);

  /// Returns the total amount of money allotted to [category].
  double getAllottedOfCategory(Category category);

  /// Returns the total amount of money spent or received by [category].
  double getActualOfCategory(Category category);

  /// Returns the total amount of money remaining for [category].
  double getRemainingOfCategory(Category category);
}
