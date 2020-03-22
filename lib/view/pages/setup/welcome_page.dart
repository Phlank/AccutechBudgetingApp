import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/setup/personal_info_page.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  static const ROUTE = '/welcomePage';
  static const _TITLE_TEXT = 'Welcome to ' + BudgetingApp.NAME + '!';
  static const _BODY_TEXT =
      'To get started, I need to know a few things about you so I can make your budget.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Padding24(
        child: Column(
          children: <Widget>[
            Text(
              _TITLE_TEXT,
              style: TextStyle(fontSize: 24),
            ),
            Container(height: 24),
            Text(_BODY_TEXT),
            Container(height: 24),
            RaisedButton(
              child: Text('Let\'s go!'),
              onPressed: () {
                BudgetingApp.control = BudgetControl();
                Navigator.of(context).push(
                    RouteUtil.routeWithSlideTransition(PersonalInfoPage()));
              },
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
