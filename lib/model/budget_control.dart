import 'dart:async';

import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/data_types/account.dart';
import 'package:budgetflow/model/data_types/account_list.dart';
import 'package:budgetflow/model/data_types/budget.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/data_types/location.dart';
import 'package:budgetflow/model/data_types/month.dart';
import 'package:budgetflow/model/data_types/priority.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/data_types/transaction_list.dart';
import 'package:budgetflow/model/implementations/budget_accountant.dart';
import 'package:budgetflow/model/implementations/priority_budget_factory.dart';
import 'package:budgetflow/model/implementations/services/account_service.dart';
import 'package:budgetflow/model/implementations/services/history_service.dart';
import 'package:budgetflow/model/implementations/services/location_service.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:budgetflow/model/utils/setup_agent.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:flutter/material.dart';

/// Welcome to our favorite superclass
class BudgetControl {
  ServiceDispatcher dispatcher;
  Color cashFlowColor;
  AccountList accounts;
  Map<Location, Category> locationMap = Map();
  Budget budget;
  BudgetAccountant accountant;

  BudgetControl() {
    dispatcher = ServiceDispatcher();
  }

  Future<bool> isReturningUser() async {
    return await dispatcher.fileService.fileExists(passwordFilepath);
  }

  Future<bool> passwordIsValid(String secret) {
    return dispatcher.encryptionService.validatePassword(secret);
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

  bool get isDispatcherStarted => dispatcher != null;

  bool _isLoaded() {
    return dispatcher.fileService != null &&
        dispatcher.encryptionService != null &&
        dispatcher.historyService != null &&
        dispatcher.achievementService != null &&
        dispatcher.locationService != null;
  }

  Future _load() async {
    await dispatcher.registerAndStart(AccountService(dispatcher));
    await dispatcher.registerAndStart(HistoryService(dispatcher));
    await dispatcher.registerAndStart(LocationService(dispatcher));
    budget = await dispatcher.historyService.getLatestMonthBudget();
    accountant = BudgetAccountant(budget);
    _initLocationMap();
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
    print('BudgetControl: Beginning save...');
    await dispatcher.encryptionService.save();
    print('BudgetControl: Saved EncryptionService.');
    await dispatcher.historyService.save();
    print('BudgetControl: Saved HistoryService.');
    await dispatcher.achievementService.save();
    print('BudgetControl: Saved AchievementService.');
    await dispatcher.accountService.save();
    print('BudgetControl: Saved AccountService.');
    print('BudgetControl: Save complete.');
  }

  Future setPassword(String newSecret) async {
    dispatcher.encryptionService.registerPassword(newSecret);
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
    await BudgetingApp.control.setPassword(SetupAgent.pin);
    print('BudgetControl: Password set.');
    addNewBudget(PriorityBudgetFactory().newFromInfo());
    print('BudgetControl: Budget added.');
    if (SetupAgent.savings != 0) {
      dispatcher.accountService.addAccount(Account(
        methodName: 'Savings',
        accountName: 'Savings',
      ));
    }
    await save();
    print('BudgetControl: Saved successfully.');
    return true;
  }

  void addNewBudget(Budget toAdd) {
    Month m = Month.fromBudget(toAdd);
    dispatcher.historyService.add(m);
    budget = toAdd;
    accountant = BudgetAccountant(budget);
    save();
  }

  void removeTransactionIfPresent(Transaction tran) {
    budget.removeTransaction(tran);
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
