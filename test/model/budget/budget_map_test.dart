import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:flutter_test/flutter_test.dart';

BudgetMap bm1 = new BudgetMap();
String bm1Serialized = "{\"Housing\":\"0.0\",\"Utilities\":\"0.0\",\"Groceries\":\"0.0\",\"Savings\":\"0.0\",\"Health\":\"0.0\",\"Transportation\":\"0.0\",\"Education\":\"0.0\",\"Entertainment\":\"0.0\",\"Kids\":\"0.0\",\"Pets\":\"0.0\",\"Miscellaneous\":\"0.0\"}";
String bm2Serialized = "{\"Housing\":\"4.0\",\"Utilities\":\"3.0\",\"Groceries\":\"4.0\",\"Savings\":\"5.0\",\"Health\":\"0.0\",\"Transportation\":\"0.0\",\"Education\":\"0.0\",\"Entertainment\":\"0.0\",\"Kids\":\"0.0\",\"Pets\":\"0.0\",\"Miscellaneous\":\"0.0\"}";


void main() {
	test("Test new map has all categories", () {
		BudgetMap b = new BudgetMap();
		expect(b.serialize(), equals(bm1Serialized));
	});
	test("Map from serialized has categories", () {
		BudgetMap b = BudgetMap.unserialize(bm2Serialized);
		print(b.serialize());
	});
}