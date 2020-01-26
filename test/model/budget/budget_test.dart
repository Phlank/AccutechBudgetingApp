import 'package:budgetflow/model/budget/budget.dart';
import 'package:flutter_test/flutter_test.dart';

Budget builtBudget;

void main() {
  group("Budget tests", () {
    setUp(() {
    });
    test("Built budget has no null fields", () {
      print(tl1.serialize());
    });
    test("Built ", () {
      String tl1s = tl1.serialize();
      String tl1cs = TransactionList.unserialize(tl1.serialize()).serialize();
      expect(tl1s, equals(tl1cs));
    });
  });
}