import 'dart:async';

import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/control.dart';
import 'package:budgetflow/model/abstract/crypter.dart';
import 'package:budgetflow/model/abstract/file_io.dart';
import 'package:budgetflow/model/abstract/password.dart';
import 'package:budgetflow/model/data_types/account.dart';
import 'package:budgetflow/model/data_types/account_list.dart';
import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/data_types/history.dart';
import 'package:budgetflow/model/data_types/location.dart';
import 'package:budgetflow/model/data_types/month_time.dart';
import 'package:budgetflow/model/data_types/payment_method.dart';
import 'package:budgetflow/model/data_types/priority.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/data_types/transaction_list.dart';
import 'package:budgetflow/model/impl/budget_accountant.dart';
import 'package:budgetflow/model/impl/dart_file_io.dart';
import 'package:budgetflow/model/impl/priority_budget_factory.dart';
import 'package:budgetflow/model/impl/steel_crypter.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:budgetflow/model/utils/setup_agent.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'data_types/achievement.dart';
import 'data_types/category.dart';
import 'data_types/month.dart';

/// Welcome to our favorite superclass
class BudgetControl implements Control {
  static FileIO fileIO = new DartFileIO();
  static Password _password;
  static Crypter crypter;
  History _history;
  TransactionList _loadedTransactions;
  MonthTime _transactionMonthTime;
  Budget _budget;
  bool _oldUser;
  Color cashFlowColor;
  List<PaymentMethod> paymentMethods;
  AccountList accounts;
  Map<Location, Category> locationMap = Map();
  StreamSubscription<Position> positionStream;
  BudgetAccountant accountant;
  List<Achievement> earnedAchievements = [];

  final Map<String, List<Category>> sectionMap = {
    'Needs': [
      Category.housing,
      Category.utilities,
      Category.groceries,
      Category.health,
      Category.transportation,
      Category.education,
      Category.kids
    ],
    'Wants': [Category.entertainment, Category.pets, Category.miscellaneous],
    'Savings': [Category.savings]
  };

  BudgetControl() {
    fileIO = new DartFileIO();
    _initVariables();
    _loadedTransactions = new TransactionList();
  }

  @override
  Future<bool> isReturningUser() async {
    _oldUser =
    await fileIO.fileExists(historyFilepath).catchError((Object error) {
      _oldUser = false;
      return false;
    });
    return _oldUser;
  }

  @override
  Future<bool> passwordIsValid(String secret) async {
    _password = await Password.load();
    return _password.verify(secret);
  }

  @override
  Future<bool> initialize() async {
    _initVariables();
    crypter = new SteelCrypter(_password);
    if (_oldUser) {
      await _load();
      return true;
    } else {
      return false;
    }
  }

  void _initVariables() {
    paymentMethods = [PaymentMethod('Cash')];
    _transactionMonthTime = MonthTime.now();
  }

  Future _load() async {
    _history = await History.load();
    _budget = await _history.getLatestMonthBudget();
    accountant = BudgetAccountant(_budget);
    _loadedTransactions = TransactionList.copy(_budget.transactions);
    await _loadAccounts();
    _initLocationMap();
    _initLocationListener();
  }

  Future _loadAccounts() async {
    AccountList loadedAccounts = Serializer.unserialize(
      methodListKey,
      await fileIO.readAndDecryptFile(accountsFilepath, crypter),
    );
    for (Account account in loadedAccounts) {
      addAccount(account);
    }
  }

  void _initLocationMap() {
    locationMap = Map<Location, Category>();
    _loadedTransactions.forEach((transaction) {
      if (transaction.location != null &&
          !locationMap.containsKey(transaction.location)) {
        locationMap[transaction.location] = transaction.category;
      }
    });
  }

  void _initLocationListener() {
    positionStream = Geolocator()
        .getPositionStream(LocationOptions(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
            timeInterval: 10))
        .listen((position) {
      Location streamLocation = Location.fromGeolocatorPosition(position);
      locationMap.forEach((location, category) async {
        if (await streamLocation.distanceTo(location) < 10) {
          // TODO Trigger notification
          print('In range of location ' +
              location.latitude.toString() +
              ', ' +
              location.longitude.toString() +
              ' for category ' +
              category.name);
        }
      });
    });
  }

  Future save() async {
    if (_history.getMonthFromMonthTime(MonthTime.now()) == null) {
      _history.add(Month(
        monthTime: MonthTime.now(),
        income: _budget.expectedIncome,
        type: _budget.type,
      ));
    }
    _history.save(_budget);
    fileIO.writeFile(passwordFilepath, _password.serialize);
    fileIO.encryptAndWriteFile(accountsFilepath, accounts.serialize, crypter);
  }

