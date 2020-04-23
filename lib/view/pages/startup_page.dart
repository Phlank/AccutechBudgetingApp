import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/implementations/services/encryption_service.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/error_page.dart';
import 'package:budgetflow/view/pages/login_page.dart';
import 'package:budgetflow/view/pages/setup/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StartupPage extends StatefulWidget {
  static int cardOrder = 0;

  @override
  _StartupPageState createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  Future<bool> _builderFuture;

  Future<bool> _builderPrep() async {
    BudgetingApp.control = BudgetControl();
    await _registerServices();
    return _isReturningUser();
  }

  Future _registerServices() async {
    var dispatcher = BudgetingApp.control.dispatcher;
    await dispatcher.registerAndStart(FileService(dispatcher));
    await dispatcher.registerAndStart(EncryptionService(dispatcher));
  }

  bool _isReturningUser() {
    print('StartupPage: Checking for returning user...');
    var dispatcher = BudgetingApp.control.dispatcher;
    print('StartupPage: Returning user: ' +
        dispatcher.encryptionService.passwordExists().toString());
    return dispatcher.encryptionService.passwordExists();
  }

  @override
  void initState() {
    super.initState();
    _builderFuture = _builderPrep();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _builderFuture,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          bool userIsReturning = snapshot.data;
          if (userIsReturning) {
            print('StartupPage: Returning user.');
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
}
