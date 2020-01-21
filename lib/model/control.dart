import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';

abstract class Control {
  bool isNewUser();

  bool passwordIsValid(String secret);

  void initialize();

  void setPassword(String newSecret);

  void save();

  Budget getBudget();

  TransactionList getLoadedTransactions();

  void loadPreviousMonthTransactions();

  void addTransaction(Transaction t);

  void addNewBudget(Budget b);
}
