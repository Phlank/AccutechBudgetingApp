import 'package:budgetflow/model/data_types/priority.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class PriorityStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    var name = value[nameKey];
    return Priority.fromName(name);
  }
}
