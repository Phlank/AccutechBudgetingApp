import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class CategoryStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    var name = value[KEY_NAME];
    var priority = Serializer.unserialize(KEY_PRIORITY, value[KEY_PRIORITY]);
    return Category(name, priority);
  }
}
