import 'package:budgetflow/budget/budget.dart';
import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/transaction.dart';
import 'package:budgetflow/crypt/password.dart';
import 'package:budgetflow/history/history.dart';
import 'package:budgetflow/history/month.dart';
import 'package:budgetflow/history/stringifier.dart';

class JSONStringifier implements Stringifier {
  static const String _HOUSING = "Housing";
  static const String _UTILITIES = "Utilities";
  static const String _GROCERIES = "Groceries";
  static const String _SAVINGS = "Savings";
  static const String _HEALTH = "Health";
  static const String _TRANSPORTATION = "Transportation";
  static const String _EDUCATION = "Education";
  static const String _ENTERTAINMENT = "Entertainment";
  static const String _KIDS = "Kids";
  static const String _PETS = "Pets";
  static const String _MISCELLANEOUS = "Housing";

  Map<BudgetCategory, String> _budgetCategoryStrings;

  JSONStringifier() {
    _populateBudgetMap();
  }

  void _populateBudgetMap() {
    _budgetCategoryStrings[BudgetCategory.housing] = _HOUSING;
    _budgetCategoryStrings[BudgetCategory.utilities] = _UTILITIES;
    _budgetCategoryStrings[BudgetCategory.groceries] = _GROCERIES;
    _budgetCategoryStrings[BudgetCategory.savings] = _SAVINGS;
    _budgetCategoryStrings[BudgetCategory.health] = _HEALTH;
    _budgetCategoryStrings[BudgetCategory.transportation] = _TRANSPORTATION;
    _budgetCategoryStrings[BudgetCategory.education] = _EDUCATION;
    _budgetCategoryStrings[BudgetCategory.entertainment] = _ENTERTAINMENT;
    _budgetCategoryStrings[BudgetCategory.kids] = _KIDS;
    _budgetCategoryStrings[BudgetCategory.pets] = _PETS;
    _budgetCategoryStrings[BudgetCategory.miscellaneous] = _MISCELLANEOUS;
  }

  String stringifyBudgetMap(Map<BudgetCategory, double> map) {}

  Map<BudgetCategory, double> unstringifyBudgetMap(String jsonMap) {
    // TODO implement this
    return null;
  }

  String stringifyTransactionList(List<Transaction> list) {
    // TODO implement this
    return null;
  }

  List<Transaction> unstringifyTransactionList(String jsonList) {
    // TODO implement this
    return null;
  }

  String stringifyHistory(History history) {
    // TODO implement this
    return null;
  }

  List<Month> unstringifyHistory(String jsonHistory) {
    // TODO implement this
    return null;
  }

  Password unstringifyPassword(String jsonHistory) {
    // TODO implement this
    return null;
  }
}
