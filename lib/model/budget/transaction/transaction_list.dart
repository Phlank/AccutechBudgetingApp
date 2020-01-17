import 'dart:convert';

import 'package:budgetflow/model/budget/transaction/transaction.dart';

class TransactionList {
  List<Transaction> _transactions;

  TransactionList() {
    _transactions = new List();
  }

  void add(Transaction t) {
    _transactions.add(t);
  }

  int length() {
    return _transactions.length;
  }

  void removeAt(int index) {
    _transactions.removeAt(index);
  }

  Transaction getAt(int index) {
    return _transactions[index];
  }

  String serialize() {
    String output = '{';
    for (int i = 0; i < _transactions.length; i++) {
      output += '"' + i.toString() + '":';
      output += _transactions[i].serialize();
      if (i != _transactions.length - 1) {
        output += ',';
      }
    }
    output += '}';
    return output;
  }

  static TransactionList unserialize(String serialized) {
    Map map = jsonDecode(serialized);
    TransactionList t = new TransactionList();
    map.forEach((dynamic s, dynamic d) {
      t._transactions.add(Transaction.unserializeMap(d));
    });
    return t;
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
}
