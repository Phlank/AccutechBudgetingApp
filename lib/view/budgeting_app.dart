import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/view/pages/achievements_page.dart';
import 'package:budgetflow/view/pages/first_load.dart';
import 'package:budgetflow/view/pages/home_page.dart';
import 'package:budgetflow/view/pages/login_page.dart';
import 'package:budgetflow/view/pages/user_page.dart';
import 'package:budgetflow/view/sidebar/account_display.dart';
import 'package:budgetflow/view/sidebar/user_category_displays.dart';
import 'package:flutter/material.dart';

class BudgetingApp extends StatelessWidget {
  static const NAME = 'Budgetflow';
  static BudgetControl control = new BudgetControl();
  static final int r = 0,
      g = 153,
      b = 0;
  static final Map<int, Color> colors = {
    50: Color.fromRGBO(r, g, b, .1),
    100: Color.fromRGBO(r, g, b, .2),
    200: Color.fromRGBO(r, g, b, .3),
    300: Color.fromRGBO(r, g, b, .4),
    400: Color.fromRGBO(r, g, b, .5),
    500: Color.fromRGBO(r, g, b, .6),
    600: Color.fromRGBO(r, g, b, .7),
    700: Color.fromRGBO(r, g, b, .8),
    800: Color.fromRGBO(r, g, b, .9),
    900: Color.fromRGBO(r, g, b, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: NAME,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xff009900, colors),
        backgroundColor: Colors.black,
      ),
      home: HomePage(),
      routes: {
        LoginPage.ROUTE: (BuildContext context) => LoginPage(),
        UserPage.ROUTE: (BuildContext context) => UserPage(),
        GeneralCategory.needsRoute: (BuildContext context) =>
            GeneralCategory('needs'),
        GeneralCategory.wantsRoute: (BuildContext context) =>
            GeneralCategory('wants'),
        GeneralCategory.savingsRoute: (BuildContext context) =>
            GeneralCategory('savings'),
        FirstLoad.ROUTE: (BuildContext context) => FirstLoad(),
        AccountDisplay.ROUTE: (BuildContext context) => AccountDisplay(),
        AchievementsPage.ROUTE: (BuildContext context) => AchievementsPage(),
      }, //Routes
    );
  }
} // BudgetingApp
