import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/transaction.dart';
import 'package:budgetflow/crypt/encrypted.dart';
import 'package:budgetflow/history/history.dart';
import 'package:budgetflow/history/json_stringifier.dart';
import 'package:budgetflow/history/strinfigier.dart';

class Month {
  String _allottedFilepath, _actualFilepath, _transactionFilepath;
  Map<BudgetCategory, double> allottedData;
  Map<BudgetCategory, double> actualData;
  List<Transaction> transactionData;
  int year, month;
  History _history;
  Stringifier stringifier = new JSONStringifier();

  Month(History history, int year, int month) {
    _history = history;
    this.year = year;
    this.month = month;
    _createFilePaths();
  }

  void _createFilePaths() {
    _allottedFilepath = "$year" + "_" + "$month" + "_allotted";
    _actualFilepath = "$year" + "_" + "$month" + "_actual";
    _transactionFilepath = "$year" + "_" + "$month" + "_transactions";
  }

  Future<Map<BudgetCategory, double>> getAllottedSpendingData() async {
    if (allottedData == null) {
      _loadBudgetData();
    }
    return allottedData;
  }

  Future<Map<BudgetCategory, double>> getActualSpendingData() async {
    if (actualData == null) {
      _loadBudgetData();
    }
    return actualData;
  }

  Future _loadBudgetData() async {
    String cipher, plaintext;
    cipher = await History.fileIO.readFile(_allottedFilepath);
    plaintext = History.crypter.decrypt(Encrypted.fromFileContent(cipher));
    allottedData = stringifier.unstringifyBudgetMap(plaintext);
    cipher = await History.fileIO.readFile(_actualFilepath);
    plaintext = History.crypter.decrypt(Encrypted.fromFileContent(cipher));
    actualData = stringifier.unstringifyBudgetMap(plaintext);
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

  void updateMonthData(Map<BudgetCategory, double> allotted,
      Map<BudgetCategory, double> actual, List<Transaction> transactions) {
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
