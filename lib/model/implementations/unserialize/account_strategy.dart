import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/account.dart';

class AccountStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    return Account(
      methodName: value[methodNameKey],
      accountName: value[accountNameKey],
      beginning: DateTime.tryParse(value[beginningKey]),
    );
  }
}
