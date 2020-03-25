import 'package:budgetflow/model/account.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AccountEditPage extends StatefulWidget {
  final Account account;

  AccountEditPage._(this.account);

  @override
  State<StatefulWidget> createState() => _AccountEditPageState(account);

  static Future<Account> show(Account toEdit, BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AccountEditPage._(toEdit),
      ),
    );
    return result;
  }
}

class _AccountEditPageState extends State<AccountEditPage> {
  final Account initialAccount;

  String accountName;
  String methodName;

  final _formKey = GlobalKey<FormState>();

  _AccountEditPageState(this.initialAccount);

  @override
  void initState() {
    super.initState();
    accountName = initialAccount.accountName;
    methodName = initialAccount.methodName;
  }

  Widget _buildAccountNameField() {
    return TextFormField(
      initialValue: initialAccount.accountName,
      onSaved: (value) {
        setState(() {
          accountName = value;
        });
      },
    );
  }

  Widget _buildMethodNameField() {
    return TextFormField(
      initialValue: initialAccount.methodName,
      onSaved: (value) {
        setState(() {
          accountName = value;
        });
      },
    );
  }

  Widget _buildAccountNameRow() {
    return Row(
      children: <Widget>[
        Text('Account name', style: TextStyle(fontSize: 16)),
        Container(width: 24),
        Expanded(child: _buildAccountNameField()),
      ],
    );
  }

  Widget _buildMethodNameRow() {
    return Row(
      children: <Widget>[
        Text('Payment method name', style: TextStyle(fontSize: 16)),
        Container(width: 24),
        Expanded(child: _buildMethodNameField()),
      ],
    );
  }

  Widget _buildButton() {
    return RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          Account result = Account(
            methodName: methodName,
            accountName: accountName,
          );
          BudgetingApp.control.accounts.remove(initialAccount);
          BudgetingApp.control.paymentMethods.remove(initialAccount);
          BudgetingApp.control.accounts.add(result);
          BudgetingApp.control.paymentMethods.add(result);
          BudgetingApp.control.save();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account'),
      ),
      body: Form(
        key: _formKey,
        child: Padding24(
          child: ListView(
            children: <Widget>[
              _buildAccountNameRow(),
              _buildMethodNameRow(),
              _buildButton(),
            ],
            shrinkWrap: true,
          ),
        ),
      ),
    );
  }
}
