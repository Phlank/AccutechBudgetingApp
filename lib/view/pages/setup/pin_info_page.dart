import 'package:budgetflow/model/setup_agent.dart';
import 'package:budgetflow/view/pages/setup/more_questions_page.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:flutter/material.dart';

class PinInfoPage extends StatefulWidget {
  static const ROUTE = '/financialInfoPage';

  @override
  State<StatefulWidget> createState() {
    return _PinInfoPageState();
  }
}

class _PinInfoPageState extends State<PinInfoPage> {
  final _formKey = GlobalKey<FormState>();

  String pin = '';

  Widget _buildPinInput() {
    return TextFormField(
        decoration:
            InputDecoration(labelText: 'Desired PIN', hintText: 'Four digits'),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.isEmpty) return InputValidator.REQUIRED_MESSAGE;
          if (!InputValidator.pin(value)) return InputValidator.PIN_MESSAGE;
          pin = value;
          return null;
        },
        onSaved: (String value) {
          SetupAgent.pin = value;
          print(value);
        },
        obscureText: true);
  }

  Widget _buildConfirmPinInput() {
    return TextFormField(
        decoration: InputDecoration(labelText: 'Confirm PIN'),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.isEmpty) return InputValidator.REQUIRED_MESSAGE;
          if (!InputValidator.pin(value)) return InputValidator.PIN_MESSAGE;
          if (value != pin) return 'Must match above PIN';
          return null;
        },
        obscureText: true);
  }

  Widget _buildButton() {
    return RaisedButton(
        child: Text('Next'),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            Navigator.of(context)
                .push(RouteUtil.routeWithSlideTransition(MoreQuestionsPage()));
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
            _buildPinInput(),
            Container(height: 24),
            _buildConfirmPinInput(),
            Container(height: 24),
            _buildButton(),
          ], mainAxisAlignment: MainAxisAlignment.center),
        ),
      ),
    );
  }
}
