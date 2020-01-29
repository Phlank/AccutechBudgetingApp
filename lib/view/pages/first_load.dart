import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/sidebar/user_catagory_displays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FirstLoad extends StatefulWidget {
  @override
  FirstLoadState createState() => FirstLoadState();
}

class FirstLoadState extends State<FirstLoad> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: BudgetingApp.userController.initialize(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          Navigator.pushNamed(context, '/knownUser');
        } else if (snapshot.hasError) {
          Error snap = snapshot.error;
          print(snap.stackTrace);
          return Scaffold(
              body: Center(
            child: Text('Error ' + snapshot.error.toString()),
          ));
        }
        return GeneralSliderCategory(BudgetingApp.userController).loadingPage();
      },
    );
  }
}
