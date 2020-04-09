import 'package:budgetflow/model/utils/setup_agent.dart';
import 'package:budgetflow/view/pages/setup/savings_depletion_info_page.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:flutter/material.dart';

class FinancialInfoPage extends StatefulWidget {
  static const ROUTE = '/financialInfoPage';

  @override
  State<StatefulWidget> createState() {
    return _FinancialInfoPageState();
  }
}

class _FinancialInfoPageState extends State<FinancialInfoPage> {
  final _formKey = GlobalKey<FormState>();

  Widget _buildIncomeInput() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Monthly Income'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) return InputValidator.requiredMessage;
        if (!InputValidator.dollarAmount(value))
          return InputValidator.dollarMessage;
        return null;
      },
      onSaved: (String value) {
        SetupAgent.income = double.parse(value);
        print(SetupAgent.income);
      },
    );
  }

  Widget _buildSavingsInput() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Total Saved'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) return InputValidator.requiredMessage;
        if (!InputValidator.dollarAmount(value))
          return InputValidator.dollarMessage;
        return null;
      },
      onSaved: (String value) {
        SetupAgent.savings = double.parse(value);
        print(SetupAgent.savings);
      },
    );
  }

  Widget _buildButton() {
    return RaisedButton(
        child: Text('Next'),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            Navigator.of(context).push(
                RouteUtil.routeWithSlideTransition(SavingsDepletionInfoPage()));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    var incomeInput = _buildIncomeInput();
    var savingsInput = _buildSavingsInput();
    var nextButton = _buildButton();

    return Scaffold(
      appBar: AppBar(title: Text('Setup')),
      body: Padding24(
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            incomeInput,
            savingsInput,
            Container(height: 24),
            nextButton
          ], mainAxisAlignment: MainAxisAlignment.center),
        ),
      ),
    );
  }
}
