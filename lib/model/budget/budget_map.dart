import 'dart:convert';

import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/file_io/serializable.dart';

class BudgetMap implements Serializable {
  Map<BudgetCategory, double> _map;
  String _serialization;
  static BudgetMap _deserialized;
  static Map _decoded;

  BudgetMap() {
    _map = new Map();
    for (BudgetCategory category in BudgetCategory.values) {
      _map[category] = 0.0;
    }
  }

  double valueOf(BudgetCategory category) {
    return _map[category];
  }

  double set(BudgetCategory category, double amt) {
    _map[category] = amt;
  }

  double addTo(BudgetCategory category, double amt) {
    _map[category] += amt;
    return _map[category];
  }

  String serialize() {
    _serialization = "{";
    _map.forEach(_makeSerializable);
    _serialization += "}";
    return _serialization;
  }

  void _makeSerializable(BudgetCategory c, double d) {
    _serialization += "\"" + categoryJson[c] + "\":\"" + d.toString() + "\"";
    if (!(c == BudgetCategory.miscellaneous)) {
      _serialization += ",";
    }
  }

  static BudgetMap unserialize(String serialized) {
    _deserialized = new BudgetMap();
    _decoded = jsonDecode(serialized);
    _decoded.forEach(_convertDecoded);
    return _deserialized;
  }

  static _convertDecoded(dynamic s, dynamic d) {
    _deserialized.addTo(jsonCategory[s], double.parse(d));
  }

  BudgetMap divide(double n) {
    BudgetMap newBudgetMap = new BudgetMap();
    _map.forEach((BudgetCategory bc, double d) {
      newBudgetMap.set(bc, d / n);
    });
    return newBudgetMap;
  }
}
