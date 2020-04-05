import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/data_types/transaction_list.dart';
import 'package:budgetflow/model/payment/payment_method.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

TransactionList tl1 = new TransactionList();

class MockTransaction extends Mock implements Transaction {}

MockTransaction t1, t2, t3;

void setUpTransactions() {
  t1 = MockTransaction();
  when(t1.vendor).thenReturn('Walmart');
  when(t1.method).thenReturn(PaymentMethod('Credit card'));
  when(t1.amount).thenReturn(-21.29);
  when(t1.category).thenReturn(Category.groceries);

  t2 = MockTransaction();
  when(t2.vendor).thenReturn('Walmart');
  when(t2.method).thenReturn(PaymentMethod('Credit card'));
  when(t2.amount).thenReturn(-41.29);
  when(t2.category).thenReturn(Category.groceries);

  t3 = MockTransaction();
  when(t3.vendor).thenReturn('KFC');
  when(t3.method).thenReturn(PaymentMethod('Credit card'));
  when(t3.amount).thenReturn(-5.40);
  when(t3.category).thenReturn(Category.miscellaneous);
}

void main() {
  group("TransactionList tests", () {
    setUp(() {
      setUpTransactions();
    });
    test("Added transactions are in TransactionList", () {
      tl1.add(t1);
      expect(tl1.contains(t1), true);
    });
  });
}
