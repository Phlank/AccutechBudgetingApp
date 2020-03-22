import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class BudgetMapStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    BudgetMap unserialized = BudgetMap();
    // key is a unique integer
    // value is a map from the pattern in _makeSerializable
    // value has two keys, _CATEGORY_KEY and _AMOUNT_KEY
    value.forEach((key, value) {
      Category category = Serializer.unserialize(
        categoryKey,
        value[categoryKey],
      );
      double amount = double.parse(value[amountKey]);
      unserialized[category] += amount;
    });
    return unserialized;
  }
}
