import 'dart:math';

import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/transaction/transaction.dart';
import 'package:budgetflow/budget/transaction/transaction_list.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionList tl1 = new TransactionList();
Transaction t1 =
    new Transaction("Walmart", "Credit card", -21.29, BudgetCategory.groceries);
Transaction t2 =
    new Transaction("Walmart", "Credit card", -41.29, BudgetCategory.groceries);
Transaction t3 =
    new Transaction("KFC", "Credit card", -5.40, BudgetCategory.miscellaneous);

void main() {
  group("TransactionList tests", () {
    setUp(() {
        tl1.add(t1);
        tl1.add(t2);
        tl1.add(t3);
    });
    test("Serialization of new TransactionList", () {
        print(tl1.serialize());
    });
    test("Serialization is reversible", () {
        String tl1s = tl1.serialize();
        String tl1cs = TransactionList.unserialize(tl1.serialize()).serialize();
        expect(tl1s, equals(tl1cs));
    });
  });
}
