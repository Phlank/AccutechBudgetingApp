import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/view/pages/add_transaction.dart';
import 'package:budgetflow/view/pages/first_load.dart';
import 'package:budgetflow/view/pages/home_page.dart';
import 'package:budgetflow/view/pages/login_page.dart';
import 'package:budgetflow/view/pages/setup_page.dart';
import 'package:budgetflow/view/pages/user_page.dart';
import 'package:budgetflow/view/sidebar/user_catagory_displays.dart';
import 'package:budgetflow/view/sidebar/user_info_display.dart';
import 'package:flutter/material.dart';

class BudgetingApp extends StatelessWidget {
  static BudgetControl userController = new BudgetControl();
  static bool newUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tree Financial Wellness',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: HomePage(),
      routes: {
        SetupPage.ROUTE: (BuildContext context) => SetupPage(),
        LoginPage.ROUTE: (BuildContext context) => LoginPage(),
        '/knownUser': (BuildContext context) => UserPage(),
        '/edit': (BuildContext context) =>
            EditInformationDirectory(userController.getBudget()),
        GeneralCategory.NEEDS_ROUTE: (BuildContext context) => GeneralCategory('needs'),
        GeneralCategory.WANTS_ROUTE: (BuildContext context) => GeneralCategory('wants'),
        GeneralCategory.SAVINGS_ROUTE: (BuildContext context) => GeneralCategory('savings'),
        '/newTransaction': (BuildContext context) => AddTransaction(),
        FirstLoad.ROUTE: (BuildContext context) => FirstLoad(),
      }, //Routes
    );
  }
} // BudgetingApp
