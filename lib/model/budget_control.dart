import 'dart:async';

import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/data_types/account.dart';
import 'package:budgetflow/model/data_types/account_list.dart';
import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/data_types/location.dart';
import 'package:budgetflow/model/data_types/payment_method.dart';
import 'package:budgetflow/model/data_types/priority.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/data_types/transaction_list.dart';
import 'package:budgetflow/model/implementations/budget_accountant.dart';
import 'package:budgetflow/model/implementations/priority_budget_factory.dart';
import 'package:budgetflow/model/implementations/services/achievement_service.dart';
import 'package:budgetflow/model/implementations/services/encryption_service.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/model/implementations/services/history_service.dart';
import 'package:budgetflow/model/implementations/services/location_service.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:budgetflow/model/utils/setup_agent.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:flutter/material.dart';

import 'data_types/achievement.dart';
import 'data_types/category.dart';
import 'data_types/month.dart';

/// Welcome to our favorite superclass
class BudgetControl {
  ServiceDispatcher _dispatcher;
  Color cashFlowColor;
  List<PaymentMethod> paymentMethods;
  AccountList accounts;
  Map<Location, Category> locationMap = Map();
  Budget budget;
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
    _dispatcher = ServiceDispatcher();
    _dispatcher.register(FileService(_dispatcher));
    _dispatcher.register(EncryptionService(_dispatcher));
    _dispatcher.startAll();
    _initVariables();
  }

  void _initVariables() {
    paymentMethods = [PaymentMethod('Cash')];
  }

  Future<bool> isReturningUser() async {
    return await _dispatcher.getFileService().fileExists(passwordFilepath);
  }

  Future<bool> passwordIsValid(String secret) {
    return _dispatcher.getEncryptionService().validatePassword(secret);
  }

  Future<bool> initialize() async {
    if (await isReturningUser()) {
      if (_isLoaded()) {
        return true;
      } else {
        await _load();
        return true;
      }
    } else {
      return false;
    }
  }

  bool _isLoaded() {
    return _dispatcher.getFileService() != null &&
        _dispatcher.getEncryptionService() != null &&
        _dispatcher.getHistoryService() != null &&
        _dispatcher.getAchievementService() != null &&
        _dispatcher.getLocationService() != null;
  }

  Future _load() async {
    await _dispatcher.registerAndStart(HistoryService(_dispatcher));
    await _dispatcher.registerAndStart(LocationService(_dispatcher));
    await _dispatcher.registerAndStart(AchievementService(_dispatcher));
    budget = await _dispatcher.getHistoryService().getLatestMonthBudget();
    accountant = BudgetAccountant(budget);
    await _loadAccounts();
    _initLocationMap();
//    _initLocationListener();
  }

  Future _loadAccounts() async {
    AccountList loadedAccounts = Serializer.unserialize(
      methodListKey,
      await _dispatcher.getFileService().readAndDecryptFile(accountsFilepath),
    );
    for (Account account in loadedAccounts) {
      addAccount(account);
    }
  }

  void _initLocationMap() {
    locationMap = Map<Location, Category>();
    budget.transactions.forEach((transaction) {
      if (transaction.location != null &&
          !locationMap.containsKey(transaction.location)) {
        locationMap[transaction.location] = transaction.category;
      }
    });
  }

//  void _initLocationListener() {
//    positionStream = Geolocator()
//        .getPositionStream(LocationOptions(
//            accuracy: LocationAccuracy.high,
//            distanceFilter: 10,
//            timeInterval: 10))
//        .listen((position) {
//      Location streamLocation = Location.fromGeolocatorPosition(position);
//      locationMap.forEach((location, category) async {
//        if (await streamLocation.distanceTo(location) < 10) {
//          // TODO Trigger notification
//          print('In range of location ' +
//              location.latitude.toString() +
//              ', ' +
//              location.longitude.toString() +
//              ' for category ' +
//              category.name);
//        }
//      });
//    });
//  }

  Future save() async {
    var historyService = _dispatcher.getHistoryService();
    if (historyService.currentMonth == null) {
      historyService.add(Month.fromBudget(budget));
    }
    historyService.save();
  }

  Future setPassword(String newSecret) async {
    _dispatcher.getEncryptionService().registerPassword(newSecret);
  }

  Budget getBudget() {
    return budget;
  }

  TransactionList getLoadedTransactions() {
    return budget.transactions;
  }

  TransactionList getTransactionsInCategory(Category category) {
    TransactionList transactions = TransactionList();
    budget.transactions.forEach((transaction) {
      if (transaction.category == category) {
        transactions.add(transaction);
      }
    });
    return transactions;
  }

  void addTransaction(Transaction t) {
    budget.addTransaction(t);
    save();
  }

  void removeTransaction(Transaction transaction) {
    budget.removeTransaction(transaction);
    save();
  }

  Future<bool> setup() async {
    await setPassword(SetupAgent.pin);
    await _dispatcher.registerAndStart(HistoryService(_dispatcher));
    await _dispatcher.registerAndStart(LocationService(_dispatcher));
    await _dispatcher.registerAndStart(AchievementService(_dispatcher));
    addNewBudget(PriorityBudgetFactory().newFromInfo(SetupAgent()));
    return true;
  }

  double getCashFlow() {
    double amt = budget.expectedIncome -
        budget.allotted
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

  void addNewBudget(Budget b) {
    Month m = Month.fromBudget(b);
    _dispatcher.getHistoryService().add(m);
    budget = b;
    accountant = BudgetAccountant(budget);
    save();
  }

  double expenseTotal() {
    double spent = 0.0;
    for (int i = 0; i < budget.transactions.length; i++) {
      spent += budget.transactions[i].amount;
    }
    return spent;
  }

  double expenseInSection(String section) {
    double spent = 0.0;
    for (Category cat in sectionMap[section]) {
      for (int i = 0; i < budget.transactions.length; i++) {
        Category rel = budget.transactions[i].category;
        if (rel == cat) {
          spent += budget.allotted
              .getCategory(rel)
              .value;
        }
      }
    }
    return spent;
  }

  void removeTransactionIfPresent(Transaction tran) {
    budget.removeTransaction(tran);
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
    budget = PriorityBudgetFactory().newMonthBudget(budget);
    accountant = BudgetAccountant(budget);
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
