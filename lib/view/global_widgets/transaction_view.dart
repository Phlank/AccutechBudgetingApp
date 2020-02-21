import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/view/utils/output_formater.dart';
import 'package:flutter/material.dart';

import '../budgeting_app.dart';

class TransactionListView extends StatelessWidget {
  final double _topRowFontSize = 20;
  final double _bottomRowFontSize = 16;
  TransactionList transactions =
  BudgetingApp.userController.getLoadedTransactions();
  int length;

  TransactionListView(this.length){
    if(length>transactions.length){
      this.length = transactions.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child:ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            itemCount: length,
            itemBuilder: (context, index) {
              return _buildTransactionListViewItem(transactions.getAt(index));
            }));
  }

  Widget _buildTransactionListViewItem(Transaction t){
    return Table(children: [
      TableRow(children: [
        Text(
          t.vendor,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: _topRowFontSize),
        ),
        Text(Format.dollarFormat(t.amount),
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: _topRowFontSize, color: Format.deltaColor(t.amount)))
      ]),
      TableRow(children: [
        Text(Format.dateFormat(t.time),
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: _bottomRowFontSize)),
        Text(t.category.name,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: _bottomRowFontSize))
      ])
    ]);
  }
}