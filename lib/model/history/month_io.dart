import 'package:budgetflow/model/budget/budget_map.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/crypt/encrypted.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class MonthIO {
  Month _month;
  String _allottedFilepath,
      _actualFilepath,
      _targetFilepath,
      _transactionsFilepath;

  MonthIO(this._month) {
    _allottedFilepath = _month.getMonthTime().getFilePathString() + "_allotted";
    _actualFilepath = _month.getMonthTime().getFilePathString() + "_actual";
    _targetFilepath = _month.getMonthTime().getFilePathString() + "_target";
    _transactionsFilepath =
        _month.getMonthTime().getFilePathString() + "_transactions";
  }

  Future<BudgetMap> loadAllotted() async {
    String cipher, plaintext;
    Encrypted e;
    cipher = await BudgetControl.fileIO
        .readFile(_allottedFilepath)
        .catchError((Object error) {
      return BudgetMap();
    });
    if (cipher != null) {
      e = Serializer.unserialize(encryptedKey, cipher);
      plaintext = BudgetControl.crypter.decrypt(e);
      return Serializer.unserialize(budgetMapKey, plaintext);
    } else {
      return BudgetMap();
    }
  }

  Future<BudgetMap> loadActual() async {
    String cipher, plaintext;
    Encrypted e;
    cipher = await BudgetControl.fileIO
        .readFile(_actualFilepath)
        .catchError((Object error) {
      return BudgetMap();
    });
    if (cipher != null) {
      e = Serializer.unserialize(encryptedKey, cipher);
      plaintext = BudgetControl.crypter.decrypt(e);
      return Serializer.unserialize(budgetMapKey, plaintext);
    } else {
      return BudgetMap();
    }
  }

  Future<BudgetMap> loadTarget() async {
    String cipher, plaintext;
    Encrypted e;
    cipher = await BudgetControl.fileIO
        .readFile(_targetFilepath)
        .catchError((Object error) {
      return BudgetMap();
    });
    if (cipher != null) {
      e = Serializer.unserialize(encryptedKey, cipher);
      plaintext = BudgetControl.crypter.decrypt(e);
      return Serializer.unserialize(budgetMapKey, plaintext);
    } else {
      return BudgetMap();
    }
  }

  Future<TransactionList> loadTransactions() async {
    String cipher, plaintext;
    Encrypted e;
    cipher = await BudgetControl.fileIO
        .readFile(_transactionsFilepath)
        .catchError((Object error) {
      return TransactionList();
    });
    if (cipher != null) {
      e = Serializer.unserialize(encryptedKey, cipher);
      plaintext = BudgetControl.crypter.decrypt(e);
      return Serializer.unserialize(transactionListKey, plaintext);
    } else {
      return TransactionList();
    }
  }

  Future saveAllotted(BudgetMap allotted) async {
    String content = allotted.serialize;
    Encrypted e = BudgetControl.crypter.encrypt(content);
    await BudgetControl.fileIO.writeFile(_allottedFilepath, e.serialize);
  }

  Future saveActual(BudgetMap actual) async {
    String content = actual.serialize;
    Encrypted e = BudgetControl.crypter.encrypt(content);
    await BudgetControl.fileIO.writeFile(_actualFilepath, e.serialize);
  }

  Future saveTransactions(TransactionList transactions) async {
    String content = transactions.serialize;
    Encrypted e = BudgetControl.crypter.encrypt(content);
    await BudgetControl.fileIO.writeFile(_transactionsFilepath, e.serialize);
  }
}
