import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/transaction.dart';
import 'package:budgetflow/crypt/password.dart';
import 'package:budgetflow/history/history.dart';
import 'package:budgetflow/history/month.dart';

class Stringifier {
  String stringifyBudgetMap(Map<BudgetCategory, double> map) {}

  Map<BudgetCategory, double> unstringifyBudgetMap(String stringMap) {}

  String stringifyTransactionList(List<Transaction> list) {}

  List<Transaction> unstringifyTransactionList(String stringList) {}

  String stringifyHistory(History history) {}

  List<Month> unstringifyHistory(String jsonHistory) {}

  Password unstringifyPassword(String jsonHistory) {}
}
