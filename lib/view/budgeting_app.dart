import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/sidebar/user_catagory_displays.dart';
import 'package:budgetflow/sidebar/user_info_display.dart';
import 'package:budgetflow/view/pages/first_load.dart';
import 'package:budgetflow/view/pages/home_page.dart';
import 'package:budgetflow/view/pages/user_page.dart';
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
      initialRoute: '/',
      //InitialRoute
      routes: {
        '/knownUser': (context) => UserPage(),
        '/edit': (context) =>
            EditInformationDirectory(userController.getBudget()),
        '/needs': (context) => Needs(userController),
        '/wants': (context) => Wants(userController),
        '/savings': (context) => Savings(userController),
        '/newTransaction': (context) => NewTransaction(userController),
        '/firstLoad': (context) => FirstLoad(),
      }, //Routes
    );
  }
} // BudgetingApp
