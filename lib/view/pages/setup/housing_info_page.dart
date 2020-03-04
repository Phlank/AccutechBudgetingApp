import 'package:budgetflow/model/setup_agent.dart';
import 'package:budgetflow/view/pages/setup/pin_info_page.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HousingInfoPage extends StatefulWidget {
  static const ROUTE = '/financialInfoPage';

  @override
  State<StatefulWidget> createState() {
    return _HousingInfoPageState();
  }
}

class _HousingInfoPageState extends State<HousingInfoPage> {
  final _formKey = GlobalKey<FormState>();

  Widget _buildHousingInput() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Housing cost per month'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) return InputValidator.requiredMessage;
        if (!InputValidator.dollarAmount(value))
          return InputValidator.dollarMessage;
        return null;
      },
      onSaved: (String value) {
        SetupAgent.housing = double.parse(value);
        print(SetupAgent.housing);
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
                RouteUtil.routeWithSlideTransition(PinInfoPage()));
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
            _buildHousingInput(),
            Container(height: 24),
            _buildButton()
          ], mainAxisAlignment: MainAxisAlignment.center),
        ),
      ),
    );
  }
}
