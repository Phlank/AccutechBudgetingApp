import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class TransactionListStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    TransactionList list = new TransactionList();
    value.values.forEach((subValue) {
      list.add(Serializer.unserialize((KEY_TRANSACTION), subValue));
    });
    return list;
  }
}
