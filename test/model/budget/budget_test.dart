import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/category/category_list.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:flutter_test/flutter_test.dart';

Budget _builtBudget;
BudgetBuilder _builder = new BudgetBuilder();
Transaction _t;
Month _month;
MonthBuilder _monthBuilder = new MonthBuilder();
MonthTime _monthTime = new MonthTime(1998, 4);
BudgetControl bc = new BudgetControl();
Budget b;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("_builtBudget tests", () {
    setUp(() {
      _monthBuilder.setIncome(300);
      _monthBuilder.setType(BudgetType.savingDepletion);
      _monthBuilder.setMonthTime(_monthTime);
      _month = _monthBuilder.build();
      _builder.setIncome(300.0);
      _builder.setType(BudgetType.savingDepletion);
      _builtBudget = _builder.build();
      _t = new Transaction("KFC", "Cash", -5.4, Category.miscellaneous);
    });
    group("Testing Built Budget", () {
      test("Built budget has no null fields", () {
        expect(_builtBudget.actual, isNot(null));
        expect(_builtBudget.allotted, isNot(null));
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
        expect(_builtBudget.actual[Category.miscellaneous], 5.4);
      });
    });
    group("Testing fromOldBudget", () {
      test("test for correct income", () {
        Budget b = new Budget.fromOldBudget(_builtBudget);
        expect(b.income, equals(300));
      });
      test("test for correct type", () {
        Budget b = new Budget.fromOldBudget(_builtBudget);
        expect(b.type, equals(BudgetType.savingDepletion));
      });
      test("test for correct transactions logic", () {
        Budget b = new Budget.fromOldBudget(_builtBudget);
        expect(b.transactions, isNot(null));
      });
      test("test for correct allotted and actual spending logic", () {
        Budget b = new Budget.fromOldBudget(_builtBudget);
        expect(b.allotted, isNot(null));
        expect(b.actual, isNot(null));
      });
    });
    group("Testing fromMonth", () {
      test("Test for income", () async {
        b = await Budget.fromMonth(_month);
        expect(b.income, equals(300));
      });
      test("Test for type", () async {
        b = await Budget.fromMonth(_month);
        expect(b.type, equals(BudgetType.savingDepletion));
      });
      test("Test for transaction", () async {
        b = await Budget.fromMonth(_month);
        expect(b.transactions, new TransactionList());
      });
      test("Test for alotted and actual spending", () async {
        b = await Budget.fromMonth(_month);
        expect(b.allotted, new BudgetMap());
        expect(b.actual, new BudgetMap());
      });
    });
    group('Budget functionality', () {
      setUp(() {
        BudgetBuilder builder = new BudgetBuilder();
        List<Transaction> tl = <Transaction>[
          new Transaction.withTime('BSU', 'Credit', -10.00, Category.groceries,
              DateTime(2020, 2, 13)),
          new Transaction.withTime('BSU', 'Credit', -10.00, Category.education,
              DateTime(2020, 2, 13)),
          new Transaction.withTime('BSU', 'Credit', -10.00, Category.groceries,
              DateTime(2020, 2, 10)),
          new Transaction.withTime('BSU', 'Credit', -10.00, Category.groceries,
              DateTime(2020, 2, 9)),
          new Transaction.withTime('BSU', 'Credit', -10.00, Category.groceries,
              DateTime(2020, 2, 8)),
          new Transaction.withTime('BSU', 'Credit', -10.00, Category.groceries,
              DateTime(2020, 2, 7)),
          new Transaction.withTime('BSU', 'Credit', -10.00, Category.groceries,
              DateTime(2020, 2, 4)),
          new Transaction.withTime(
              'BSU', 'Credit', -10.00, Category.groceries, DateTime(2020, 2, 4))
        ];
        TransactionList transactions = new TransactionList();
        tl.forEach((Transaction t) {
          transactions.add(t);
        });
        builder.setIncome(1200);
        builder.setTransactions(transactions);
        builder.setType(BudgetType.savingGrowth);
        builder.setCategories(new CategoryList());
        _builtBudget = builder.build();
      });
      test('Month net is -80.00', () {
        expect(_builtBudget.netMonth, -80.00);
      });
      test('Week net is -60.00', () {
        expect(_builtBudget.netWeek, -60.00);
      });
    });
  });
}
