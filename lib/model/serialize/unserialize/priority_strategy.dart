import 'package:budgetflow/model/budget/category/priority.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class PriorityStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    var name = value[nameKey];
    return Priority.fromName(name);
  }
}
