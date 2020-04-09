import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/data_types/priority.dart';

abstract class Accountant {
  double get spent;

  double get remaining;

  double get netMonth;

  double get netWeek;

  double get balanceMonth;

  double get balanceWeek;

  double getAllottedOfPriority(Priority priority);

  double getActualOfPriority(Priority priority);

  double getRemainingOfPriority(Priority priority);

  double getAllottedOfCategory(Category category);

  double getActualOfCategory(Category category);

  double getRemainingOfCategory(Category category);
}
