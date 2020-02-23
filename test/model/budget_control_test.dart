//import 'package:budgetflow/model/budget/budget.dart';
//import 'package:budgetflow/model/budget/budget_type.dart';
//import 'package:budgetflow/model/budget/category/category.dart';
//import 'package:budgetflow/model/budget/factory/budget_factory.dart';
//import 'package:budgetflow/model/budget/factory/priority_budget_factory.dart';
//import 'package:budgetflow/model/budget/transaction/transaction.dart';
//import 'package:budgetflow/model/budget_control.dart';
//import 'package:flutter_test/flutter_test.dart';
//
//BudgetControl bc;
//Budget b;
//BudgetFactory bFactory;
//Transaction t1 = new Transaction(
//        "Walmart", "Credit card", -21.29, Category.groceries),
//    t2 = new Transaction(
//        "Walmart", "Credit Card", 0.0, Category.groceries),
//    t3 = new Transaction(
//        "KFC", "Credit Card", -5.40, Category.miscellaneous);
//
//void main() {
//  TestWidgetsFlutterBinding.ensureInitialized();
//  group('BudgetControl tests', () {
//    setUp(() {
//      bc = new BudgetControl();
//      bFactory = new PriorityBudgetFactory();
//      b = bFactory.newFromInfo(2500, 710, BudgetType.growth);
//      bc.addNewBudget(b);
//      bc.addTransaction(t1);
//      bc.addTransaction(t2);
//      bc.addTransaction(t3);
//    });
//    test('New BudgetControl will have new user', () async {
//      bc = new BudgetControl();
//      expect(await bc.isReturningUser(), false);
//    });
//    test('Allotments set on added budget', () {
//      expect(bc.getBudget().allotted[Category.housing], 710);
//    });
//    test('Added transactions show up in controller', () {
//      expect(bc.getLoadedTransactions().contains(t1), true);
//    });
//    test('Only one transaction added per call of addTransaction', () {
//      expect(bc.getLoadedTransactions().length, 3);
//    });
//  });
//}
