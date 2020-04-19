import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/priority.dart';
class PriorityStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    var name = value[nameKey];
    return Priority.fromName(name);
  }
}
