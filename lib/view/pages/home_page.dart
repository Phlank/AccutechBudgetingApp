import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/error_page.dart';
import 'package:budgetflow/view/pages/login_page.dart';
import 'package:budgetflow/view/pages/setup/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  static int cardOrder = 0;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: BudgetingApp.control.isReturningUser(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            bool user = snapshot.data;
            if (user) {
              return new LoginPage();
            } else {
              return WelcomePage();
            }
          } else if (snapshot.hasError) {
            return ErrorPage();
          } else {
            return new CircularProgressIndicator();
          }
        },
      );
}
