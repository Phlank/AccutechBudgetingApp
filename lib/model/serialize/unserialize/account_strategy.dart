import 'package:budgetflow/model/account.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class AccountStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    // TODO: implement unserializeValue
    return Account(
      methodName: value[methodNameKey],
      accountName: value[accountNameKey],
      accountTransactions:
          Serializer.unserialize(transactionListKey, value[transactionListKey]),
      amount: double.parse(value[amountKey]),
      beginning:
          DateTime.fromMillisecondsSinceEpoch(int.parse(value[beginningKey])),
    );
    return null;
  }
}