  @override
  Future setPassword(String newSecret) async {
    _password = await Password.fromSecret(newSecret);
    crypter = new SteelCrypter(_password);
  }

  @override
  Budget getBudget() {
    return _budget;
  }

  @override
  TransactionList getLoadedTransactions() {
    return _loadedTransactions;
  }

  TransactionList getTransactionsInCategory(Category category) {
    TransactionList transactions = TransactionList();
    _loadedTransactions.forEach((transaction) {
      if (transaction.category == category) {
        transactions.add(transaction);
      }
    });
    return transactions;
  }

  @override
  Future loadPreviousMonthTransactions() async {
    _transactionMonthTime = _transactionMonthTime.previous();
    // TODO Bug here, if there isn't another previous month the app will crash due to a null value error
    TransactionList transactions =
    await _history
        .getMonthFromMonthTime(MonthTime.now())
        .transactions;
    transactions.forEach((Transaction t) {
      _loadedTransactions.add(t);
    });
  }

  @override
  void addTransaction(Transaction t) {
    _budget.addTransaction(t);
    _history.getMonthFromMonthTime(MonthTime.now()).updateMonthData(_budget);
    _loadedTransactions.add(t);
    _initLocationListener();
    save();
  }

  void removeTransaction(Transaction transaction) {
    _budget.removeTransaction(transaction);
    _history.getMonthFromMonthTime(MonthTime.now()).updateMonthData(_budget);
    _loadedTransactions.remove(transaction);
    save();
  }

  Future<bool> setup() async {
    await setPassword(SetupAgent.pin);
    addNewBudget(PriorityBudgetFactory().newFromInfo(SetupAgent()));
    return true;
  }

  double getCashFlow() {
    double amt = _budget.expectedIncome -
        _budget.allotted.getCategory(Category.housing).value +
        expenseTotal();
    if (amt > 0) {
      cashFlowColor = Colors.green;
    } else if (amt < 0) {
      cashFlowColor = Colors.red;
    } else {
      cashFlowColor = Colors.black;
    }
    return amt;
  }

  @override
  void addNewBudget(Budget b) {
    _history = new History();
    Month m = Month.fromBudget(b);
    _history.add(m);
    _loadedTransactions = new TransactionList.copy(b.transactions);
    _budget = b;
    accountant = BudgetAccountant(_budget);
    save();
  }

  double expenseTotal() {
    double spent = 0.0;
    for (int i = 0; i < _loadedTransactions.length; i++) {
      spent += _loadedTransactions.getAt(i).amount;
    }
    return spent;
  }

  double expenseInSection(String section) {
    double spent = 0.0;
    for (Category cat in sectionMap[section]) {
      for (int i = 0; i < _loadedTransactions.length; i++) {
        Category rel = _loadedTransactions.getAt(i).category;
        if (rel == cat) {
          spent += _budget.allotted.getCategory(rel).value;
        }
      }
    }
    return spent;
  }

  void removeTransactionIfPresent(Transaction tran) {
    _budget.removeTransaction(tran);
  }

  void addAccount(Account account) {
    accounts.add(account);
    paymentMethods.add(account);
  }

  void removeAccount(Account account) {
    accounts.remove(account);
    paymentMethods.remove(account);
  }

  void forceNextMonthTransition() {
    _budget = PriorityBudgetFactory().newMonthBudget(_budget);
    _loadedTransactions = _budget.transactions;
    accountant = BudgetAccountant(_budget);
  }
}

class MockBudget {
  Budget budget;

  MockBudget(Budget budget) {
    this.budget = budget;
  }

  void setCategory(Category category, double amount) {
    budget.setAllotment(category, amount);
  }

  double getCategory(Category category) {
    return budget.allotted.getCategory(category).value;
  }

  double getNewTotalAllotted(String section) {
    Map<String, List<Category>> mockMap = {
      Priority.needs.name: BudgetingApp.control
          .getBudget()
          .getCategoriesOfPriority(Priority.needs),
      Priority.wants.name: BudgetingApp.control
          .getBudget()
          .getCategoriesOfPriority(Priority.wants),
      Priority.savings.name: BudgetingApp.control
          .getBudget()
          .getCategoriesOfPriority(Priority.savings)
    };
    double total = 0.0;
    for (Category category in mockMap[section]) {
      total += budget.allotted.getCategory(category).value;
    }
    return total;
  }
}
