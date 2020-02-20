import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:flutter_test/flutter_test.dart';

Transaction t1 = new Transaction(null, null, 0.0, null);
Transaction t2 =
    new Transaction("Walmart", "Credit Card", 0.0, Category.groceries);
String t2s =
    "{\"datetime\":\"1578881628138\",\"vendor\":\"Walmart\",\"method\":\"Credit Card\",\"delta\":\"0.0\",\"category\":\"Groceries\"}";

void main() {
  test("Serialization of new transaction", () {
    expect(t2.serialize, isNot(null));
  });
  test("Serialization sanity", () {
    String t2s = t2.serialize;
    expect(
        t2s, equals(Serializer
        .unserialize(KEY_TRANSACTION, t2s)
        .serialize));
  });
}
