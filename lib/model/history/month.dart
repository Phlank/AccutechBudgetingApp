import 'dart:convert';

import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/crypt/encrypted.dart';
import 'package:budgetflow/model/file_io/serializable.dart';
import 'package:budgetflow/model/history/month_time.dart';

class Month implements Serializable {
  String _allottedFilepath, _actualFilepath, _transactionFilepath;
  BudgetMap _allottedData, _actualData;
  TransactionList _transactionData;
  MonthTime _monthTime;
  double _income;
  BudgetType type;

  Month(MonthTime mt, double income) {
    _monthTime = mt;
    this._income = income;
    _createFilePaths();
  }

  void _createFilePaths() {
    _allottedFilepath = _monthTime.getFilePathString() + "_allotted";
    _actualFilepath = _monthTime.getFilePathString() + "_actual";
    _transactionFilepath = _monthTime.getFilePathString() + "_transactions";
  }

  BudgetMap getAllottedSpendingData() {
    if (_allottedData == null) {
      loadAllottedSpendingData();
    }
    return _allottedData;
  }

  void loadAllottedSpendingData() async {
    Encrypted e = Encrypted.unserialize(await BudgetControl.fileIO.readFile(_allottedFilepath));
    String plaintext = BudgetControl.crypter.decrypt(e);
    _allottedData = BudgetMap.unserialize(plaintext);
  }

  BudgetMap getActualSpendingData() {
    if (_actualData == null) {
      loadActualSpendingData();
    }
    return _actualData;
  }

  void loadActualSpendingData() async {
    Encrypted e = Encrypted.unserialize(await BudgetControl.fileIO.readFile(_actualFilepath));
    String plaintext = BudgetControl.crypter.decrypt(e);
    _actualData = BudgetMap.unserialize(plaintext);
  }

  TransactionList getTransactionData() {
    if (_transactionData == null) {
      loadTransactionData();
    }
    return _transactionData;
  }

  void loadTransactionData() async {
    Encrypted e = Encrypted.unserialize(await BudgetControl.fileIO.readFile(_transactionFilepath));
    String plaintext = BudgetControl.crypter.decrypt(e);
    _transactionData = TransactionList.unserialize(plaintext);
  }

  void updateMonthData(Budget budget) {
    _allottedData = budget.allottedSpending;
    _actualData = budget.actualSpending;
    _transactionData = budget.transactions;
    type = budget.getType();
  }

  void save() {
    _saveAllottedSpending();
    _saveActualSpending();
    _saveTransactions();
  }

  void _saveAllottedSpending() {
    if (_allottedData != null) {
      String content = _allottedData.serialize();
      Encrypted e = BudgetControl.crypter.encrypt(content);
      BudgetControl.fileIO.writeFile(_allottedFilepath, e.serialize());
    }
  }

  void _saveActualSpending() {
    if (_actualData != null) {
      String content = _actualData.serialize();
      Encrypted e = BudgetControl.crypter.encrypt(content);
      BudgetControl.fileIO.writeFile(_actualFilepath, e.serialize());
    }
  }

  void _saveTransactions() {
    if (_transactionData != null) {
      String content = _transactionData.serialize();
      Encrypted e = BudgetControl.crypter.encrypt(content);
      BudgetControl.fileIO.writeFile(_transactionFilepath, e.serialize());
    }
  }

  MonthTime getMonthTime() => _monthTime;

  double getIncome() => _income;

  static Month fromBudget(Budget b) {
    Month m = new Month(MonthTime.now(), b.getMonthlyIncome());
    m._transactionData = b.transactions;
    m._actualData = b.actualSpending;
    m._allottedData = b.allottedSpending;
    m.type = b.getType();
    m._createFilePaths();
    return m;
  }

  String serialize() {
    String output = "{";
    output += '"year":"' + _monthTime.year.toString() + "\",";
    output += '"month":"' + _monthTime.month.toString() + '",';
    output += '"income":"' + _income.toString() + '",';
    output += '"type":"' + budgetTypeJson[type] + '"';
    output += '}';
    return output;
  }

  static unserialize(String serialization) {
    Map map = jsonDecode(serialization);
    return unserializeMap(map);
  }

  static unserializeMap(Map map) {
    Month m = new Month(new MonthTime(int.parse(map["year"]), int.parse(map["month"])),
        double.parse(map["income"]));
    m.type = jsonBudgetType[map["type"]];
    return m;
  }
}
