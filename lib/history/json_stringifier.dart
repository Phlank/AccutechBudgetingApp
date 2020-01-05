import 'package:budgetflow/budget/budget_category.dart';

class JSONStringifier {

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

  static Map<BudgetCategory, String> _budgetCategoryStrings;

  JSONStringifier() {
    _populateMaps();
  }

  void _populateMaps() {
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

  String getJSONString(BudgetCategory c) {}
}
