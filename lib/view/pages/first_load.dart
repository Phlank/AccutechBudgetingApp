import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/new_user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FirstLoad extends StatefulWidget {
  static const String ROUTE = '/firstLoad';

  @override
  _FirstLoadState createState() => _FirstLoadState();
}

class _FirstLoadState extends State<FirstLoad> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: BudgetingApp.userController.initialize(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          print("Snapshot has data: " + snapshot.data.toString());
          return UserPage();
        } else if (snapshot.hasError) {
          print("Snapshot has error");
          Error snap = snapshot.error;
          print(snap.stackTrace);
          return Scaffold(
              body: Center(
                child: Text('Error ' + snapshot.error.toString()),
              ));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
