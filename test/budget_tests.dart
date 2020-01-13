import 'package:budgetflow/budget/budget.dart';
import 'package:budgetflow/budget/budget_creator_interface.dart';
import 'package:flutter_test/flutter_test.dart';

Budget budget = new Budget(1500);
BudgetCreator budgetcreator = new BudgetCreator();

void main() {
  //TODO develop tests for categorize budget, setbudgetgrowthratio, setbudgetdepletionratio
  group("Budget Functions", () {
    setUp(() {});
    test("Recieve monthly budget into the Budget Creator", () {
    });

    test("Inital Budget recieved", () {
    });
  });
}
