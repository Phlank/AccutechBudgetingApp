import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/view/pages/transactions_details.dart';
import 'package:budgetflow/view/widgets/transaction/transaction_list_item.dart';
import 'package:flutter/material.dart';

import '../../budgeting_app.dart';

class TransactionListView extends StatelessWidget {
  final TransactionList transactions =
      BudgetingApp.userController.getLoadedTransactions();
  int length;

  TransactionListView(this.length) {
    if (length > transactions.length) {
      this.length = transactions.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            itemCount: length,
            itemBuilder: (context, index) {
              return _buildTransactionListViewItem(
                  context, transactions.getAt(index));
            }));
  }

  Widget _buildTransactionListViewItem(BuildContext context, Transaction t) {
    return InkWell(
        onTap: () {

        },
        child: new TransactionListItem(t));
  }
}
