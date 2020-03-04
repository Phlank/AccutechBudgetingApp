import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/category/category.dart';
import 'package:flutter_test/flutter_test.dart';

BudgetMap bm1, bm2;
String bm1Serialized =
    '{"0":{"category":{"name":"Housing","priority":{"name":"Needs"}},"amount":"0.0"},"1":{"category":{"name":"Utilities","priority":{"name":"Needs"}},"amount":"0.0"},"2":{"category":{"name":"Groceries","priority":{"name":"Needs"}},"amount":"0.0"},"3":{"category":{"name":"Savings","priority":{"name":"Savings"}},"amount":"0.0"},"4":{"category":{"name":"Health","priority":{"name":"Needs"}},"amount":"0.0"},"5":{"category":{"name":"Transportation","priority":{"name":"Needs"}},"amount":"0.0"},"6":{"category":{"name":"Education","priority":{"name":"Wants"}},"amount":"0.0"},"7":{"category":{"name":"Entertainment","priority":{"name":"Wants"}},"amount":"0.0"},"8":{"category":{"name":"Kids","priority":{"name":"Wants"}},"amount":"0.0"},"9":{"category":{"name":"Pets","priority":{"name":"Wants"}},"amount":"0.0"},"10":{"category":{"name":"Miscellaneous","priority":{"name":"Wants"}},"amount":"0.0"},"11":{"category":{"name":"Uncategorized","priority":{"name":"Other"}},"amount":"0.0"}}';
String bm2Serialized =
    '{"0":{"category":{"name":"Housing","priority":{"name":"Needs"}},"amount":"-200.0"},"1":{"category":{"name":"Utilities","priority":{"name":"Needs"}},"amount":"-150.0"},"2":{"category":{"name":"Groceries","priority":{"name":"Needs"}},"amount":"-300.0"},"3":{"category":{"name":"Savings","priority":{"name":"Savings"}},"amount":"0.0"},"4":{"category":{"name":"Health","priority":{"name":"Needs"}},"amount":"0.0"},"5":{"category":{"name":"Transportation","priority":{"name":"Needs"}},"amount":"-100.0"},"6":{"category":{"name":"Education","priority":{"name":"Wants"}},"amount":"0.0"},"7":{"category":{"name":"Entertainment","priority":{"name":"Wants"}},"amount":"-175.0"},"8":{"category":{"name":"Kids","priority":{"name":"Wants"}},"amount":"-300.0"},"9":{"category":{"name":"Pets","priority":{"name":"Wants"}},"amount":"-300.0"},"10":{"category":{"name":"Miscellaneous","priority":{"name":"Wants"}},"amount":"0.0"},"11":{"category":{"name":"Uncategorized","priority":{"name":"Other"}},"amount":"0.0"}}';

void main() {
  group('BudgetMap tests', () {
    setUp(() {
      bm1 = new BudgetMap();
      bm2 = new BudgetMap();
      bm2[Category.housing] += -200.0;
      bm2[Category.groceries] += -300.0;
      bm2[Category.pets] += -300.0;
      bm2[Category.kids] += -300.0;
      bm2[Category.utilities] += -150.0;
      bm2[Category.transportation] += -100.0;
      bm2[Category.entertainment] += -175.0;
    });
    test("New map serialization", () {
      expect(bm1.serialize, bm1Serialized);
    });
    test("New map serialization sanity", () {
      BudgetMap bm1Copy = BudgetMap.unserialize(bm1.serialize);
      expect(bm1Copy, bm1);
    });
    test("bm2 serialization", () {
      expect(bm2.serialize, bm2Serialized);
    });
    test("addTo adds correct amount", () {
      expect(bm2[Category.housing], -200.0);
    });
    test("bm2 serialization sanity", () {
      BudgetMap bm2Copy = BudgetMap.unserialize(bm2.serialize);
      expect(bm2Copy == bm2, isTrue);
    });
  });
}
