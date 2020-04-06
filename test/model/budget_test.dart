import 'package:budgetflow/model/data_types/allocation_list.dart';
import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/data_types/budget_type.dart';
import 'package:flutter_test/flutter_test.dart';

Budget budget;

void main() {
  group('Budget tests', () {
    setUp(() {
      budget = Budget(
        allotted: AllocationList.defaultCategories(),
        target: AllocationList.defaultCategories(),
        type: BudgetType.growth,
        expectedIncome: 1000.0,
      );
    });
    test('Test default budget creation', () {
      expect(budget, isNot(null));
      expect(budget.allotted, isNot(null));
      expect(budget.actual, isNot(null));
      expect(budget.target, isNot(null));
    });
  });
}
