import 'dart:convert';

import 'package:budgetflow/budget/budget_map.dart';
import 'package:budgetflow/budget/transaction.dart';
import 'package:budgetflow/budget/transaction_list.dart';
import 'package:budgetflow/crypt/encrypted.dart';
import 'package:budgetflow/fileio/serializable.dart';
import 'package:budgetflow/history/history.dart';
import 'package:budgetflow/history/json_stringifier.dart';
import 'package:budgetflow/history/stringifier.dart';

class Month implements Serializable {
  String _allottedFilepath, _actualFilepath, _transactionFilepath;
  BudgetMap allottedData;
  BudgetMap actualData;
  List<Transaction> transactionData;
  int year, month;

  Month(int year, int month) {
    this.year = year;
    this.month = month;
    _createFilePaths();
  }

  void _createFilePaths() {
    _allottedFilepath = "$year" + "_" + "$month" + "_allotted";
    _actualFilepath = "$year" + "_" + "$month" + "_actual";
    _transactionFilepath = "$year" + "_" + "$month" + "_transactions";
  }

  BudgetMap getAllottedSpendingData() {
    if (allottedData == null) {
      _loadBudgetData();
    }
    return allottedData;
  }

  BudgetMap getActualSpendingData() {
    if (actualData == null) {
      _loadBudgetData();
    }
    return actualData;
  }

  void _loadBudgetData() {
    History.fileIO.readFile(_allottedFilepath).then((String cipher) {
      String plaintext = History.crypter.decrypt(Encrypted.fromFileContent(cipher));
      allottedData = BudgetMap.unserialize(plaintext);
    });
    History.fileIO.readFile(_actualFilepath).then((String cipher) {
      String plaintext = History.crypter.decrypt(Encrypted.fromFileContent(cipher));
      actualData = BudgetMap.unserialize(plaintext);
    });
  }

  TransactionList getTransactionData()  {
    // TODO finish this
    if (transactionData == null) {
      // If the data has not been loaded, load it
      History.fileIO.readFile(_transactionFilepath).then((String cipher) {
        String plaintext = History.crypter.decrypt(Encrypted.fromFileContent(cipher));
        TransactionList t = TransactionList.unserialize(plaintext);
        return t;
      });
    }
    return null;
  }

  void updateMonthData(BudgetMap allotted, BudgetMap actual, List<Transaction> transactions) {
    allottedData = allotted;
    actualData = actual;
    transactionData = transactions;
  }

  void writeMonth() {
    writeAllotted();
    writeActual();
    writeTransactions();
  }

  void writeAllotted() {
    // TODO implement this
  }

  void writeActual() {
    // TODO implement this
  }

  void writeTransactions() {
    // TODO implement this
  }

  String serialize() {
    String output = "{";
    output += "\"year\":\"" + year.toString() + "\",";
    output += "\"month\":\"" + month.toString() + "\"";
    output += "}";
    return output;
  }

  static unserialize(String serialization) {
    Map map = jsonDecode(serialization);
    return unserializeMap(map);
  }

  static unserializeMap(Map map) {
    Month m = new Month(int.parse(map["year"]), int.parse(map["month"]));
    return m;
  }
}
