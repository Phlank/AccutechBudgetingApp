import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:quiver/collection.dart';

class TransactionList extends DelegatingList<Transaction>
    implements Serializable {
  List<Transaction> _list;

  List<Transaction> get delegate => _list;

  TransactionList() {
    _list = new List();
  }

  // Makes a copy of a list, but does not make copies of the list elements.
  TransactionList.copy(TransactionList other) {
    _list = new List();
    for (int i = 0; i < other.length; i++) {
      _list.add(other[i]);
    }
  }

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    for (int i = 0; i < _list.length; i++) {
      serializer.addPair(i, _list[i]);
    }
    return serializer.serialize;
  }

  bool operator ==(Object other) => other is TransactionList && _equals(other);

  bool _equals(TransactionList other) {
    if (this.length != other.length) return false;
    for (int i = 0; i < this.length; i++) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }

  int get hashCode => _list.hashCode;
}
