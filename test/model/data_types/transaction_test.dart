import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/data_types/payment_method.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter_test/flutter_test.dart';

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
