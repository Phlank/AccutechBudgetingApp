import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/data_types/payment_method.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter_test/flutter_test.dart';

Transaction t1 = Transaction.empty;
Transaction t2 = new Transaction(
  vendor: "Walmart",
  method: PaymentMethod("Credit"),
  amount: 0.0,
  category: Category.groceries,
  time: DateTime.fromMillisecondsSinceEpoch(1578881628138),
);

void main() {
  test("Serialization sanity with location=null", () {
    Transaction t = Transaction(
      vendor: 'Vendor',
      method: PaymentMethod('Method'),
      amount: -20.0,
      time: DateTime.now(),
      category: Category.housing,
    );
    Transaction fromT = Serializer.unserialize(transactionKey, t.serialize);
    expect(t == fromT, isTrue);
  });
}
