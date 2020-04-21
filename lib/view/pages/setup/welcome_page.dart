import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/implementations/services/achievement_service.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/setup/personal_info_page.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  static const ROUTE = '/welcomePage';

  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Future _builderFuture;
  static final _titleText = 'Welcome to ' + BudgetingApp.NAME + '!';
  static final _bodyText =
      'To get started, I need to know a few things about you so I can make your budget.';

  Future _builderPrep() async {
    ServiceDispatcher dispatcher = BudgetingApp.control.dispatcher;
    await dispatcher.registerAndStart(AchievementService(dispatcher));
  }

  @override
  void initState() {
    super.initState();
    _builderFuture = _builderPrep();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Padding24(
        child: Column(
          children: <Widget>[
            Text(
              _titleText,
              style: TextStyle(fontSize: 24),
            ),
            Container(height: 24),
            Text(_bodyText),
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
