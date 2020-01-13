import 'package:budgetflow/budget/budget.dart';
import 'package:budgetflow/budget/budget_creator_interface.dart';
import 'package:budgetflow/budget/budget_factory.dart';
import 'package:flutter_test/flutter_test.dart';

Budget budget = new Budget(1500);
budgetCreator budgetcreator = new budgetCreator();

void main(){
  //TODO develop tests for categorize budget, setbudgetgrowthratio, setbudgetdepletionratio
  group("Budget Functions", (){
    setUp(() {});
    test("Recieve monthly budget into the Budget Creator", () {
      double inputbudget = budget.getMonthlyIncome();
      double sa = budgetcreator.setIncome();
      expect(inputbudget, equals(sa));
    });

    test("Inital Budget recieved", (){
      Type sa  = budgetcreator.budget.getMonthlyIncome() as Type;
      expect(sa, equals(1500));
    });
  });
}