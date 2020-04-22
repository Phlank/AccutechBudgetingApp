import 'package:budgetflow/model/implementations/services/account_service.dart';
import 'package:budgetflow/model/implementations/services/achievement_service.dart';
import 'package:budgetflow/model/implementations/services/encryption_service.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/model/implementations/services/history_service.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/basic_loading_page.dart';
import 'package:budgetflow/view/pages/error_page.dart';
import 'package:budgetflow/view/pages/user_page.dart';
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
    print('SetupFinishedPage: Init state.');
    super.initState();
    _builderFuture = _prepFuture();
  }

  Future _prepFuture() async {
    print('SetupFinishedPage: Starting Future...');
    ServiceDispatcher dispatcher = BudgetingApp.control.dispatcher;
    print('SetupFinishedPage: Registering services...');
    await dispatcher.registerAndStart(FileService(dispatcher));
    await dispatcher.registerAndStart(EncryptionService(dispatcher));
    await dispatcher.registerAndStart(AchievementService(dispatcher));
    await dispatcher.registerAndStart(AccountService(dispatcher));
    await dispatcher.registerAndStart(HistoryService(dispatcher));
    print('SetupFinishedPage: Finished registering all services.');
    await BudgetingApp.control.setup();
    print('SetupFinishedPage: Finished Future.');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _builderFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('SetupFinishedPage: Snapshot has data');
            return UserPage();
          } else if (snapshot.hasError) {
            print('SetupFinishedPage: Snapshot has error');
            print('SetupFinishedPage: ' + snapshot.error.toString());
            return ErrorPage();
          } else {
            return BasicLoadingPage(
              title: 'Loading',
              message: 'Loading your budget...',
            );
          }
        });
  }
}
