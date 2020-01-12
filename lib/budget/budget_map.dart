import 'package:budgetflow/budget/budget_category.dart';

class BudgetMap {
  Map<BudgetCategory, double> _map;
  String _serialization;

  BudgetMap() {
    for (BudgetCategory category in BudgetCategory.values) {
      _map[category] = 0.0;
    }
  }

  double valueOf(BudgetCategory category) {
    return _map[category];
  }

  double addTo(BudgetCategory category, double amt) {
    _map[category] += amt;
    return _map[category];
  }

  String serialize() {
    _serialization = "{";
    _map.forEach(_makeSerializable);
    return _serialization;
  }

  void _makeSerializable(BudgetCategory c, double d) {
    _serialization +=
        "\"" + categoryJsonStrings[c] + "\":\"" + d.toString() + "\"";
    if (!(c == BudgetCategory.miscellaneous)) {
      _serialization += ",";
    }
  }
}
