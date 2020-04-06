import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/transaction_list.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class TransactionListStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    TransactionList list = new TransactionList();
    value.values.forEach((subValue) {
      list.add(Serializer.unserialize(transactionKey, subValue));
    });
    return list;
  }
}
