import 'dart:async';

import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_accountant.dart';
import 'package:budgetflow/model/budget/category/priority.dart';
import 'package:budgetflow/model/budget/factory/priority_budget_factory.dart';
import 'package:budgetflow/model/budget/location/location.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/control.dart';
import 'package:budgetflow/model/crypt/crypter.dart';
import 'package:budgetflow/model/crypt/password.dart';
import 'package:budgetflow/model/crypt/steel_crypter.dart';
import 'package:budgetflow/model/file_io/dart_file_io.dart';
import 'package:budgetflow/model/file_io/file_io.dart';
import 'package:budgetflow/model/history/history.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:budgetflow/model/setup_agent.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'budget/category/category.dart';
import 'history/month.dart';

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
  Map<Location, Category> locationMap = Map();
  StreamSubscription<Position> positionStream;
  BudgetAccountant accountant;

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
    _updateMonthTimes();
    _loadedTransactions = new TransactionList();
  }

  @override
  Future<bool> isReturningUser() async {
    _oldUser = await fileIO
        .fileExists(History.HISTORY_PATH)
        .catchError((Object error) {
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
    print("Initializing BudgetControl");
    _updateMonthTimes();
    print("MonthTimes updated");
    crypter = new SteelCrypter(_password);
    print("Crypter created");
    if (_oldUser) {
      await _load();
      return true;
    } else {
      return false;
    }
  }

  void _updateMonthTimes() {
    _transactionMonthTime = MonthTime.now();
  }

  Future _load() async {
    _history = await History.load();
    _budget = await _history.getLatestMonthBudget();
    accountant = BudgetAccountant(_budget);
    _loadedTransactions = TransactionList.copy(_budget.transactions);
    _initLocationMap();
    _initLocationListener();
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
    if (_history.getMonth(MonthTime.now()) == null) {
      _history.addMonth(Month(
        monthTime: MonthTime.now(),
        income: _budget.expectedIncome,
        type: _budget.type,
      ));
    }
    _history.save(_budget);
    fileIO.writeFile(Password.path, _password.serialize);
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
    TransactionList transactions =
    await _history.getTransactionsFromMonthTime(MonthTime.now());
    transactions.forEach((Transaction t) {
      _loadedTransactions.add(t);
    });
  }

  @override
  void addTransaction(Transaction t) {
    _budget.addTransaction(t);
    _history.getMonth(MonthTime.now()).updateMonthData(_budget);
    _loadedTransactions.add(t);
    save();
  }

  Future<bool> setup() async {
    await setPassword(SetupAgent.pin);
    addNewBudget(PriorityBudgetFactory().newFromInfo(
        SetupAgent.income,
        SetupAgent.housing,
        SetupAgent.depletion,
        SetupAgent.savingsPull,
        SetupAgent.kids,
        SetupAgent.pets));
    return true;
  }

  void changeAllotment(String category, double newAmt) {
    _budget.setAllotment(Category.categoryFromString(category), newAmt);
  }

  double sectionBudget(String section) {
    double secBudget = 0.0;
    for (Category category in sectionMap[section]) {
      secBudget += _budget.allotted
          .getCategory(category)
          .value;
    }
    return secBudget;
  }

  double getCashFlow() {
    double amt = _budget.expectedIncome -
        _budget.allotted
            .getCategory(Category.housing)
            .value +
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
    _history.addMonth(m);
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
          spent += _budget.allotted
              .getCategory(rel)
              .value;
        }
      }
    }
    return spent;
  }

  double remainingInSection(String section) {
    return sectionBudget(section) - expenseInSection(section);
  }

  void removeTransactionIfPresent(Transaction tran) {
    _loadedTransactions.remove(tran);
    _budget.removeTransaction(tran);
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
    return budget.allotted
        .getCategory(category)
        .value;
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
      total += budget.allotted
          .getCategory(category)
          .value;
    }
    return total;
  }
}
