import 'package:budgetflow/model/budget/allocation_list.dart';
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

  Future<AllocationList> loadAllotted() async {
    String cipher, plaintext;
    Encrypted e;
    cipher = await BudgetControl.fileIO
        .readFile(_allottedFilepath)
        .catchError((Object error) {
      return AllocationList();
    });
    if (cipher != null) {
      e = Serializer.unserialize(encryptedKey, cipher);
      plaintext = BudgetControl.crypter.decrypt(e);
      return Serializer.unserialize(allocationListKey, plaintext);
    } else {
      return AllocationList();
    }
  }

  Future<AllocationList> loadActual() async {
    String cipher, plaintext;
    Encrypted e;
    cipher = await BudgetControl.fileIO
        .readFile(_actualFilepath)
        .catchError((Object error) {
      return AllocationList();
    });
    if (cipher != null) {
      e = Serializer.unserialize(encryptedKey, cipher);
      plaintext = BudgetControl.crypter.decrypt(e);
      return Serializer.unserialize(allocationListKey, plaintext);
    } else {
      return AllocationList();
    }
  }

  Future<AllocationList> loadTarget() async {
    String cipher, plaintext;
    Encrypted e;
    cipher = await BudgetControl.fileIO
        .readFile(_targetFilepath)
        .catchError((Object error) {
      return AllocationList();
    });
    if (cipher != null) {
      e = Serializer.unserialize(encryptedKey, cipher);
      plaintext = BudgetControl.crypter.decrypt(e);
      return Serializer.unserialize(allocationListKey, plaintext);
    } else {
      return AllocationList();
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

  Future saveAllotted(AllocationList allotted) async {
    String content = allotted.serialize;
    Encrypted e = BudgetControl.crypter.encrypt(content);
    await BudgetControl.fileIO.writeFile(_allottedFilepath, e.serialize);
  }

  Future saveActual(AllocationList actual) async {
    String content = actual.serialize;
    Encrypted e = BudgetControl.crypter.encrypt(content);
    await BudgetControl.fileIO.writeFile(_actualFilepath, e.serialize);
  }

  Future saveTarget(AllocationList target) async {
    String content = target.serialize;
    Encrypted e = BudgetControl.crypter.encrypt(content);
    await BudgetControl.fileIO.writeFile(_targetFilepath, e.serialize);
  }

  Future saveTransactions(TransactionList transactions) async {
    String content = transactions.serialize;
    Encrypted e = BudgetControl.crypter.encrypt(content);
    await BudgetControl.fileIO.writeFile(_transactionsFilepath, e.serialize);
  }
}
