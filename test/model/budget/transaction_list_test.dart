import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionList tl1 = new TransactionList();
Transaction t1 =
    new Transaction("Walmart", "Credit card", -21.29, Category.groceries);
Transaction t2 =
    new Transaction("Walmart", "Credit card", -41.29, Category.groceries);
Transaction t3 =
    new Transaction("KFC", "Credit card", -5.40, Category.miscellaneous);

void main() {
  group("TransactionList tests", () {
    setUp(() {
        tl1.add(t1);
        tl1.add(t2);
        tl1.add(t3);
    });
    test("Added transactions are in TransactionList", () {
      expect(tl1.contains(t1), true);
      expect(tl1.contains(t2), true);
      expect(tl1.contains(t3), true);
    });
    test("Serialization is reversible", () {
        String tl1s = tl1.serialize();
        String tl1cs = TransactionList.unserialize(tl1.serialize()).serialize();
        expect(tl1s, equals(tl1cs));
    });
  });
}
