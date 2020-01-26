import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_factory.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/priority_budget_factory.dart';
import 'package:flutter_test/flutter_test.dart';

Budget _budget;
BudgetBuilder _builder = new BudgetBuilder();
BudgetFactory _budgetFactory = new PriorityBudgetFactory();


void main (){
  TestWidgetsFlutterBinding.ensureInitialized();
  group("BudgetFactoryTest cases", (){
    setUp((){
      _builder.setIncome(2500.0);
      _builder.setType(BudgetType.savingDepletion);
      _budget = _builder.build();
    });
    group("Testing newFromBudget", (){
      test("test factory intilization", (){
        expect(_budgetFactory.newFromBudget(_budget), isNot(null));
      });
      test("test factory income", (){
        expect(_budgetFactory.newFromBudget(_budget).income, equals(2500.0) );
      });
      test("test factory spending", (){
        expect(_budgetFactory.newFromBudget(_budget).type, equals(BudgetType.savingDepletion) );
      });
      test("test factory intialization", (){
        expect(_budgetFactory.newFromBudget(_budget).allottedSpending, isNot(null) );
        expect(_budgetFactory.newFromBudget(_budget).actualSpending, isNot(null));
      });
      test("test factory transaction detection", (){
        expect(_budgetFactory.newFromBudget(_budget).transactions, isNot(null));
      });
    });

    group("Testing newFromInfo", (){
      test("", (){
      });
    });
  });
}