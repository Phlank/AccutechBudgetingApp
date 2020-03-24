import 'package:budgetflow/model/account.dart';
import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';

abstract class Control {
  Future<bool> isReturningUser();

  Future<bool> passwordIsValid(String secret);

  Future<bool> initialize();

  void setPassword(String newSecret);

  void save();

  Budget getBudget();

  TransactionList getLoadedTransactions();

  Future loadPreviousMonthTransactions();

  void addTransaction(Transaction t);

  void addNewBudget(Budget b);

  Future setup();

  void addAccount(Account account);

  void removeAccount(Account account);

  void removeTransaction(Transaction transaction);
}
