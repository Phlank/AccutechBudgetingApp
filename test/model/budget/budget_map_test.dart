import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:flutter_test/flutter_test.dart';

BudgetMap bm1, bm2;
String bm1Serialized =
    '{"0.0":{"name":"Housing","priority":"Required"},"0.0":{"name":"Utilities","priority":"Need"},"0.0":{"name":"Groceries","priority":"Need"},"0.0":{"name":"Savings","priority":"Savings"},"0.0":{"name":"Health","priority":"Need"},"0.0":{"name":"Transportation","priority":"Need"},"0.0":{"name":"Education","priority":"Want"},"0.0":{"name":"Entertainment","priority":"Want"},"0.0":{"name":"Kids","priority":"Want"},"0.0":{"name":"Pets","priority":"Want"},"0.0":{"name":"Miscellaneous","priority":"Want"},"0.0":{"name":"Uncategorized","priority":"Other"}}';

void main() {
  group('BudgetMap tests', () {
    setUp(() {
      bm1 = new BudgetMap();
      bm2 = new BudgetMap();
      bm2.addTo(Category.housing, 200.0);
    });
    test("New map serialization", () {
      expect(bm1.serialize(), bm1Serialized);
    });
    test("New map serialization sanity", () {
      BudgetMap bm1Copy = BudgetMap.unserialize(bm1.serialize());
      expect(bm1Copy, bm1);
    });
    test("addTo adds correct amount", () {
      expect(bm2[Category.housing], 200.0);
    });
  });
}
