import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/history/history.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:flutter_test/flutter_test.dart';

History h = new History();
MonthBuilder mb = new MonthBuilder();
Month m;
Transaction t1, t2, t3;

void main() {
	group("History tests", () {
		setUp(() {
      mb.setType(BudgetType.growth);
			mb.setIncome(2500);
			mb.setMonthTime(MonthTime.now());
			m = mb.build();
			h = new History();
			h.addMonth(m);
		});
		test("Months are retrievable", () {
			Month retrievedMonth = h.getMonth(MonthTime.now());
			expect(retrievedMonth, equals(m));
		});
	});
}
