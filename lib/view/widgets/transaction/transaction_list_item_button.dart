import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/view/widgets/transaction/edit/transaction_edit_page.dart';
import 'package:budgetflow/view/widgets/transaction/transaction_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionListItemButton extends StatelessWidget {
  final Transaction transaction;

  const TransactionListItemButton(this.transaction);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: TransactionListItem(transaction),
        onPressed: () async {
          Transaction newTransaction =
              await TransactionEditPage.show(transaction, context);
          print('clicked the ' + transaction.toString() + ' button');
        });
  }
}
