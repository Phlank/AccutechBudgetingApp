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

  // Creates a new BudgetMap with the default categories
  BudgetMap() {
    CategoryList.defaultCategories.forEach((category) {
      _map[category] = 0.0;
    });
  }

  BudgetMap.from(BudgetMap other) {
    _map = Map.from(other._map);
  }

  BudgetMap.withCategoriesOf(BudgetMap other) {
    other.forEach((category, double) {
      _map[category] = 0.0;
    });
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

  int get hashCode => _map.hashCode;
}
