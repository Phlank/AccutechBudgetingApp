import 'package:budgetflow/model/data_types/account.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/widgets/account/account_list_view_item.dart';
import 'package:flutter/widgets.dart';

class AccountListView extends StatelessWidget {
  final List<Account> accounts;

  AccountListView(this.accounts);

  Widget build(BuildContext context) {
    List<Widget> items = [];
    BudgetingApp.control.accounts.forEach((account) {
      if (account != null) {
        print(account.toString());
        items.add(AccountListViewItem(account));
      }
    });
    return ListView(
      children: items,
      shrinkWrap: true,
      physics: ScrollPhysics(),
    );
  }
}
