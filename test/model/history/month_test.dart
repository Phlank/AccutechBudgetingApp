import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:flutter_test/flutter_test.dart';

Month m;
String mSerialization;

void main() {
	group("Month tests", () {
		setUp(() {
			m = new Month(new MonthTime(2019, 12), 1200.0);
			mSerialization = '{"year":"2019","month":"12","income":"1200.0"}';
		});
		test("Serialization of new Month", () {
			expect(m.serialize(), mSerialization);
		});
		test("Serialization is reversible", () {
			String ms = m.serialize();
			String msc = Month.unserialize(m.serialize()).serialize();
			expect(ms, equals(msc));
		});
	});
}
