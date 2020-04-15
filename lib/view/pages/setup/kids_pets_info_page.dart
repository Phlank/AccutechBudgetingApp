import 'package:budgetflow/global/defined_achievements.dart';
import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/setup/setup_finished_page.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KidsPetsInfoPage extends StatefulWidget {
  static const ROUTE = '/savingsDepletionInfoPage';

  @override
  State<StatefulWidget> createState() => _KidsPetsInfoPageState();
}

class _KidsPetsInfoPageState extends State<KidsPetsInfoPage> {
  final _formKey = GlobalKey<FormState>();

  bool kidsOption = true;
  bool petsOption = true;

  Widget _buildKidsRadioYes() {
    return Radio(
      value: true,
      groupValue: kidsOption,
      onChanged: (value) {
        setState(() {
          kidsOption = value;
        });
      },
    );
  }

  Widget _buildKidsRadioNo() {
    return Radio(
      value: false,
      groupValue: kidsOption,
      onChanged: (value) {
        setState(() {
          kidsOption = value;
        });
      },
    );
  }

  Widget _buildPetsRadioYes() {
    return Radio(
      value: true,
      groupValue: petsOption,
      onChanged: (value) {
        setState(() {
          petsOption = value;
        });
      },
    );
  }

  Widget _buildPetsRadioNo() {
    return Radio(
      value: false,
      groupValue: petsOption,
      onChanged: (value) {
        setState(() {
          petsOption = value;
        });
      },
    );
  }

  Widget _buildKidsRadioRow() {
    return Row(
      children: <Widget>[
        _buildKidsRadioYes(),
        Text('Yes'),
        Container(width: 24),
        _buildKidsRadioNo(),
        Text('No')
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _buildPetsRadioRow() {
    return Row(
      children: <Widget>[
        _buildPetsRadioYes(),
        Text('Yes'),
        Container(width: 24),
        _buildPetsRadioNo(),
        Text('No')
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _buildButton() {
    return RaisedButton(
        child: Text('Next'),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            Navigator.of(context)
                .push(RouteUtil.routeWithSlideTransition(SetupFinishedPage()));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    if (BudgetingApp.control.checkAchievement(detailingToTheBudget_NAME)) {
      allAchievements[detailingToTheBudget_NAME].setEarned();
      BudgetingApp.control.earnedAchievements.add(
          allAchievements[detailingToTheBudget_NAME]);
    }
    return Scaffold(
      appBar: AppBar(title: Text('Setup')),
      body: Padding24(
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Text('Do you take care of kids?'),
            _buildKidsRadioRow(),
            Container(height: 24),
            Text('Do you have any pets?'),
            _buildPetsRadioRow(),
            Container(height: 24),
            _buildButton()
          ], mainAxisAlignment: MainAxisAlignment.center),
        ),
      ),
    );
  }
}
