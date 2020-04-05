import 'package:budgetflow/model/data_types/allocation_list.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class AllocationListStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    AllocationList list = AllocationList([]);
    value.forEach((key, value) {
      list.add(Serializer.unserialize(allocationKey, value));
    });
    return list;
  }
}
