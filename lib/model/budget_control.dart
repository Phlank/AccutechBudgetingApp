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
import 'package:stack_trace/stack_trace.dart';

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
  Future<bool> isReturningUser() {
    return fileIO.fileExists(History.HISTORY_PATH);
  }

  @override
  Future<bool> passwordIsValid(String secret) async {
    _password = await SteelPassword.load();
    bool passwordMatch = _password.verify(secret);
    if (passwordMatch) {
      initialize(false);
    }
    return passwordMatch;
  }

  @override
  void initialize(bool newUser) {
    _updateMonthTimes();
    crypter = new SteelCrypter(_password);
    if (!newUser) {
      _load();
    }
  }

  void _updateMonthTimes() {
    DateTime now = DateTime.now();
    _currentMonthTime = new MonthTime(now.year, now.month);
    _transactionMonthTime = new MonthTime(now.year, now.month);
  }

  void _load() async{
    print('loading history');
    _history = await History.load();
    print(_history);
    _loadedTransactions =
        _history.getTransactionsFromMonthTime(_currentMonthTime);
    print(_loadedTransactions);
    _budget = _history.getLatestMonthBudget();
    print(_budget.toString());
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
  Budget getBudget()  {
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
