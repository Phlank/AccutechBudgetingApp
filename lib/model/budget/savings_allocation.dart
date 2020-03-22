import 'package:budgetflow/model/budget/allocation.dart';
import 'package:budgetflow/model/budget/category/category.dart';

class SavingsAllocation extends Allocation {
  double target;

  SavingsAllocation(Category category, double value, this.target)
      : super(category, value);

  bool get targetMet => value >= target;
}
