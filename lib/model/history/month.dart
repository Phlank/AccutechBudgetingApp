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

  // Don't need to check if BudgetMaps are null because if they are they can be
  // loaded.
  Month build() {
    if (_monthTime == null) throw new NullThrownError();
    if (_income == null) throw new NullThrownError();
    if (_type == null) throw new NullThrownError();
    return new Month._new(
        _monthTime, //
        _income, //
        _type, //
        _allotted, //
        _actual, //
        _transactions);
  }
}

class Month implements Serializable {
  String _allottedFilepath, _actualFilepath, _transactionsFilepath;
  BudgetMap _allotted, _actual;
  TransactionList _transactions;
  MonthTime _monthTime;
  double _income;
  BudgetType _type;

  Month._new(this._monthTime, this._income, this._type, this._allotted,
      this._actual, this._transactions) {
    _createFilePaths();
  }

  Month.fromBudget(Budget b) {
    _monthTime = MonthTime.now();
    _income = b.income;
    _type = b.type;
    _allotted = b.allottedSpending;
    _actual = b.actualSpending;
    _transactions = b.transactions;
    _createFilePaths();
  }

  void _createFilePaths() {
    _allottedFilepath = _monthTime.getFilePathString() + "_allotted";
    _actualFilepath = _monthTime.getFilePathString() + "_actual";
    _transactionsFilepath = _monthTime.getFilePathString() + "_transactions";
  }

  MonthTime get monthTime => _monthTime;

  double get income => _income;

  BudgetType get type => _type;

  BudgetMap get allotted {
    if (_allotted == null) {
      loadAllotted();
    }
    return _allotted;
  }

  void loadAllotted() async {
    String cipher = await BudgetControl.fileIO
        .readFile(_allottedFilepath)
        .catchError((Object o) {
      _allotted = new BudgetMap();
      return;
    });
    Encrypted e = Encrypted.unserialize(cipher);
    String plaintext = BudgetControl.crypter.decrypt(e);
    _allotted = BudgetMap.unserialize(plaintext);
  }

  BudgetMap get actual {
    if (_actual == null) {
      try {
        loadActual();
      } catch (NoSuchMethodError) {
        _actual = new BudgetMap();
      }
    }
    return _actual;
  }

  void loadActual() async {
    String cipher = await BudgetControl.fileIO
        .readFile(_actualFilepath)
        .catchError((Object o) {
      _actual = new BudgetMap();
      return;
    });
    Encrypted e = Encrypted.unserialize(cipher);
    String plaintext = BudgetControl.crypter.decrypt(e);
    _actual = BudgetMap.unserialize(plaintext);
  }

  TransactionList get transactions {
    if (_transactions == null) {
      try {
        loadTransactions();
      } catch (NoSuchMethodError) {
        _transactions = new TransactionList();
      }
    }
    return _transactions;
  }

  void loadTransactions() async {
    String cipher = await BudgetControl.fileIO
        .readFile(_transactionsFilepath)
        .catchError((Object o) {
      _transactions = new TransactionList();
      return;
    });
    Encrypted e = Encrypted.unserialize(cipher);
    String plaintext = BudgetControl.crypter.decrypt(e);
    _transactions = TransactionList.unserialize(plaintext);
  }

  void updateMonthData(Budget budget) {
    _allotted = budget.allottedSpending;
    _actual = budget.actualSpending;
    _transactions = budget.transactions;
    _type = budget.getType();
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

  String serialize() {
    String output = "{";
    output += '"year":"' + _monthTime.year.toString() + "\",";
    output += '"month":"' + _monthTime.month.toString() + '",';
    output += '"income":"' + _income.toString() + '",';
    output += '"type":"' + budgetTypeJson[_type] + '"';
    output += '}';
    return output;
  }

  static unserialize(String serialization) {
    Map map = jsonDecode(serialization);
    return unserializeMap(map);
  }

  static unserializeMap(Map map) {
    MonthBuilder builder = new MonthBuilder();
    MonthTime monthTime =
        new MonthTime(int.parse(map["year"]), int.parse(map["month"]));
    builder.setMonthTime(monthTime);
    builder.setIncome(double.parse(map["income"]));
    builder.setType(jsonBudgetType[map["type"]]);
    return builder.build();
  }
}
