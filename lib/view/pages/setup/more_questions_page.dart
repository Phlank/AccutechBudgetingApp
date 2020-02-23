import 'package:budgetflow/model/budget/factory/priority_budget_factory.dart';
import 'package:budgetflow/model/setup_agent.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/setup/kids_pets_info_page.dart';
import 'package:budgetflow/view/pages/setup/setup_finished_page.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:flutter/material.dart';

class MoreQuestionsPage extends StatelessWidget {
  static const _BODY_TEXT =
      'Almost done! We have enough information to make your budget, but there\'s more that could help. Do you want to answer more questions?';

  Widget _buildFinishedButton(BuildContext context) {
    return RaisedButton(
      child: Text('Take me to my budget!'),
      onPressed: () {
        BudgetingApp.userController.addNewBudget(PriorityBudgetFactory()
            .newFromInfo(
                SetupAgent.income,
                SetupAgent.housing,
                SetupAgent.depletion,
                SetupAgent.savingsPull,
                SetupAgent.kids,
                SetupAgent.pets));
        Navigator.of(context)
            .push(RouteUtil.routeWithSlideTransition(SetupFinishedPage()));
      },
    );
  }

  Widget _buildMoreQuestionsButton(BuildContext context) {
    return RaisedButton(
      child: Text('Answer more questions'),
      onPressed: () {
        Navigator.of(context)
            .push(RouteUtil.routeWithSlideTransition(KidsPetsInfoPage()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Padding24(
        child: Column(
          children: <Widget>[
            Text(
              _BODY_TEXT,
              textAlign: TextAlign.center,
            ),
            Container(height: 24),
            _buildFinishedButton(context),
            _buildMoreQuestionsButton(context)
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
