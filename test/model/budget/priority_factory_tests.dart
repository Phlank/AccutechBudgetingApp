//import 'package:budgetflow/model/budget/budget.dart';
//import 'package:budgetflow/model/budget/budget_type.dart';
//import 'package:budgetflow/model/budget/category/category.dart';
//import 'package:budgetflow/model/budget/factory/budget_factory.dart';
//import 'package:budgetflow/model/budget/factory/priority_budget_factory.dart';
//import 'package:flutter_test/flutter_test.dart';
//
//Budget _budget;
//BudgetBuilder _builder = new BudgetBuilder();
//BudgetFactory _budgetFactory = new PriorityBudgetFactory();
//
//void main() {
//  TestWidgetsFlutterBinding.ensureInitialized();
//  group("BudgetFactoryTest cases", () {
//    setUp(() {
//      _builder.setIncome(2500.0);
//      _builder.setType(BudgetType.depletion);
//      _budget = _builder.build();
//      _budgetFactory.newFromInfo(2500, 500, BudgetType.depletion);
//    });
//    group("Testing newFromBudget", () {
//      test("test factory intilization", () {
//        expect(_budgetFactory.newFromBudget(_budget), isNot(null));
//      });
//      test("test factory income", () {
//        expect(_budgetFactory.newFromBudget(_budget).income, equals(2500.0));
//      });
//      test("test factory spending", () {
//        expect(_budgetFactory.newFromBudget(_budget).type,
//            equals(BudgetType.depletion));
//      });
//      test("test factory intialization", () {
//        expect(_budgetFactory.newFromBudget(_budget).allotted, isNot(null));
//        expect(_budgetFactory.newFromBudget(_budget).actual, isNot(null));
//      });
//      test("test factory transaction detection", () {
//        expect(_budgetFactory.newFromBudget(_budget).transactions, isNot(null));
//      });
//    });
//
//    group("Testing newFromInfo", () {
//      test("test process initalization", () {
//        expect(
//            _budgetFactory.newFromInfo(2500, 1250, BudgetType.depletion),
//            isNot(null));
//      });
//      test("test income", () {
//        expect(
//            _budgetFactory
//                .newFromInfo(2500, 1250, BudgetType.depletion)
//                .income,
//            equals(2500));
//      });
//      test("test type", () {
//        expect(
//            _budgetFactory
//                .newFromInfo(2500, 1250, BudgetType.depletion)
//                .type,
//            equals(BudgetType.depletion));
//      });
//      test("test BudgetMap initalization", () {
//        expect(
//            _budgetFactory
//                .newFromInfo(2500, 1250, BudgetType.depletion)
//                .actual,
//            isNot(null));
//        expect(
//            _budgetFactory
//                .newFromInfo(2500, 1250, BudgetType.depletion)
//                .allotted,
//            isNot(null));
//      });
//      test("test transactions", () {
//        expect(
//            _budgetFactory
//                .newFromInfo(2500, 1250, BudgetType.depletion)
//                .transactions,
//            isNot(null));
//      });
//      test("test BudgetMap initalization", () {
//        expect(
//            _budgetFactory
//                .newFromInfo(2500, 1250, BudgetType.depletion)
//                .allotted[Category.housing],
//            equals(1250));
//      });
//      test("test needs budgeting", () {
//        expect(
//            _budgetFactory
//                .newFromInfo(2500, 1250, BudgetType.depletion)
//                .allotted[Category.groceries],
//            equals(156.25));
//      });
//      test("test wants budgeting", (){
//        expect(
//            _budgetFactory
//                .newFromInfo(2500, 1250, BudgetType.depletion)
//                .allotted[Category.miscellaneous],
//            equals(125));
//      });
//    });
//  });
//}
