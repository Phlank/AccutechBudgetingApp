import 'dart:convert';

import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/category/category_list.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:quiver/collection.dart';

class BudgetMap extends DelegatingMap<Category, double>
    implements Serializable {
  Map<Category, double> _map = {};

  Map<Category, double> get delegate => _map;

  String _serialization = "";
  CategoryList _categories;

  BudgetMap() {
    _categories = CategoryList();
    _categories.forEach((Category c) {
      _map[c] = 0;
    });
  }

  BudgetMap.from(BudgetMap other) {
    _map = Map.from(other._map);
  }

  String get serialize {
    Serializer main = Serializer();
    int i = 0;
    _map.forEach((category, amount) {
      Serializer keySerializer = Serializer();
      keySerializer.addPair(categoryKey, category);
      keySerializer.addPair(amountKey, amount);
      main.addPair(i, keySerializer);
      i++;
    });
    return main.serialize;
  }

  // TODO move to an unserializer strategy
  static BudgetMap unserialize(String serialized) {
    BudgetMap unserialized = new BudgetMap();
    Map decoded = jsonDecode(serialized);
    // key is a unique integer
    // value is a map from the pattern in _makeSerializable
    // value has two keys, _CATEGORY_KEY and _AMOUNT_KEY
    decoded.forEach((key, value) {
      Category c = Serializer.unserialize(categoryKey, value[categoryKey]);
      double amount = double.parse(value[amountKey]);
      unserialized[c] += amount;
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

  bool operator ==(Object other) => other is BudgetMap && this._equals(other);

  bool _equals(BudgetMap other) {
    bool output = true;
    this.forEach((category, amount) {
      if (this[category] != other[category]) {
        output = false;
      }
    });
    return output;
  }
}
