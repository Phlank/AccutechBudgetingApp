import 'dart:convert';

import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/file_io/serializable.dart';

class BudgetMap implements Serializable {
  Map<BudgetCategory, double> _map = new Map();
  String _serialization = "";
  static BudgetMap _unserialized;
  static Map _decoded;

  BudgetMap() {
    for (BudgetCategory category in BudgetCategory.values) {
      _map[category] = 0.0;
    }
  }

  BudgetMap.copyOf(BudgetMap toCopy) {
    _map = new Map();
    for (BudgetCategory category in BudgetCategory.values) {
      _map[category] = toCopy[category];
    }
  }

  double addTo(BudgetCategory category, double amt) {
    _map[category] += amt;
    return _map[category];
  }

  void forEach(void action(BudgetCategory c, double d)) {
    _map.forEach(action);
  }

  String serialize() {
    _serialization = '{';
    _map.forEach(_makeSerializable);
    _serialization += '}';
    return _serialization;
  }

  void _makeSerializable(BudgetCategory c, double d) {
    _serialization += '"' + categoryJson[c] + '":"' + d.toString() + '"';
    if (!(c == BudgetCategory.miscellaneous)) {
      _serialization += ',';
    }
  }

  static BudgetMap unserialize(String serialized) {
    _unserialized = new BudgetMap();
    _decoded = jsonDecode(serialized);
    _decoded.forEach(_convertDecoded);
    return _unserialized;
  }

  static _convertDecoded(dynamic s, dynamic d) {
    _unserialized.addTo(jsonCategory[s], double.parse(d));
  }

  BudgetMap divide(double n) {
    BudgetMap newBudgetMap = new BudgetMap();
    _map.forEach((BudgetCategory bc, double d) {
      newBudgetMap[bc] = d / n;
    });
    return newBudgetMap;
  }

  operator [](BudgetCategory i) => _map[i];

  operator []=(BudgetCategory i, double value) => _map[i] = value;

  operator ==(Object other) => other is BudgetMap && this._equals(other);

  bool _equals(BudgetMap other) {
    for (BudgetCategory c in BudgetCategory.values) {
      if (other[c] != this[c]) {
        return false;
      }
    }
    return true;
  }

  int get hashCode => _map.hashCode ^ _serialization.hashCode;
}
