import 'package:budgetflow/model/implementations/services/account_service.dart';
import 'package:budgetflow/model/implementations/services/achievement_service.dart';
import 'package:budgetflow/model/implementations/services/encryption_service.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/model/implementations/services/history_service.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/first_load.dart';
import 'package:budgetflow/view/pages/setup/welcome_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetupFinishedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SetupFinishedPageState();
  }
}

class _SetupFinishedPageState extends State<SetupFinishedPage> {
  Future _setup;

  @override
  void initState() {
    super.initState();
    _setup = _triggerSetup();
  }

  Future _triggerSetup() async {
    ServiceDispatcher dispatcher = BudgetingApp.control.dispatcher;
    await dispatcher.registerAndStart(FileService(dispatcher));
    await dispatcher.registerAndStart(EncryptionService(dispatcher));
    await dispatcher.registerAndStart(AchievementService(dispatcher));
    await dispatcher.registerAndStart(AccountService(dispatcher));
    await dispatcher.registerAndStart(HistoryService(dispatcher));
    await BudgetingApp.control.setup();
  }

  Widget _buildConstrainedIndicator() {
    return Row(
      children: <Widget>[
        ConstrainedBox(
          child: CircularProgressIndicator(
            value: null,
          ),
          constraints: BoxConstraints(
            minWidth: 100,
            minHeight: 100,
            maxHeight: 100,
            maxWidth: 100,
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _loadingBudgetPage() {
    return Scaffold(
        appBar: AppBar(title: Text('Setup')),
        body: Column(
          children: <Widget>[
            _buildConstrainedIndicator(),
            Container(
              height: 24,
            ),
            Text(
              'Loading your budget...',
              textAlign: TextAlign.center,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _setup,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('Snapshot has data');
            return FirstLoad();
          } else if (snapshot.hasError) {
            print('Snapshot has error');
            return WelcomePage();
          } else {
            return _loadingBudgetPage();
          }
        });
  }
}
