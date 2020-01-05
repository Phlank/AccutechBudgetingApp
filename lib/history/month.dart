import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/transaction.dart';
import 'package:budgetflow/crypt/encrypted.dart';
import 'package:budgetflow/history/history.dart';
import 'package:budgetflow/history/json_stringifier.dart';
import 'package:budgetflow/history/strinfigier.dart';

class Month {
  String _allottedFilepath, _actualFilepath, _transactionFilepath;
  Map<BudgetCategory, double> allottedSpendingData;
  Map<BudgetCategory, double> actualSpendingData;
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
    if (allottedSpendingData == null) {
      // If the data has not been loaded, load it
      String cipher = await History.fileIO.readFile(_allottedFilepath);
      String plaintext =
          History.crypter.decrypt(Encrypted.fromFileContent(cipher));
      allottedSpendingData = stringifier.unstringifyBudgetMap(plaintext);
    }
    return allottedSpendingData;
  }

  Future<Map<BudgetCategory, double>> getActualSpendingData() async {
    if (actualSpendingData == null) {
      // If the data has not been loaded, load it
      String cipher = await History.fileIO.readFile(_actualFilepath);
      String plaintext =
      History.crypter.decrypt(Encrypted.fromFileContent(cipher));
      actualSpendingData = stringifier.unstringifyBudgetMap(plaintext);
    }
    return actualSpendingData;
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

  bool writeMonth() {
    // TODO this
  }
}
