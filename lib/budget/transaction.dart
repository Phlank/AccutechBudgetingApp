import 'package:budgetflow/budget/budget_category.dart';

class Transaction {
  DateTime datetime;
  String vendorName;
  String method;
  double delta;
  BudgetCategory category;
}
