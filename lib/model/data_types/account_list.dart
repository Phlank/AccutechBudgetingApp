import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/account.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:quiver/collection.dart';

class AccountList extends DelegatingList<Account> implements Serializable {
  List<Account> _list;

  List<Account> get delegate => _list;

  /// An extended list object which adds serialization.
  AccountList() {
    _list = List();
  }

  ///
  ///
  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    for (int i = 0; i < length; i++) {
      serializer.addPair('$i', this[i]);
    }
    return serializer.serialize;
  }

  /// Equality operator.
  ///
  /// Returns [true] if [other] is an instance of [AccountList] and contains the same [Account] objects as this [AccountList].
  bool operator ==(Object other) => other is AccountList && _equals(other);

  bool _equals(AccountList other) {
    if (length != other.length) {
      return false;
    }
    for (Account account in _list) {
      if (!other.contains(account)) {
        return false;
      }
    }
    return true;
  }

  /// The hash code for this object.
  int get hashCode => _list.hashCode;
}
