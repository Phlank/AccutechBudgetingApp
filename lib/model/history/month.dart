import 'dart:convert';

import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/crypt/encrypted.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

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
    if (_income == null) throw new NullThrownError();
    if (_type == null) throw new NullThrownError();
    // Don't need to check if BudgetMaps are null because if they are they can be loaded.
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
    _allotted = b.allotted;
    _actual = b.actual;
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

  Future<BudgetMap> get allotted async {
    if (_allotted == null) {
      await loadAllotted();
    }
    return _allotted;
  }

  Future loadAllotted() async {
    String cipher, plaintext;
    Encrypted e;
    cipher = await BudgetControl.fileIO.readFile(_allottedFilepath)
        .catchError((Object error) {
      _allotted = new BudgetMap();
    });
    if (cipher != null) {
      e = Encrypted.unserialize(cipher);
      plaintext = BudgetControl.crypter.decrypt(e);
      _allotted = BudgetMap.unserialize(plaintext);
    }
  }

  Future<BudgetMap> get actual async {
    if (_actual == null) {
      await loadActual();
    }
    return _actual;
  }

  Future loadActual() async {
    String cipher, plaintext;
    Encrypted e;
    cipher = await BudgetControl.fileIO.readFile(_actualFilepath)
        .catchError((Object error) {
      _actual = new BudgetMap();
    });
    if (cipher != null) {
      e = Encrypted.unserialize(cipher);
      plaintext = BudgetControl.crypter.decrypt(e);
      _actual = BudgetMap.unserialize(plaintext);
    }
  }

  Future<TransactionList> get transactions async {
    if (_transactions == null) {
      await loadTransactions();
    }
    return _transactions;
  }

  Future loadTransactions() async {
    String cipher, plaintext;
    Encrypted e;
    cipher = await BudgetControl.fileIO.readFile(_transactionsFilepath)
        .catchError((Object error) {
      _transactions = new TransactionList();
    });
    if (cipher != null) {
      e = Encrypted.unserialize(cipher);
      plaintext = BudgetControl.crypter.decrypt(e);
      _transactions = TransactionList.unserialize(plaintext);
    }
  }

  void updateMonthData(Budget budget) {
    _allotted = budget.allotted;
    _actual = budget.actual;
    _transactions = budget.transactions;
    _type = budget.type;
  }

  Future save() async {
    if (_allotted != null) await _saveAllottedSpending();
    if (_actual != null) await _saveActualSpending();
    if (_transactions != null) await _saveTransactions();
  }

  Future _saveAllottedSpending() async {
    if (_allotted != null) {
      String content = _allotted.serialize;
      Encrypted e = BudgetControl.crypter.encrypt(content);
      await BudgetControl.fileIO.writeFile(_allottedFilepath, e.serialize);
    }
  }

  Future _saveActualSpending() async {
    if (_actual != null) {
      String content = _actual.serialize;
      Encrypted e = BudgetControl.crypter.encrypt(content);
      await BudgetControl.fileIO.writeFile(_actualFilepath, e.serialize);
    }
  }

  Future _saveTransactions() async {
    if (_transactions != null) {
      String content = _transactions.serialize;
      Encrypted e = BudgetControl.crypter.encrypt(content);
      await BudgetControl.fileIO.writeFile(
          _transactionsFilepath, e.serialize);
    }
  }

  MonthTime getMonthTime() => _monthTime;

  double getIncome() => _income;

  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(KEY_YEAR, _monthTime.year);
    serializer.addPair(KEY_MONTH, _monthTime.month);
    serializer.addPair(KEY_INCOME, _income);
    serializer.addPair(KEY_TYPE, _type);
    return serializer.serialize;
  }

  static unserialize(String serialization) {
    Map map = jsonDecode(serialization);
    return unserializeMap(map);
  }

  static unserializeMap(Map map) {
    MonthBuilder builder = new MonthBuilder();
    MonthTime monthTime =
    new MonthTime(int.parse(map[KEY_YEAR]), int.parse(map[KEY_MONTH]));
    builder.setMonthTime(monthTime);
    builder.setIncome(double.parse(map[KEY_INCOME]));
    builder.setType(BudgetType.unserialize(map[KEY_TYPE]));
    return builder.build();
  }

  bool operator ==(Object other) => other is Month && this._equals(other);

  bool _equals(Month other) {
    return this.monthTime == other.monthTime &&
        this.income == other.income &&
        this.type == other.type &&
        this._allotted == other._allotted &&
        this._actual == other._actual &&
        this._transactions == other._transactions;
  }

  int get hashCode =>
      monthTime.hashCode ^
      income.hashCode ^
      type.hashCode ^
      allotted.hashCode ^
      actual.hashCode ^
      transactions.hashCode;

  String toString() {
    return monthTime.year.toString() + "_" + monthTime.month.toString();
  }
}
