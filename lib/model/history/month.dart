import 'dart:convert';

import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/crypt/encrypted.dart';
import 'package:budgetflow/model/file_io/serializable.dart';

class Month implements Serializable {
  String _allottedFilepath, _actualFilepath, _transactionFilepath;
  BudgetMap allottedData, actualData;
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
      loadAllottedSpendingData();
    }
    return allottedData;
  }

  void loadAllottedSpendingData() {
    BudgetControl.fileIO.readFile(_allottedFilepath).then((String cipher) {
      Encrypted e = Encrypted.unserialize(cipher);
      String plaintext = BudgetControl.crypter.decrypt(e);
      allottedData = BudgetMap.unserialize(plaintext);
    });
  }

  BudgetMap getActualSpendingData() {
    if (actualData == null) {
      loadActualSpendingData();
    }
    return actualData;
  }

  void loadActualSpendingData() {
    BudgetControl.fileIO.readFile(_actualFilepath).then((String cipher) {
      Encrypted e = Encrypted.unserialize(cipher);
      String plaintext = BudgetControl.crypter.decrypt(e);
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
    BudgetControl.fileIO.readFile(_transactionFilepath).then((String cipher) {
      Encrypted e = Encrypted.unserialize(cipher);
      String plaintext = BudgetControl.crypter.decrypt(e);
      transactionData = TransactionList.unserialize(plaintext);
    });
  }

  void updateMonthData(Budget budget) {
    allottedData = budget.allottedSpending;
    actualData = budget.actualSpending;
    transactionData = budget.transactions;
  }

  void save() {
    _saveAllottedSpending();
    _saveActualSpending();
    _saveTransactions();
  }

  void _saveAllottedSpending() {
    if (allottedData != null) {
      String content = allottedData.serialize();
      Encrypted e = BudgetControl.crypter.encrypt(content);
      BudgetControl.fileIO.writeFile(_allottedFilepath, e.serialize());
    }
  }

  void _saveActualSpending() {
    if (actualData != null) {
      String content = actualData.serialize();
      Encrypted e = BudgetControl.crypter.encrypt(content);
      BudgetControl.fileIO.writeFile(_actualFilepath, e.serialize());
    }
  }

  void _saveTransactions() {
    if (transactionData != null) {
      String content = transactionData.serialize();
      Encrypted e = BudgetControl.crypter.encrypt(content);
      BudgetControl.fileIO.writeFile(_transactionFilepath, e.serialize());
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
    output += "\"type\":\"" + budgetTypeJson[type] + "\"";
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
    m.type = jsonBudgetType[map["type"]];
    return m;
  }

  bool equals(Month m) {
    return year == m.year && month == m.month;
  }
}
