import 'package:budgetflow/model/account.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:budgetflow/view/widgets/account/account_edit_page.dart';
import 'package:budgetflow/view/widgets/account/account_list_view.dart';
import 'package:flutter/material.dart';

class AccountsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accounts'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            BudgetingApp.control.addAccount(
                await AccountEditPage.show(Account.empty(), context));
          },
        )
      ]),
      body: Padding24(
        child: AccountListView(BudgetingApp.control.accounts),
      ),
    );
  }
}
