import 'package:budgetflow/global/defined_achievements.dart';
import 'package:budgetflow/global/strings.dart';
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
        if(BudgetingApp.control.checkAchievement(rushingToTheBudget_NAME)){
          allAchievements[rushingToTheBudget_NAME].setEarned();
          BudgetingApp.control.earnedAchievements.add(allAchievements[rushingToTheBudget_NAME]);
        }
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
