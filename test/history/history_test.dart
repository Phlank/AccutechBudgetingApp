import 'package:budgetflow/model/crypt/password.dart';
import 'package:budgetflow/model/crypt/steel_password.dart';
import 'package:budgetflow/model/history/history.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:flutter_test/flutter_test.dart';

History h = new History();

void main() {
	group("h tests", () {
		setUp(() {
			Password p = new SteelPassword("Hello there");
			Month m1 = new Month(2019, 12, 1200.0);
			Month m2 = new Month(2019, 11, 1200.0);
			h.addMonth(m1);
			h.addMonth(m2);
		});
	});
}
