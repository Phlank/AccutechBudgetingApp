import 'package:budgetflow/model/budget/budget_type.dart';
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
      builder.setMonthTime(new MonthTime(2020, 1));
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
    test("Serialization of new Month", () {
      expect(m.serialize, mSerialization);
    });
    test("Serialization is reversible", () async {
      String ms = m.serialize;
      Month msm = Month.unserialize(ms);
      await m.loadAllotted();
      await m.loadActual();
      await m.loadTransactions();
      await msm.loadAllotted();
      await msm.loadActual();
      await msm.loadTransactions();
      expect(m == msm, isTrue);
    });
  });
}
