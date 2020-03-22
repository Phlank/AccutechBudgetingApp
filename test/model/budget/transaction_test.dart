import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:flutter_test/flutter_test.dart';

Transaction t1 = Transaction.empty;
Transaction t2 = new Transaction(
  vendor: "Walmart",
  method: "Credit",
  amount: 0.0,
  category: Category.groceries,
  time: DateTime.fromMillisecondsSinceEpoch(1578881628138),
);
String t2s =
    '{"time":"1578881628138","vendor":"Walmart","method":"Credit","amount":"0.0","category":{"name":"Groceries","priority":{"name":"Needs"}},"location":{"latitude":"0.0","longitude":"0.0"}}';

void main() {
  test("Serialization of new transaction", () {
    expect(t2.serialize, t2s);
  });
  test("Serialization sanity", () {
    String t2s = t2.serialize;
    expect(t2s, equals(Serializer
        .unserialize(transactionKey, t2s)
        .serialize));
  });
}
