import 'dart:convert';

import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/category/category_list.dart';
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
    int i = 0;
    for (Category key in _map.keys) {
      _serialization += '"$i":' + _makeSerializable(key);
      if (key != _map.keys.last) _serialization += ',';
      i++;
    }
    _serialization += '}';
    return _serialization;
  }

  String _makeSerializable(Category c) {
    return '{"category":' + c.serialize() + ',"amount":"' + _map[c].toString() + '"}';
  }

  static BudgetMap unserialize(String serialized) {
    BudgetMap unserialized = new BudgetMap();
    _decoded = jsonDecode(serialized);
    // Key is the double, value is the category
    _decoded.forEach((key, value) {
      unserialized.addTo(Category.unserializeMap(value["category"]), double.parse(value["amount"]));
    });
    return unserialized;
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
