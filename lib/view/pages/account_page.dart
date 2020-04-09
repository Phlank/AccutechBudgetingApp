import 'package:budgetflow/model/data_types/account.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  final Account account;

  AccountPage(this.account);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Info'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            // TODO display a continue/cancel dialog and respond to delete button press
          },
        )
      ]),
      body: Padding24(
        child: ListView(
          padding: EdgeInsets.all(8),
          shrinkWrap: true,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(account.accountName),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
