import 'package:budgetflow/model/account.dart';
import 'package:budgetflow/view/utils/output_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AccountListViewItem extends StatelessWidget {
  final Account account;

  AccountListViewItem(this.account);

  Widget build(BuildContext context) {
    return Table(
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            TableCell(child: Text(account.accountName)),
            TableCell(child: Text(Format.dollarFormat(account.amount))),
          ],
        ),
      ],
    );
  }
}
