import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/view/pages/transactions_details.dart';
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
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return new TransactionDetailEdit(transaction);
        }));
      },
    );
  }
}
