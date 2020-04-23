import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/data_types/payment_method.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/data_types/transaction_list.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter/foundation.dart';

class Account extends PaymentMethod {
  String accountName;
  TransactionList accountTransactions;
  DateTime beginning;
  double amount;

  Account({
    @required String methodName,
    @required this.accountName,
            @required this.beginning,
    this.accountTransactions,
    this.amount,
  }) : super(methodName) {
    this.methodName = methodName;
    this.accountName = accountName;
    if (accountTransactions == null) accountTransactions = TransactionList();
    if (beginning == null) beginning = DateTime.now();
    if (amount == null) amount = 0.0;
  }

  Account.empty() : super('') {
    accountName = '';
    methodName = '';
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

  /// Returns the total of all Transactions with Categories of either income or savings.
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

  /// Returns the total of all Transactions with Categories of either income or savings between the given DateTimes.
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

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(methodNameKey, methodName);
    serializer.addPair(accountNameKey, accountName);
    serializer.addPair(beginningKey, beginning.toIso8601String());
    return serializer.serialize;
  }

  bool operator ==(Object other) => other is Account && this._equals(other);

  bool _equals(Account other) {
    return accountName == other.accountName &&
        methodName == other.methodName &&
        beginning == other.beginning;
  }

  /// The hash code for this object.
  int get hashCode =>
      accountName.hashCode ^ methodName.hashCode ^ beginning.hashCode;
}
