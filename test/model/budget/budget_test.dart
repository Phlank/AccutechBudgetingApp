import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:flutter_test/flutter_test.dart';

Budget _builtBudget;
BudgetBuilder _builder = new BudgetBuilder();
Transaction _t;

void main() {
  group("_builtBudget tests", () {
    setUp(() {
      _builder.setIncome(300.0);
      _builder.setType(BudgetType.savingDepletion);
      _builtBudget = _builder.build();
      _t = new Transaction("KFC", "Cash", -5.4, BudgetCategory.miscellaneous);
    });
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
    test("Built budget works fromOldBudget", (){
      Budget b = new Budget.fromOldBudget(_builtBudget);
      expect(b.type, equals(BudgetType.savingDepletion));
      expect(b.income, equals(300));
    });
    test("Built budget works fromMonth", (){
    });
  });
}
