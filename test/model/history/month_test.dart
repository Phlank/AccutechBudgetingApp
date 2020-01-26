import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:flutter_test/flutter_test.dart';

Month m;
String mSerialization;
MonthBuilder builder = new MonthBuilder();

void main() {
  group("MonthBuilder tests", () {
    setUp(() {
      builder.setType(BudgetType.savingGrowth);
      builder.setIncome(400.0);
      builder.setMonthTime(new MonthTime(2020, 01));
      mSerialization = '{"year":"2020","month":"1","income":"400.0","type":"Growth"}';
      m = builder.build();
    });
    test("Built month has correct type", () {
      expect(m.type, BudgetType.savingGrowth);
    });
    test("Built month has correct income", () {
      expect(m.income, 400.0);
    });
    test("Built month has correct monthTime", () {
      expect(m.monthTime, new MonthTime(2020, 01));
    });
    test("Default built month has blank, non-null allotted", () {
      expect(m.allotted, equals(new BudgetMap()));
    });
    test("Default built month has blank, non-null actual", () {
      expect(m.actual, equals(new BudgetMap()));
    });
    test("Default built month has blank, non-null transactions", () {
      expect(m.transactions, equals(new TransactionList()));
    });
    test("Serialization of new Month", () {
      expect(m.serialize(), mSerialization);
    });
    test("Serialization is reversible", () {
      String ms = m.serialize();
      Month msm = Month.unserialize(ms);
      expect(m, equals(msm));
    });
  });
}
