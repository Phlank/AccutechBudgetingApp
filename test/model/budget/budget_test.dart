import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:flutter_test/flutter_test.dart';

Budget _builtBudget;
BudgetBuilder _builder = new BudgetBuilder();
Transaction _t;
Month _month;
MonthBuilder _monthBuilder = new MonthBuilder();
MonthTime _monthTime = new MonthTime(1998,4);

void main() {
  group("_builtBudget tests", () {
    setUp(() {
      _monthBuilder.setIncome(300);
      _monthBuilder.setType(BudgetType.savingDepletion);
      _monthBuilder.setMonthTime(_monthTime);
      _month = _monthBuilder.build();
      _builder.setIncome(300.0);
      _builder.setType(BudgetType.savingDepletion);
      _builtBudget = _builder.build();
      _t = new Transaction("KFC", "Cash", -5.4, BudgetCategory.miscellaneous);
    });
    group("Testing Built Budget", (){
      test("Built budget has no null fields", () {
        expect(_builtBudget.actualSpending, isNot(null));
        expect(_builtBudget.allottedSpending, isNot(null));
        expect(_builtBudget.transactions, isNot(null));
        expect(_builtBudget.income, isNot(null));
        expect(_builtBudget.type, isNot(null));
      });
      test("Built budget has correct income", () {
        expect(_builtBudget.income, 300.0);
      });
      test("Built budget has correct type", () {
        expect(_builtBudget.type, BudgetType.savingDepletion);
      });
      test("Built budget can have transaction added", () {
        _builtBudget.addTransaction(_t);
        expect(_builtBudget.actualSpending[BudgetCategory.miscellaneous], 5.4);
      });
    });
    group("Testing fromOldBudget",(){
      test("test for correct income", (){
        Budget b = new Budget.fromOldBudget(_builtBudget);
        expect(b.income, equals(300));
      });
      test("test for correct type", (){
        Budget b = new Budget.fromOldBudget(_builtBudget);
        expect(b.type, equals(BudgetType.savingDepletion));
      });
      test("test for correct transactions logic", (){
        Budget b = new Budget.fromOldBudget(_builtBudget);
        expect(b.transactions, isNot(null));
      });
      test("test for correct allotted and actual spending logic", (){
        Budget b = new Budget.fromOldBudget(_builtBudget);
        expect(b.allottedSpending, isNot(null));
        expect(b.actualSpending, isNot(null));
      });
    });
//    group("Testing fromMonth", (){
//      test("Built budget works fromMonth", (){
//        Budget b = new Budget.fromMonth(_month);
//        expect(b.income, isNot(null));
//      });
//    });

  });
}
