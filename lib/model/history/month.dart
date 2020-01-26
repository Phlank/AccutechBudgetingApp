import 'dart:convert';

import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/crypt/encrypted.dart';
import 'package:budgetflow/model/file_io/serializable.dart';
import 'package:budgetflow/model/history/month_time.dart';

class MonthBuilder {
  MonthTime _monthTime;
  double _income;
  BudgetType _type;
  BudgetMap _allotted, _actual;
  TransactionList _transactions;

  MonthBuilder();

  void setMonthTime(MonthTime monthTime) {
    _monthTime = monthTime;
  }

  void setIncome(double income) {
    _income = income;
  }

  void setType(BudgetType type) {
    _type = type;
  }

  void setAllotted(BudgetMap allotted) {
    _allotted = allotted;
  }

  void setActual(BudgetMap actual) {
    _actual = actual;
  }

  void setTransactions(TransactionList transactions) {
    _transactions = transactions;
  }

  Month build() {
    if (_monthTime == null) throw new NullThrownError();
    if (_monthTime == null) throw new NullThrownError();
    if (_monthTime == null) throw new NullThrownError();
    if (_monthTime == null) throw new NullThrownError();
    if (_monthTime == null) throw new NullThrownError();
    if (_monthTime == null) throw new NullThrownError();
    if (_monthTime == null) throw new NullThrownError();
  }
}

class Month implements Serializable {
  String _allottedFilepath, _actualFilepath, _transactionsFilepath;
  BudgetMap _allotted, _actual;
  TransactionList _transactions;
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
    _transactionsFilepath = _monthTime.getFilePathString() + "_transactions";
  }

  BudgetMap getAllottedSpendingData() {
    if (_allotted == null) {
      loadAllottedSpendingData();
    }
    return _allotted;
  }

  void loadAllottedSpendingData() async {
    Encrypted e = Encrypted.unserialize(
        await BudgetControl.fileIO.readFile(_allottedFilepath));
    String plaintext = BudgetControl.crypter.decrypt(e);
    _allotted = BudgetMap.unserialize(plaintext);
  }

  BudgetMap getActualSpendingData() {
    if (_actual == null) {
      loadActualSpendingData();
    }
    return _actual;
  }

  void loadActualSpendingData() async {
    Encrypted e = Encrypted.unserialize(
        await BudgetControl.fileIO.readFile(_actualFilepath));
    String plaintext = BudgetControl.crypter.decrypt(e);
    _actual = BudgetMap.unserialize(plaintext);
  }

  TransactionList getTransactionData() {
    if (_transactions == null) {
      loadTransactionData();
    }
    return _transactions;
  }

  void loadTransactionData() async {
    Encrypted e = Encrypted.unserialize(
        await BudgetControl.fileIO.readFile(_transactionsFilepath));
    String plaintext = BudgetControl.crypter.decrypt(e);
    _transactions = TransactionList.unserialize(plaintext);
  }

  void updateMonthData(Budget budget) {
    _allotted = budget.allottedSpending;
    _actual = budget.actualSpending;
    _transactions = budget.transactions;
    type = budget.getType();
  }

  void save() {
    _saveAllottedSpending();
    _saveActualSpending();
    _saveTransactions();
  }

  void _saveAllottedSpending() {
    if (_allotted != null) {
      String content = _allotted.serialize();
      Encrypted e = BudgetControl.crypter.encrypt(content);
      BudgetControl.fileIO.writeFile(_allottedFilepath, e.serialize());
    }
  }

  void _saveActualSpending() {
    if (_actual != null) {
      String content = _actual.serialize();
      Encrypted e = BudgetControl.crypter.encrypt(content);
      BudgetControl.fileIO.writeFile(_actualFilepath, e.serialize());
    }
  }

  void _saveTransactions() {
    if (_transactions != null) {
      String content = _transactions.serialize();
      Encrypted e = BudgetControl.crypter.encrypt(content);
      BudgetControl.fileIO.writeFile(_transactionsFilepath, e.serialize());
    }
  }

  MonthTime getMonthTime() => _monthTime;

  double getIncome() => _income;

  static Month fromBudget(Budget b) {
    Month m = new Month(MonthTime.now(), b.getMonthlyIncome());
    m._transactions = b.transactions;
    m._actual = b.actualSpending;
    m._allotted = b.allottedSpending;
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
    Month m = new Month(
        new MonthTime(int.parse(map["year"]), int.parse(map["month"])),
        double.parse(map["income"]));
    m.type = jsonBudgetType[map["type"]];
    return m;
  }
}
