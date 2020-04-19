import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/account_list.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class AccountListStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    AccountList output = AccountList();
    for (var subvalue in value.values) {
      output.add(Serializer.unserialize(accountKey, subvalue));
    }
    return output;
  }
}
