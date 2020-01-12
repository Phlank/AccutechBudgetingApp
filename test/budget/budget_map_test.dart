import 'package:budgetflow/budget/budget_map.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
	test("Test new map has all the needed keys", () {
		BudgetMap b = new BudgetMap();
		print(b.serialize());
	});
}