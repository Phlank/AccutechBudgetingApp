import 'package:budgetflow/model/payment/payment_method.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/home_page.dart';
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
  Future setup;

  @override
  void initState() {
    super.initState();
    if (!BudgetingApp.control.paymentMethods.contains(PaymentMethod.cash)) {
      BudgetingApp.control.paymentMethods.add(PaymentMethod.cash);
    }
    setup = BudgetingApp.control.setup();
  }

  Widget _buildConstrainedIndicator() {
    return Row(
      children: <Widget>[
        ConstrainedBox(
            child: CircularProgressIndicator(
              value: null,
            ),
            constraints: BoxConstraints(
                minWidth: 100, minHeight: 100, maxHeight: 100, maxWidth: 100))
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setup,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('Snapshot has data');
            return HomePage();
          } else if (snapshot.hasError) {
            print('Snapshot has error');
            return WelcomePage();
          } else {
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
        });
  }
}
