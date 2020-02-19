import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/history/history.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:flutter_test/flutter_test.dart';

History h = new History();
MonthBuilder mb = new MonthBuilder();
Month m;
Transaction t1, t2, t3;
TransactionList tL;

void main() {
	group("History tests", () {
		setUp(() {
			t1 = new Transaction("KFC", "Cash", -6.48, Category.miscellaneous);
			t2 = new Transaction(
					"Speedway", "Credit", -20.24, Category.transportation);
			t3 =
			new Transaction("Walmart", "Checking", -31.20, Category.groceries);
			tL = new TransactionList();
			tL.add(t1);
			tL.add(t2);
			tL.add(t3);
			mb.setType(BudgetType.savingGrowth);
			mb.setIncome(2500);
			mb.setMonthTime(MonthTime.now());
			mb.setTransactions(tL);
			m = mb.build();
			h = new History();
			h.addMonth(m);
		});
		test("Months are retrievable", () {
			Month retrievedMonth = h.getMonth(MonthTime.now());
			expect(retrievedMonth, equals(m));
		});
		test("Month transactions are retrievable", () async {
			TransactionList retrievedTransactions = await h
					.getTransactionsFromMonthTime(MonthTime.now());
			expect(retrievedTransactions, equals(tL));
		});
	});
}
