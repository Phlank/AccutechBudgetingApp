import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/allocation_list.dart';
import 'package:budgetflow/model/utils/serializer.dart';

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
