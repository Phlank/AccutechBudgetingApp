import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/view/pages/add_transaction.dart';
import 'package:budgetflow/view/pages/first_load.dart';
import 'package:budgetflow/view/pages/home_page.dart';
import 'package:budgetflow/view/pages/login_page.dart';
import 'package:budgetflow/view/pages/setup_page.dart';
import 'package:budgetflow/view/pages/new_user_page.dart';
import 'package:budgetflow/view/sidebar/account_display.dart';
import 'package:budgetflow/view/sidebar/user_catagory_displays.dart';
import 'package:budgetflow/view/sidebar/user_info_display.dart';
import 'package:flutter/material.dart';

class BudgetingApp extends StatelessWidget {
  static BudgetControl userController = new BudgetControl();
  static int r=0,g=153,b=0;
  Map<int,Color> colors = {
    50:Color.fromRGBO(r,g,b, .1),
    100:Color.fromRGBO(r,g,b, .2),
    200:Color.fromRGBO(r,g,b, .3),
    300:Color.fromRGBO(r,g,b, .4),
    400:Color.fromRGBO(r,g,b, .5),
    500:Color.fromRGBO(r,g,b, .6),
    600:Color.fromRGBO(r,g,b, .7),
    700:Color.fromRGBO(r,g,b, .8),
    800:Color.fromRGBO(r,g,b, .9),
    900:Color.fromRGBO(r,g,b, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tree Financial Wellness',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xff009900, colors),
        backgroundColor: Colors.black,
      ),
      home: HomePage(),
      routes: {
        SetupPage.ROUTE: (BuildContext context) => SetupPage(),
        LoginPage.ROUTE: (BuildContext context) => LoginPage(),
        '/knownUser': (BuildContext context) => UserPage(),
        '/edit': (BuildContext context) =>
            EditInformationDirectory(userController.getBudget()),
        GeneralCategory.NEEDS_ROUTE: (BuildContext context) =>
            GeneralCategory('needs'),
        GeneralCategory.WANTS_ROUTE: (BuildContext context) =>
            GeneralCategory('wants'),
        GeneralCategory.SAVINGS_ROUTE: (BuildContext context) =>
            GeneralCategory('savings'),
        AddTransaction.ROUTE: (BuildContext context) => AddTransaction(),
        FirstLoad.ROUTE: (BuildContext context) => FirstLoad(),
        AccountDisplay.ROUTE:(BuildContext context) => AccountDisplay(),
      }, //Routes
    );
  }
} // BudgetingApp
