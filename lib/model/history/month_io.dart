import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/io.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/data_types/allocation_list.dart';
import 'package:budgetflow/model/data_types/encrypted.dart';
import 'package:budgetflow/model/data_types/month.dart';
import 'package:budgetflow/model/data_types/transaction_list.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class MonthIO implements io {
  MonthTime monthTime;
  Month _month;
  String _allottedFilepath,
      _actualFilepath,
      _targetFilepath,
      _transactionsFilepath;

  MonthIO(this._month) {
    monthTime = _month.getMonthTime();
    initFileStrings();
  }

  MonthIO.ofTime(this.monthTime) {
    initFileStrings();
  }

  void initFileStrings() {
    _allottedFilepath = monthTime.getFilePathString() + "_allotted";
    _actualFilepath = monthTime.getFilePathString() + "_actual";
    _targetFilepath = monthTime.getFilePathString() + "_target";
    _transactionsFilepath =
        monthTime.getFilePathString() + "_transactions";
  }

  Future<Month> load() async {

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

  Future<bool> save() async {
    saveAllotted();
    saveActual();
    saveTarget();
    saveTransactions();
  }

  Future saveAllotted() async {
    AllocationList allotted = await _month.allotted;
    String content = allotted.serialize;
    Encrypted e = BudgetControl.crypter.encrypt(content);
    await BudgetControl.fileIO.writeFile(_allottedFilepath, e.serialize);
  }

  Future saveActual() async {
    AllocationList actual = await _month.actual;
    String content = actual.serialize;
    Encrypted e = BudgetControl.crypter.encrypt(content);
    await BudgetControl.fileIO.writeFile(_actualFilepath, e.serialize);
  }

  Future saveTarget() async {
    AllocationList target = await _month.target;
    String content = target.serialize;
    Encrypted e = BudgetControl.crypter.encrypt(content);
    await BudgetControl.fileIO.writeFile(_targetFilepath, e.serialize);
  }

  Future saveTransactions() async {
    TransactionList transactions = await _month.transactions;
    String content = transactions.serialize;
    Encrypted e = BudgetControl.crypter.encrypt(content);
    await BudgetControl.fileIO.writeFile(_transactionsFilepath, e.serialize);
  }
}
