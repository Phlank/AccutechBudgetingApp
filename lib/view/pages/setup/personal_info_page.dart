import 'package:budgetflow/model/utils/setup_agent.dart';
import 'package:budgetflow/view/pages/setup/financial_info_page.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  static const ROUTE = '/personalInfoPage';

  @override
  State<StatefulWidget> createState() {
    return _PersonalInfoPageState();
  }
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();

  String _name, _age;

  @override
  Widget build(BuildContext context) {
    var nameInput = TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) return InputValidator.requiredMessage;
        if (!InputValidator.name(value)) return 'Must be a valid name';
        return null;
      },
      onSaved: (String value) {
        SetupAgent.name = value;
        print(SetupAgent.name);
      },
    );

    var ageInput = TextFormField(
      decoration: InputDecoration(labelText: 'Age'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) return InputValidator.requiredMessage;
        if (!InputValidator.age(value)) return 'Must be a valid number';
        return null;
      },
      onSaved: (String value) {
        SetupAgent.age = value;
        print(SetupAgent.age);
      },
    );

    var nextButton = RaisedButton(
        child: Text('Next'),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            Navigator.of(context)
                .push(RouteUtil.routeWithSlideTransition(FinancialInfoPage()));
          }
        });

    return Scaffold(
      appBar: AppBar(title: Text('Setup')),
      body: Padding24(
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            nameInput,
            ageInput,
            Container(height: 24),
            nextButton
          ], mainAxisAlignment: MainAxisAlignment.center),
        ),
      ),
    );
  }
}
