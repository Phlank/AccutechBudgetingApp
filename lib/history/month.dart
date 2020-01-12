import 'package:budgetflow/budget/budget_map.dart';
import 'package:budgetflow/budget/transaction.dart';
import 'package:budgetflow/crypt/encrypted.dart';
import 'package:budgetflow/history/history.dart';
import 'package:budgetflow/history/json_stringifier.dart';
import 'package:budgetflow/history/stringifier.dart';

class Month {
  String _allottedFilepath, _actualFilepath, _transactionFilepath;
  BudgetMap allottedData;
  BudgetMap actualData;
  List<Transaction> transactionData;
  int year, month;
  Stringifier stringifier = new JSONStringifier();

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
      allottedData = BudgetMap.fromSerialized(plaintext);
    });
    History.fileIO.readFile(_actualFilepath).then((String cipher) {
      String plaintext = History.crypter.decrypt(Encrypted.fromFileContent(cipher));
      actualData = BudgetMap.fromSerialized(plaintext);
    });
  }

  Future<List<Transaction>> getTransactionData() async {
    if (transactionData == null) {
      // If the data has not been loaded, load it
      String cipher = await History.fileIO.readFile(_transactionFilepath);
      String plaintext =
          History.crypter.decrypt(Encrypted.fromFileContent(cipher));
      transactionData = stringifier.unstringifyTransactionList(plaintext);
    }
    return transactionData;
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
}
