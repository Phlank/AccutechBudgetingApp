import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/view/widgets/transaction/transaction_list_item_button.dart';
import 'package:flutter/material.dart';

class TransactionListView extends StatelessWidget {
  final TransactionList transactions;

  TransactionListView(this.transactions);

  @override
  Widget build(BuildContext context) {
    List<TransactionListItemButton> items = new List();
    transactions.forEach((transaction) {
      items.add(TransactionListItemButton(transaction));
    });
    return Column(
      children: items,
    );
  }
}
