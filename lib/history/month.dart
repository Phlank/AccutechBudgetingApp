import 'dart:html';

import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/transaction.dart';

class Month {
  String allottedFilePath, actualFilePath, transactionFilePath;
  String allottedContent, actualContent, transactionContent;
  Map<BudgetCategory, double> allottedSpendingData;
  Map<BudgetCategory, double> actualSpendingData;
  List<Transaction> transactionData;
  int year, month;

  Month(String directory, int year, int month) {
    this.year = year;
    this.month = month;
    _createFilePaths(directory);
  }

  void _createFilePaths(String directory) {
    Future<File> get _localFile async {
      final path = await _localPath;
      return File('$path/counter.txt');
    }

  }

  bool writeMonth() {
    // TODO this
  }
}
