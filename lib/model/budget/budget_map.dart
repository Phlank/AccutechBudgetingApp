import 'dart:convert';

import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/category/category_list.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class BudgetMap implements Serializable {
  Map<Category, double> _map = new Map();
  String _serialization = "";
  CategoryList _categories;

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

  String get serialize {
    Serializer main = Serializer();
    int i = 0;
    for (Category key in _map.keys) {
      Serializer keySerializer = Serializer();
      keySerializer.addPair(KEY_CATEGORY, key);
      keySerializer.addPair(KEY_AMOUNT, _map[key]);
      main.addPair(i, keySerializer);
      i++;
    }
    return main.serialize;
  }

  static BudgetMap unserialize(String serialized) {
    BudgetMap unserialized = new BudgetMap();
    Map decoded = jsonDecode(serialized);
    // key is a unique integer
    // value is a map from the pattern in _makeSerializable
    // value has two keys, _CATEGORY_KEY and _AMOUNT_KEY
    decoded.forEach((key, value) {
      Category c = Serializer.unserialize(KEY_CATEGORY, value[KEY_CATEGORY]);
      double amount = double.parse(value[KEY_AMOUNT]);
      unserialized.addTo(c, amount);
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
