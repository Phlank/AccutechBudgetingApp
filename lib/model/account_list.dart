import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/account.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:quiver/collection.dart';

class AccountList extends DelegatingList<Account> implements Serializable {
  List<Account> _list;

  List<Account> get delegate => _list;

  String get serialize {
    Serializer serializer = Serializer();
    for (int i = 0; i < length; i++) {
      serializer.addPair('$i', this[i]);
    }
    return null;
  }

  bool operator ==(Object other) => other is AccountList && _equals(other);

  bool _equals(AccountList other) {
    bool output = true;
    if (length != other.length) return false;
    _list.forEach((account) {
      if (other.contains(account)) {
        output = false;
        return; // Exit the local forEach function
      }
    });
    return output;
  }

  int get hashCode => _list.hashCode;
}
