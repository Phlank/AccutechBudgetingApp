import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

Budget _budget;
Transaction _t;
Month _month;
MonthBuilder _monthBuilder = new MonthBuilder();
MonthTime _monthTime = new MonthTime(1998, 4);
BudgetControl bc = new BudgetControl();
Budget b;

class MockTransaction extends Mock implements Transaction {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("_builtBudget tests", () {
    setUp(() {
      _monthBuilder.setIncome(300);
      _monthBuilder.setType(BudgetType.depletion);
      _monthBuilder.setMonthTime(_monthTime);
      _month = _monthBuilder.build();
      _budget = Budget(
        expectedIncome: 300.0,
        type: BudgetType.depletion,
        target: BudgetMap(),
        allotted: BudgetMap(),
      );
      _t = new Transaction(
        vendor: "KFC",
        method: "Cash",
        amount: -5.4,
        category: Category.miscellaneous,
        time: DateTime.now(),
      );
    });
    group("Testing Built Budget", () {
      test("Built budget has no null fields", () {
        expect(_budget.actual, isNot(null));
        expect(_budget.allotted, isNot(null));
        expect(_budget.transactions, isNot(null));
        expect(_budget.expectedIncome, isNot(null));
        expect(_budget.type, isNot(null));
      });
      test("Built budget has correct income", () {
        expect(_budget.expectedIncome, 300.0);
      });
      test("Built budget has correct type", () {
        expect(_budget.type, BudgetType.depletion);
      });
      test("Built budget can have transaction added", () {
        _budget.addTransaction(_t);
        expect(_budget.actual[Category.miscellaneous], 5.4);
      });
    });
    group("Testing fromOldBudget", () {
      test("test for correct income", () {
        Budget b = new Budget.from(_budget);
        expect(b.expectedIncome, equals(300));
      });
      test("test for correct type", () {
        Budget b = new Budget.from(_budget);
        expect(b.type, equals(BudgetType.depletion));
      });
      test("test for correct transactions logic", () {
        Budget b = new Budget.from(_budget);
        expect(b.transactions, isNot(null));
      });
      test("test for correct allotted and actual spending logic", () {
        Budget b = new Budget.from(_budget);
        expect(b.allotted, isNot(null));
        expect(b.actual, isNot(null));
      });
    });
    group("Testing fromMonth", () {
      test("Test for income", () async {
        b = await Budget.fromMonth(_month);
        expect(b.expectedIncome, equals(300));
      });
      test("Test for type", () async {
        b = await Budget.fromMonth(_month);
        expect(b.type, equals(BudgetType.depletion));
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
        _budget = Budget(expectedIncome: 2000,
            type: BudgetType.growth,
            target: BudgetMap(),
            allotted: BudgetMap());
      });
      test('Add transaction makes spending positive', () {
        MockTransaction transaction = MockTransaction();
        when(transaction.category).thenReturn(Category.groceries);
        when(transaction.amount).thenReturn(-100);
        _budget.addTransaction(transaction);
        expect(_budget.spent, 100);
      });
    });
  });
}
