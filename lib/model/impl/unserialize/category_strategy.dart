import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class CategoryStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    var name = value[nameKey];
    var priority = Serializer.unserialize(priorityKey, value[priorityKey]);
    return Category(name, priority);
  }
}
