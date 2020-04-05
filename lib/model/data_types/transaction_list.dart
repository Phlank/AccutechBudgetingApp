import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class TransactionList implements Serializable {
  List<Transaction> _transactions;

  TransactionList() {
    _transactions = new List();
  }

  // Makes a copy of a list, but does not make copies of the list elements.
  TransactionList.copy(TransactionList other) {
    _transactions = new List();
    for (int i = 0; i < other.length; i++) {
      _transactions.add(other[i]);
    }
  }

  void add(Transaction t) {
    _transactions.add(t);
  }

  int get length => _transactions.length;

  void removeAt(int index) {
    _transactions.removeAt(index);
  }

  Transaction getAt(int index) {
    return _transactions[index];
  }

  String get serialize {
    Serializer serializer = Serializer();
    for (int i = 0; i < _transactions.length; i++) {
      serializer.addPair(i, _transactions[i]);
    }
    return serializer.serialize;
  }

  List<Transaction> getIterable() {
    return _transactions;
  }

  void forEach(void action(Transaction t)) {
    int length = _transactions.length;
    for (int i = 0; i < length; i++) {
      action(_transactions[i]);
      if (length != _transactions.length) {
        throw ConcurrentModificationError(this);
      }
    }
  }

  bool contains(Transaction t) => _transactions.contains(t);

  void remove(Transaction t) => _transactions.remove(t);

  Transaction operator [](int i) => _transactions[i];

  bool operator ==(Object other) =>
      other is TransactionList && this._equals(other);

  bool _equals(TransactionList other) {
    if (this.length != other.length) return false;
    for (int i = 0; i < this.length; i++) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }

  int get hashCode => _transactions.hashCode;
}
