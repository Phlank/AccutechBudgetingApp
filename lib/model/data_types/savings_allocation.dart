import 'package:budgetflow/model/data_types/allocation.dart';
import 'package:budgetflow/model/data_types/category.dart';

class SavingsAllocation extends Allocation {
  double target;

  SavingsAllocation(Category category, double value, this.target)
      : super(category, value);

  bool get targetMet => value >= target;
}
