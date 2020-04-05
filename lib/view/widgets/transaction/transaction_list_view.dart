import 'package:budgetflow/model/data_types/transaction_list.dart';
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
    return ListView(
      children: items,
      shrinkWrap: true,
      physics: ScrollPhysics(),
    );
  }
}
