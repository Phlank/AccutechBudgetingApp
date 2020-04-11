import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/allocation.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class AllocationStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    return Allocation(
      Serializer.unserialize(categoryKey, value[categoryKey]),
      double.parse(value[amountKey].replaceAll('"', '')),
    );
  }
}
