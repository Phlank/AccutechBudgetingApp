import 'package:budgetflow/global/achievements.dart';
import 'package:budgetflow/model/implementations/services/achievement_service.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/basic_loading_page.dart';
import 'package:budgetflow/view/pages/error_page.dart';
import 'package:budgetflow/view/pages/setup/kids_pets_info_page.dart';
import 'package:budgetflow/view/pages/setup/setup_finished_page.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:flutter/material.dart';

class MoreQuestionsPage extends StatefulWidget {
  static const _BODY_TEXT =
      'Almost done! We have enough information to make your budget, but there\'s more that could help. Do you want to answer more questions?';

  @override
  _MoreQuestionsPageState createState() => _MoreQuestionsPageState();
}

class _MoreQuestionsPageState extends State<MoreQuestionsPage> {
  Future _builderFuture;

  Future _builderPrep() async {
    ServiceDispatcher dispatcher = BudgetingApp.control.dispatcher;
    await dispatcher.registerAndStart(AchievementService(dispatcher));
    print('MoreQuestionsPage: Finished resolving future');
    return true; // Needed or else the FutureBuilder will never resolve.
  }

  @override
  void initState() {
    super.initState();
    _builderFuture = _builderPrep();
  }

  Widget _buildFinishedButton(BuildContext context) {
    return RaisedButton(
      child: Text('Take me to my budget!'),
      onPressed: () {
        BudgetingApp.control.dispatcher.achievementService
            .incrementProgress(Achievements.achRushing);
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

  Widget _buildMoreQuestionsScaffold() {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Padding24(
        child: Column(
          children: <Widget>[
            Text(
              MoreQuestionsPage._BODY_TEXT,
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _builderFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("MoreQuestionsPage: Snapshot has data.");
            return _buildMoreQuestionsScaffold();
          } else if (snapshot.hasError) {
            print("MoreQuestionsPage: Snapshot has error.");
            print(snapshot.error);
            return ErrorPage();
          } else {
            return BasicLoadingPage(
              title: 'Loading',
              message: 'Preparing some items for you...',
            );
          }
        });
  }
}
