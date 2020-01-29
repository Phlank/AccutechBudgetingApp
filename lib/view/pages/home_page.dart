import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/error_page.dart';
import 'package:budgetflow/view/pages/login_page.dart';
import 'package:budgetflow/view/pages/setup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  static int cardOrder = 0;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) =>
      FutureBuilder(
        future: BudgetingApp.userController.isReturningUser(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            bool user = snapshot.data;
            if (user) {
              BudgetingApp.newUser = false;
              return new LoginPage();
            } else {
              BudgetingApp.newUser = true;
              return SetupPage();
            }
          } else if (snapshot.hasError) {
            return ErrorPage();
          } else {
            return new CircularProgressIndicator();
          }
          return Scaffold(
              body: Column(
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                        text: 'deciding',
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  )
                ],
              ));
        },
      );
}
