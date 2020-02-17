import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/data/transaction.dart';
import 'package:budgetflow/model/budget/data/transaction_list.dart';

abstract class Control {
  Future<bool> isReturningUser();

  Future<bool> passwordIsValid(String secret);

  void initialize();

  void setPassword(String newSecret);

  void save();

  Budget getBudget();

  TransactionList getLoadedTransactions();

  Future loadPreviousMonthTransactions();

  void addTransaction(Transaction t);

  void addNewBudget(Budget b);
}
