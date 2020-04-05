import 'package:budgetflow/model/account.dart';
import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/data_types/transaction_list.dart';

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
