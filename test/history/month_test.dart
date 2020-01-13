import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/transaction.dart';
import 'package:budgetflow/budget/transaction_list.dart';
import 'package:budgetflow/history/month.dart';
import 'package:flutter_test/flutter_test.dart';

Month m = new Month(2019, 12);

void main() {
	group("Month tests", () {
		setUp(() {});
		test("Serialization of new Month", () {
			print(m.serialize());
		});
		test("Serialization is reversible", () {
			String ms = m.serialize();
			String msc = Month.unserialize(m.serialize()).serialize();
			expect(ms, equals(msc));
		});
	});
}
