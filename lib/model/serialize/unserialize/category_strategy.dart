import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class CategoryStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    var name = value[nameKey];
    var priority = Serializer.unserialize(priorityKey, value[priorityKey]);
    return Category(name, priority);
  }
}
