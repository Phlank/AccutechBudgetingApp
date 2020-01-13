import 'package:budgetflow/crypt/password.dart';
import 'package:budgetflow/crypt/steel_password.dart';
import 'package:budgetflow/history/history.dart';
import 'package:budgetflow/history/month.dart';
import 'package:flutter_test/flutter_test.dart';

History h = new History();

void main() {
	group("h tests", () {
		setUp(() {
			Password p = new SteelPassword("Hello there");
			Month m1 = new Month(2019, 12);
			Month m2 = new Month(2019, 11);
			h.addMonth(m1);
			h.addMonth(m2);
		});
		test("Serialization of h", () {
			print(h.serialize());
		});
		test("Serialization is reversible", () {
			h.serialize();
		});
	});
}
