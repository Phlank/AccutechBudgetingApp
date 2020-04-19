import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/account.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class AccountStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    return Account(
      methodName: value[methodNameKey],
      accountName: value[accountNameKey],
      accountTransactions:
      Serializer.unserialize(transactionListKey, value[transactionListKey]),
      amount: double.parse(value[amountKey]),
      beginning:
      DateTime.tryParse(value[beginningKey]),
    );
  }
}
