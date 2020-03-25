import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/payment_method.dart';
import 'package:flutter/foundation.dart';

class Account extends PaymentMethod {
  String accountName;
  TransactionList accountTransactions;
  DateTime beginning;
  double amount;

  Account({
    @required String methodName,
    @required String accountName,
    this.accountTransactions,
    this.beginning,
    this.amount,
  }) : super(methodName) {
    this.accountName = accountName;
    if (accountTransactions == null) accountTransactions = TransactionList();
    if (beginning == null) beginning = DateTime.now();
    if (amount == null) amount = 0.0;
  }

  Account.empty() : super('') {
    accountName = '';
    accountTransactions = TransactionList();
    beginning = DateTime.now();
    amount = 0.0;
  }

  void addTransaction(Transaction t) {
    if (!accountTransactions.contains(t)) {
      accountTransactions.add(t);
    }
  }

  double getSpending() {
    if (accountTransactions == null) return 0.0;
    double total = 0.0;
    accountTransactions.forEach((transaction) {
      if (transaction.category.isSpending) {
        total += transaction.amount.abs();
      }
    });
    return total;
  }

  double getSpendingRange(DateTime from, DateTime to) {
    if (accountTransactions == null) return 0.0;
    double total = 0.0;
    accountTransactions.forEach((transaction) {
      // Is the transaction a spending transaction and is it in the specified range?
      if (transaction.category.isSpending &&
          _transactionInRange(transaction, from, to)) {
        total += transaction.amount.abs();
      }
    });
    return total;
  }

  bool _transactionInRange(Transaction t, DateTime from, DateTime to) {
    return t.time.isAfter(from) && t.time.isBefore(to);
  }

  double getIncrease() {
    if (accountTransactions == null) return 0.0;
    double total = 0.0;
    accountTransactions.forEach((transaction) {
      if (transaction.category.isIncome || transaction.category.isSaving) {
        total += transaction.amount.abs();
      }
    });
    return total;
  }

  double getIncreaseInRange(DateTime from, DateTime to) {
    if (accountTransactions == null) return 0.0;
    double total = 0.0;
    accountTransactions.forEach((transaction) {
      if ((transaction.category.isIncome || transaction.category.isSaving) &&
          _transactionInRange(transaction, from, to)) {
        total += transaction.amount.abs();
      }
    });
    return total;
  }
}
