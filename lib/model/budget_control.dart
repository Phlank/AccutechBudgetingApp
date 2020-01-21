import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/control.dart';
import 'package:budgetflow/model/crypt/crypter.dart';
import 'package:budgetflow/model/crypt/password.dart';
import 'package:budgetflow/model/crypt/steel_crypter.dart';
import 'package:budgetflow/model/crypt/steel_password.dart';
import 'package:budgetflow/model/file_io/dart_file_io.dart';
import 'package:budgetflow/model/file_io/file_io.dart';
import 'package:budgetflow/model/history/history.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'history/month.dart';

class BudgetControl implements Control {

  static const String _PASSWORD_PATH = "password";
  static FileIO fileIO;
  static Password _password;
  static Crypter crypter;
  final Map<String,String> regexMap = {
    'pin':r'\d\d\d\d',
    'dollarAmnt':r'\d+?([.]\d\d)',
    'name':r'\w+',
    'age':r'\d{2,3}'
  };

  bool _newUser;
  History _history;
  TransactionList _loadedTransactions;
  MonthTime _currentMonthTime, _transactionMonthTime;
  Budget _budget;

  BudgetControl() {
    fileIO = new DartFileIO();
    _updateMonthTimes();
    _loadedTransactions = new TransactionList();
  }

  @override
  bool isNewUser() {
    bool result = true;
    fileIO.fileExists(History.HISTORY_PATH).then((value) {
      result = !value;
    });
    _newUser = result;
    return result;
  }

  @override
  bool passwordIsValid(String secret) {
    bool result = false;
    _password = SteelPassword.load();
    bool passwordMatch = _password.verify(secret);
    if (passwordMatch) {
      initialize();
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  @override
  void initialize() {
    _updateMonthTimes();
    crypter = new SteelCrypter(_password);
    if (!_newUser) {
      _load();
    }
  }

  void _updateMonthTimes() {
    DateTime now = DateTime.now();
    _currentMonthTime = new MonthTime(now.year, now.month);
    _transactionMonthTime = new MonthTime(now.year, now.month);
  }

  void _load() {
    _history = History.load();
    _loadedTransactions =
        _history.getTransactionsFromMonthTime(_currentMonthTime);
    _budget = _history.getLatestMonthBudget();
  }

  void save() {
    _history.save(_budget);
    fileIO.writeFile(_PASSWORD_PATH, _password.serialize());
  }

  @override
  void setPassword(String newSecret) {
    _password = new SteelPassword(newSecret);
    crypter = new SteelCrypter(_password);
  }

  @override
  Budget getBudget() {
    return _history.getLatestMonthBudget();
  }

  @override
  TransactionList getLoadedTransactions() {
    return _loadedTransactions;
  }

  @override
  void loadPreviousMonthTransactions() {
    _transactionMonthTime = _transactionMonthTime.previous();
    _history
        .getTransactionsFromMonthTime(_transactionMonthTime)
        .forEach((Transaction t) {
      _loadedTransactions.add(t);
    });
  }

  @override
  void addTransaction(Transaction t) {
    _budget.addTransaction(t);
    _loadedTransactions.add(t);
  }

  bool validInput(String value, String inputType) {
    return new RegExp(regexMap[inputType]).hasMatch(value);
  }
  @override
  void addNewBudget(Budget b) {
    _history = new History();
    Month m = Month.fromBudget(b);
    _history.addMonth(m);
    _loadedTransactions = b.transactions;
    _budget = b;
  }
}
