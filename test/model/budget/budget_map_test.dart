import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/category/category.dart';
import 'package:flutter_test/flutter_test.dart';

BudgetMap bm1, bm2;
String bm1Serialized =
    '{"0":{"category":{"name":"Housing","priority":"Required"},"amount":"0.0"},"1":{"category":{"name":"Utilities","priority":"Need"},"amount":"0.0"},"2":{"category":{"name":"Groceries","priority":"Need"},"amount":"0.0"},"3":{"category":{"name":"Savings","priority":"Savings"},"amount":"0.0"},"4":{"category":{"name":"Health","priority":"Need"},"amount":"0.0"},"5":{"category":{"name":"Transportation","priority":"Need"},"amount":"0.0"},"6":{"category":{"name":"Education","priority":"Want"},"amount":"0.0"},"7":{"category":{"name":"Entertainment","priority":"Want"},"amount":"0.0"},"8":{"category":{"name":"Kids","priority":"Want"},"amount":"0.0"},"9":{"category":{"name":"Pets","priority":"Want"},"amount":"0.0"},"10":{"category":{"name":"Miscellaneous","priority":"Want"},"amount":"0.0"},"11":{"category":{"name":"Uncategorized","priority":"Other"},"amount":"0.0"}}';
String bm2Serialized =
    '{"0":{"category":{"name":"Housing","priority":"Required"},"amount":"-200.0"},"1":{"category":{"name":"Utilities","priority":"Need"},"amount":"-150.0"},"2":{"category":{"name":"Groceries","priority":"Need"},"amount":"-300.0"},"3":{"category":{"name":"Savings","priority":"Savings"},"amount":"0.0"},"4":{"category":{"name":"Health","priority":"Need"},"amount":"0.0"},"5":{"category":{"name":"Transportation","priority":"Need"},"amount":"-100.0"},"6":{"category":{"name":"Education","priority":"Want"},"amount":"0.0"},"7":{"category":{"name":"Entertainment","priority":"Want"},"amount":"-175.0"},"8":{"category":{"name":"Kids","priority":"Want"},"amount":"-300.0"},"9":{"category":{"name":"Pets","priority":"Want"},"amount":"-300.0"},"10":{"category":{"name":"Miscellaneous","priority":"Want"},"amount":"0.0"},"11":{"category":{"name":"Uncategorized","priority":"Other"},"amount":"0.0"}}';

void main() {
  group('BudgetMap tests', () {
    setUp(() {
      bm1 = new BudgetMap();
      bm2 = new BudgetMap();
      bm2.addTo(Category.housing, -200.0);
      bm2.addTo(Category.groceries, -300.0);
      bm2.addTo(Category.pets, -300.0);
      bm2.addTo(Category.kids, -300.0);
      bm2.addTo(Category.utilities, -150.0);
      bm2.addTo(Category.transportation, -100.0);
      bm2.addTo(Category.entertainment, -175.0);
    });
    test("New map serialization", () {
      expect(bm1.serialize(), bm1Serialized);
    });
    test("New map serialization sanity", () {
      BudgetMap bm1Copy = BudgetMap.unserialize(bm1.serialize());
      expect(bm1Copy, bm1);
    });
    test("bm2 serialization", () {
      expect(bm2.serialize(), bm2Serialized);
    });
    test("addTo adds correct amount", () {
      expect(bm2[Category.housing], -200.0);
    });
    test("bm2 serialization sanity", () {
      BudgetMap bm2Copy = BudgetMap.unserialize(bm2.serialize());
      expect(bm2Copy == bm2, isTrue);
    });
  });
}
