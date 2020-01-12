import 'package:budgetflow/budget/budget_category.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class BudgetMap {
  Map<BudgetCategory, double> _map;

  BudgetMap empty() {
    for (BudgetCategory category in BudgetCategory.values) {
      _map[category] = 0.0;
    }
  }

  void addTo(BudgetCategory category, double amt) {
    _map[category] += amt;
  }
}
