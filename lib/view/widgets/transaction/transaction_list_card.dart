import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/view/sidebar/account_display.dart';
import 'package:budgetflow/view/widgets/transaction/transaction_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionListCard extends StatelessWidget {
  static const int _MAX_NUMBER = 3;

  final TransactionList transactions;

  TransactionListCard(this.transactions);

  @override
  Widget build(BuildContext context) {
    if (transactions.length < _MAX_NUMBER)
      return _buildAmount(transactions.length, context);
    else
      return _buildAmount(_MAX_NUMBER, context);
  }

  Widget _buildAmount(int n, BuildContext context) {
    // Start at the back of the list
    List<TransactionListItem> items = new List();
    int index = transactions.length - 1;
    while (n > 0) {
      items.add(TransactionListItem(transactions[index]));
      index--;
      n--;
    }
    return Card(
        child: Column(children: <Widget>[
      Padding(
        child: Text(
          'Recent Transactions',
          style: TextStyle(fontSize: 20),
        ),
        padding: EdgeInsets.all(8.0),
      ),
      Column(children: items),
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text('View more'),
            onPressed: (() {
              Navigator.pushNamed(context, AccountDisplay.ROUTE);
            }),
            materialTapTargetSize: MaterialTapTargetSize.padded,
          )
        ],
      ),
    ]));
  }
}
