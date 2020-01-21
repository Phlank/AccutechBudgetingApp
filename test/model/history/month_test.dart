import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:flutter_test/flutter_test.dart';

Month m = new Month(new MonthTime(2019, 12), 1200.0);

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
