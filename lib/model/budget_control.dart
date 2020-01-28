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

import 'budget/budget_category.dart';
import 'history/month.dart';

class BudgetControl implements Control {
  static const String _PASSWORD_PATH = "password";
  static FileIO fileIO = new DartFileIO();
  static Password _password;
  static Crypter crypter;
  History _history;
  TransactionList _loadedTransactions;
  MonthTime _currentMonthTime, _transactionMonthTime;
  Budget _budget;

  final Map<String, BudgetCategory> categoryMap = {
    'housing': BudgetCategory.housing,
    'utilities': BudgetCategory.utilities,
    'groceries': BudgetCategory.groceries,
    'savings': BudgetCategory.savings,
    'health': BudgetCategory.health,
    'transportation': BudgetCategory.transportation,
    'education': BudgetCategory.education,
    'entertainment': BudgetCategory.entertainment,
    'kids': BudgetCategory.kids,
    'pets': BudgetCategory.pets,
    'miscellaneous': BudgetCategory.miscellaneous
  };

  final Map<String,List<String>> sectionMap ={
    'needs':['housing','utilities','groceries','health','transportation','education','kids'],
    'wants':['entertainment','pets','miscellaneous'],
    'savings':['savings']
  };

  final Map<String,String> routeMap ={
    'needs':'/needs',
    'wants':'/wants',
    'savings':'/savings',
    'home':'/knownUser'
  };

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
     return _password.verify(secret);
  }

  @override
  Future<bool> initialize(bool newUser) {
    _updateMonthTimes();
    crypter = new SteelCrypter(_password);
    if (!newUser) {
     return  _load();
    }
    return new Future((){
      return true;
    });
  }

  void _updateMonthTimes() {
    DateTime now = DateTime.now();
    _currentMonthTime = new MonthTime(now.year, now.month);
    _transactionMonthTime = new MonthTime(now.year, now.month);
  }

  Future<bool> _load() async{
    _history = await History.load();
    _loadedTransactions =
        _history.getTransactionsFromMonthTime(_currentMonthTime);
    _budget = _history.getLatestMonthBudget();
    print(_budget);
    return _budget != null;
  }

  void save() {
    _history.save(_budget);
    fileIO.writeFile(_PASSWORD_PATH, _password.serialize());
  }

  @override
  void setPassword(String newSecret) {
    _password = Password.fromSecret(newSecret);
    crypter = new SteelCrypter(_password);
  }

  @override
  Budget getBudget()  {
    return _budget;
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

  void changeAllotment(String category, double newAmt){
    _budget.setAllotment(categoryMap[category], newAmt);

  }

  double sectionBudget(String section){
    double secBudget = 0.0;
    for(String category in sectionMap[section]){
      secBudget += _budget.allotted[categoryMap[category]];
    }
    return secBudget;
  }


  String getCashFlow(){
    return (_budget.getMonthlyIncome() - expenseTotal()).toString();
  }

  @override
  void addNewBudget(Budget b) {
    _history = new History();
    Month m = Month.fromBudget(b);
    _history.addMonth(m);
    _loadedTransactions = b.transactions;
    _budget = b;
  }

  Map<String, double> buildBudgetMap() {
    Map<String, double> map = new Map();
    map.putIfAbsent('housing',
            () => _budget.allotted[BudgetCategory.housing]);
    map.putIfAbsent('utilities',
            () => _budget.allotted[BudgetCategory.utilities]);
    map.putIfAbsent('groceries',
            () => _budget.allotted[BudgetCategory.groceries]);
    map.putIfAbsent('savings',
            () => _budget.allotted[BudgetCategory.savings]);
    map.putIfAbsent('helath',
            () => _budget.allotted[BudgetCategory.health]);
    map.putIfAbsent(
        'transportation',
            () =>
        _budget.allotted[BudgetCategory.transportation]);
    map.putIfAbsent('education',
            () => _budget.allotted[BudgetCategory.education]);
    map.putIfAbsent(
        'entertainment',
            () =>
        _budget.allotted[BudgetCategory.entertainment]);
    map.putIfAbsent(
        'kids', () => _budget.allotted[BudgetCategory.kids]);
    map.putIfAbsent(
        'pets', () => _budget.allotted[BudgetCategory.pets]);
    map.putIfAbsent(
        'miscellaneous',
            () =>
        _budget.allotted[BudgetCategory.miscellaneous]);
    return map;
  }

  double expenseTotal() {
    double spent = 0.0;
    for(int i = 0; i<_loadedTransactions.length(); i++){
      spent += _loadedTransactions.getAt(i).delta;
    }
    return spent;
  }

}

class MockBudget{
  Budget budget;
  MockBudget(Budget budget){
    this.budget = budget;
  }

  void setCategory(BudgetCategory category, double amount){
    budget.setAllotment(category, amount);
  }

  double getCategory(BudgetCategory category){
    return budget.allotted[category];
  }

  double getNewTotalAlotted(String section){
    Map<String, List<BudgetCategory>> mockMap ={
      'needs':[BudgetCategory.health,BudgetCategory.housing,BudgetCategory.utilities, BudgetCategory.groceries,BudgetCategory.transportation, BudgetCategory.kids],
      'wants':[BudgetCategory.pets,BudgetCategory.miscellaneous, BudgetCategory.entertainment],
      'savings':[BudgetCategory.savings]
    };
    double total = 0.0;
    for(BudgetCategory category in mockMap[section]){
      total += budget.allotted[category];
    }
    return total;
  }

}
