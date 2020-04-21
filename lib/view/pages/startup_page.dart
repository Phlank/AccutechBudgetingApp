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
  Future<bool> _builderPrep() async {
    await _registerServices();
    return _isReturningUser();
  }

  Future _registerServices() async {
    var dispatcher = BudgetingApp.control.dispatcher;
    await dispatcher.registerAndStart(FileService(dispatcher));
    await dispatcher.registerAndStart(EncryptionService(dispatcher));
  }

  bool _isReturningUser() {
    var dispatcher = BudgetingApp.control.dispatcher;
    return dispatcher.encryptionService.passwordExists();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _builderPrep(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          bool userIsReturning = snapshot.data;
          if (userIsReturning) {
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
