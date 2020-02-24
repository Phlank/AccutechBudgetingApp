import 'dart:async';

import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/first_load.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String ROUTE = '/login';

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static bool valid = false;
  var _formKey = GlobalKey<FormState>();
  TextFormField pinLoginInput;
  RaisedButton loginButton;

  _LoginPageState() {
    _initControls();
  }

  void _initControls() {
    _initPinLoginInput();
    _initLoginButton();
    _initLoginPage();
  }

  void _initPinLoginInput() {
    pinLoginInput = TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'PIN',
      ),
      validator: (value) {
        if (value.isEmpty) return 'Enter your PIN';
        if (!InputValidator.pin(value))
          return 'your PIN should only be 4 numbers';
        validatePassword(value);
        return null;
      },
      obscureText: true,
      textAlign: TextAlign.center,
      autofocus: true,
    );
  }

  Future validatePassword(value) async {
    if (await BudgetingApp.userController.passwordIsValid(value)) {
      valid = true;
      print("Valid");
      Navigator.pop(context);
      Navigator.pushNamed(context, FirstLoad.ROUTE);
    }
  }

  void _initLoginButton() {
    loginButton = RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          if (valid) {
            Navigator.pushNamed(context, '/firstLoad');
          } else {
            AlertDialog(
              content: Text('wrong pin'),
            );
          }
        }
      },
      child: Text('Submit'),
    );
  }

  Widget _initLoginPage() {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Padding(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Please Login'),
              Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: pinLoginInput,
                  ),
                  loginButton
                ],
              )
            ],
          ),
          padding: EdgeInsets.all(8.0),
        ));
  }

  @override
  Widget build(BuildContext context) => _initLoginPage();
}
