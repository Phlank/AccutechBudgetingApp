import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/transaction.dart';

class Stringifier {
  String stringifyBudgetMap(Map<BudgetCategory, double> map) {}

  Map<BudgetCategory, double> unstringifyBudgetMap(String stringMap) {}

  String stringifyTransactionList(List<Transaction> list) {}

  List<Transaction> unstringifyTransactionList(String stringList) {}
}
