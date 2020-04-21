import 'package:budgetflow/model/implementations/services/account_service.dart';
import 'package:budgetflow/model/implementations/services/achievement_service.dart';
import 'package:budgetflow/model/implementations/services/encryption_service.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/model/implementations/services/history_service.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/basic_loading_page.dart';
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
  Future _builderFuture;

  @override
  void initState() {
    super.initState();
    _builderFuture = _prepFuture();
  }

  Future _prepFuture() async {
    ServiceDispatcher dispatcher = BudgetingApp.control.dispatcher;
    await dispatcher.registerAndStart(FileService(dispatcher));
    await dispatcher.registerAndStart(EncryptionService(dispatcher));
    await dispatcher.registerAndStart(AchievementService(dispatcher));
    await dispatcher.registerAndStart(AccountService(dispatcher));
    await dispatcher.registerAndStart(HistoryService(dispatcher));
    await BudgetingApp.control.setup();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _builderFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('Snapshot has data');
            return FirstLoad();
          } else if (snapshot.hasError) {
            print('Snapshot has error');
            return WelcomePage();
          } else {
            return BasicLoadingPage(message: 'Loading your budget...');
          }
        });
  }
}
