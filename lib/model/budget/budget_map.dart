import 'dart:convert';

import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/file_io/serializable.dart';

class BudgetMap implements Serializable {

  Map<Category, double> _map = new Map();
  String _serialization = "";
  CategoryList _categories;
  static Map _decoded;

  BudgetMap() {
    _categories = CategoryList();
    _categories.forEach((Category c) {
      _map[c] = 0;
    });
  }

  BudgetMap.copyOf(BudgetMap toCopy) {
    _map = new Map();
    _categories = toCopy._categories;
    _categories.forEach((Category c) {
      _map[c] = toCopy[c];
    });
  }

  double addTo(Category category, double amt) {
    _map[category] += amt;
    return _map[category];
  }

  void forEach(void action(Category c, double d)) {
    _map.forEach(action);
  }

  String serialize() {
    _serialization = '{';
    _map.forEach(_makeSerializable);
    _serialization += '}';
    return _serialization;
  }

  void _makeSerializable(Category c, double d) {
    _serialization += '"' + c.name + '":"' + d.toString() + '"';
    if (!(c == Category.miscellaneous)) {
      _serialization += ',';
    }
  }

  static BudgetMap unserialize(String serialized) {
    BudgetMap _unserialized = new BudgetMap();
    _decoded = jsonDecode(serialized);
    _decoded.forEach((k, v) {

    });
    return _unserialized;
  }

  BudgetMap divide(double n) {
    BudgetMap newBudgetMap = new BudgetMap();
    _map.forEach((Category bc, double d) {
      newBudgetMap[bc] = d / n;
    });
    return newBudgetMap;
  }

  operator [](Category i) => _map[i];

  operator []=(Category i, double value) => _map[i] = value;

  operator ==(Object other) => other is BudgetMap && this._equals(other);

  bool _equals(BudgetMap other) {
    bool result = true;
    _map.forEach((Category key, double value) {
      if (!(other._categories.contains(key) && other[key] == value))
        result = false;
    });
    return result;
  }

  int get hashCode => _map.hashCode ^ _serialization.hashCode;
}
