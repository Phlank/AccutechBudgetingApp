import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/month.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class MonthStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    return Month(
      type: Serializer.unserialize(typeKey, value[typeKey]),
      income: double.parse(value[incomeKey]),
      time: DateTime.fromMillisecondsSinceEpoch(value[timeKey]),
      allotted: Serializer.unserialize(allocationListKey, value[allottedKey]),
      actual: Serializer.unserialize(allocationListKey, value[actualKey]),
      target: Serializer.unserialize(allocationListKey, value[targetKey]),
      transactions:
      Serializer.unserialize(transactionListKey, value[transactionsKey]),
    );
  }
}
