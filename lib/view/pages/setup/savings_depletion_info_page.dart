import 'package:budgetflow/model/setup_agent.dart';
import 'package:budgetflow/view/pages/setup/housing_info_page.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SavingsDepletionInfoPage extends StatefulWidget {
  static const ROUTE = '/savingsDepletionInfoPage';

  @override
  State<StatefulWidget> createState() => _SavingsDepletionInfoPageState();
}

class _SavingsDepletionInfoPageState extends State<SavingsDepletionInfoPage> {
  final _formKey = GlobalKey<FormState>();

  bool savingsDepletionOption = true;

  Widget _buildRadioYes() {
    return Radio(
      value: true,
      groupValue: savingsDepletionOption,
      onChanged: (value) {
        setState(() {
          savingsDepletionOption = value;
        });
      },
    );
  }

  Widget _buildRadioNo() {
    return Radio(
      value: false,
      groupValue: savingsDepletionOption,
      onChanged: (value) {
        setState(() {
          savingsDepletionOption = value;
        });
      },
    );
  }

  Widget _buildRadioRow() {
    return Row(
      children: <Widget>[
        _buildRadioYes(),
        Text('Yes'),
        Container(width: 48),
        _buildRadioNo(),
        Text('No')
      ],
    );
  }

  Widget _buildSavingsDepletionInput() {
    return TextFormField(
      initialValue: '0',
      decoration: InputDecoration(labelText: 'Savings spent each month'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) return InputValidator.requiredMessage;
        if (!InputValidator.dollarAmount(value))
          return InputValidator.dollarMessage;
        return null;
      },
      onSaved: (String value) {
        SetupAgent.depletion = savingsDepletionOption;
        SetupAgent.savingsPull = double.parse(value);
        print(SetupAgent.depletion);
        print(SetupAgent.savingsPull);
      },
      enabled: savingsDepletionOption,
    );
  }

  Widget _buildButton() {
    return RaisedButton(
        child: Text('Next'),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            Navigator.of(context)
                .push(RouteUtil.routeWithSlideTransition(HousingInfoPage()));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setup')),
      body: Padding24(
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Text(
                'Do you intend to rely on savings to pay for monthly expenses?'),
            _buildRadioRow(),
            _buildSavingsDepletionInput(),
            Container(height: 24),
            _buildButton()
          ], mainAxisAlignment: MainAxisAlignment.center),
        ),
      ),
    );
  }
}
