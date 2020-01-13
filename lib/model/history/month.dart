import 'dart:convert';

import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/crypt/encrypted.dart';
import 'package:budgetflow/model/fileio/serializable.dart';
import 'package:budgetflow/model/history/history.dart';

class Month implements Serializable {
  String _allottedFilepath, _actualFilepath, _transactionFilepath;
  BudgetMap allottedData;
  BudgetMap actualData;
  TransactionList transactionData;
  int year, month;
  double income;
  BudgetType type;

  Month(int year, int month, double income) {
    this.year = year;
    this.month = month;
    this.income = income;
    _createFilePaths();
  }

  void _createFilePaths() {
    _allottedFilepath = "$year" + "_" + "$month" + "_allotted";
    _actualFilepath = "$year" + "_" + "$month" + "_actual";
    _transactionFilepath = "$year" + "_" + "$month" + "_transactions";
  }

  BudgetMap getAllottedSpendingData() {
    if (allottedData == null) {
      loadBudgetData();
    }
    return allottedData;
  }

  BudgetMap getActualSpendingData() {
    if (actualData == null) {
      loadBudgetData();
    }
    return actualData;
  }

  void loadBudgetData() {
    History.fileIO.readFile(_allottedFilepath).then((String cipher) {
      String plaintext = History.crypter.decrypt(Encrypted.unserialize(cipher));
      allottedData = BudgetMap.unserialize(plaintext);
    });
    History.fileIO.readFile(_actualFilepath).then((String cipher) {
      String plaintext = History.crypter.decrypt(Encrypted.unserialize(cipher));
      actualData = BudgetMap.unserialize(plaintext);
    });
  }

  TransactionList getTransactionData() {
    if (transactionData == null) {
      loadTransactionData();
    }
    return transactionData;
  }

  void loadTransactionData() {
    if (transactionData == null) {
      // If the data has not been loaded, load it
      History.fileIO.readFile(_transactionFilepath).then((String cipher) {
        String plaintext =
        History.crypter.decrypt(Encrypted.unserialize(cipher));
        transactionData = TransactionList.unserialize(plaintext);
      });
    }
  }

  void updateMonthData(BudgetMap allotted, BudgetMap actual,
      TransactionList transactions) {
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
    if (allottedData != null) {
      History.fileIO.writeFile(_allottedFilepath,
          History.crypter.encrypt(allottedData.serialize()).serialize());
    }
  }

  void writeActual() {
    if (actualData != null) {
      History.fileIO.writeFile(_actualFilepath,
          History.crypter.encrypt(actualData.serialize()).serialize());
    }
  }

  void writeTransactions() {
    if (transactionData != null) {
      History.fileIO.writeFile(_transactionFilepath,
          History.crypter.encrypt(transactionData.serialize()).serialize());
    }
  }

  static Month fromBudget(Budget b) {
    DateTime now = DateTime.now();
    Month m = new Month(now.year, now.month, b.getMonthlyIncome());
    m.transactionData = b.transactions;
    m.actualData = b.actualSpending;
    m.allottedData = b.allottedSpending;
    m._createFilePaths();
  }

  String serialize() {
    String output = "{";
    output += "\"year\":\"" + year.toString() + "\",";
    output += "\"month\":\"" + month.toString() + "\",";
    output += "\"income\":\"" + income.toString() + "\",";
    output += "\"type\":\"" + typeJson[type] + "\"";
    output += "}";
    return output;
  }

  static unserialize(String serialization) {
    Map map = jsonDecode(serialization);
    return unserializeMap(map);
  }

  static unserializeMap(Map map) {
    Month m = new Month(int.parse(map["year"]), int.parse(map["month"]),
        double.parse(map["income"]));
    m.type = jsonType[map["type"]];
    return m;
  }

  bool equals(Month m) {
    return year == m.year && month == m.month;
  }
}
