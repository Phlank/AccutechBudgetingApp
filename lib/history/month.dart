import 'dart:html';

import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/transaction.dart';
import 'package:budgetflow/history/history.dart';

class Month {
  String _allottedFilepath, _actualFilepath, _transactionFilepath;
  String allottedContent, actualContent, transactionContent;
  Map<BudgetCategory, double> allottedSpendingData;
  Map<BudgetCategory, double> actualSpendingData;
  List<Transaction> transactionData;
  int year, month;
  History _history;

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
    if (allottedSpendingData == null) { // If the data has not been loaded
      String cipher = await History.fileIO.readFile(_allottedFilepath);

    }
  }

  bool writeMonth() {
    // TODO this
  }
}
