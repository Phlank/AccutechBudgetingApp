import 'package:budgetflow/model/data_types/account.dart';
import 'package:budgetflow/view/pages/account_page.dart';
import 'package:budgetflow/view/utils/output_formatter.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AccountListViewItem extends StatelessWidget {
  final Account account;

  AccountListViewItem(this.account);

  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: <Widget>[
          Text(
            account.accountName,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.left,
          ),
          Container(width: 24),
          Text(
            Format.dollarFormat(account.amount),
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.right,
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context)
            .push(RouteUtil.routeWithSlideTransition(AccountPage(account)));
      },
    );
//    return Table(
//      children: <TableRow>[
//        TableRow(
//          children: <Widget>[
//            TableCell(child: Text(account.accountName)),
//            TableCell(child: Text(Format.dollarFormat(account.amount))),
//          ],
//        ),
//      ],
//    );
  }
}
