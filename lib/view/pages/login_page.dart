import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  static bool valid = false;
  static final validationKey = GlobalKey<FormState>();
  TextFormField pinLoginInput;
  RaisedButton loginButton;
  Scaffold loginPage;

  LoginPageState() {
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
        checkValidity(value);
        return null;
      },
      obscureText: true,
    );
  }

  Future checkValidity(value) async {
    if (await BudgetingApp.userController.passwordIsValid(value)) valid = true;
  }

  void _initLoginButton() {
    loginButton = RaisedButton(
      onPressed: () {
        if (validationKey.currentState.validate()) {
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

  void _initLoginPage() {
    loginPage = Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Please Login'),
          Column(
            children: <Widget>[
              Form(
                key: validationKey,
                child: pinLoginInput,
              ),
              loginButton
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => loginPage;
}
