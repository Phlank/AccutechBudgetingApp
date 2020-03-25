import 'package:budgetflow/model/budget/allocation.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class AllocationStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    return Allocation(
      Serializer.unserialize(categoryKey, value[categoryKey]),
      double.parse(value[amountKey].replaceAll('"', '')),
    );
  }
}
