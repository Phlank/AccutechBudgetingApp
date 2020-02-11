
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/view/utils/output_formater.dart';
import 'package:flutter/material.dart';

import '../budgeting_app.dart';

class TransactionListView extends StatelessWidget {
  final double _topRowFontSize = 20;
  final double _bottomRowFontSize = 16;

  @override
  Widget build(BuildContext context) {
    TransactionList transactions =
    BudgetingApp.userController.getLoadedTransactions();
    print('Generating ' +
        transactions.length.toString() +
        ' transaction list items');
    return Card(
        child: new ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return _buildTransactionListViewItem(transactions.getAt(index));
            }));
  }

  Widget _buildTransactionListViewItem(Transaction t){
    // could add functionality for on tap if used list item and text spans
    return Table(children: [
      TableRow(children: [
        Text(
          t.vendor,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: _topRowFontSize),
        ),
        Text(Format.dollarFormat(t.delta),
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: _topRowFontSize, color:Format.deltaColor(t.delta)))
      ]),
      TableRow(children: [
        Text(Format.dateFormat(t.datetime),
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: _bottomRowFontSize)),
        Text(t.category.name,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: _bottomRowFontSize))
      ])
    ]);
  }
}