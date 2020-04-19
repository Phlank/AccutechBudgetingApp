import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/view/utils/output_formatter.dart';
import 'package:flutter/cupertino.dart';

class TransactionListItem extends StatelessWidget {
  static final double topRowFontSize = 20;
  static final double bottomRowFontSize = 16;

  final Transaction transaction;

  TransactionListItem(this.transaction) {
    assert(transaction != null);
  }

  @override
  Widget build(BuildContext context) {
    if (transaction == null) return null; //this is bad
    return Padding(
      child: Table(children: [
        TableRow(children: [
          Text(
            transaction.vendor,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: topRowFontSize),
          ),
          Text(Format.dollarFormat(transaction.amount),
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: topRowFontSize,
                  color: Format.deltaColor(transaction.amount)))
        ]),
        TableRow(children: [
          Text(Format.dateFormat(transaction.time),
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: bottomRowFontSize)),
          Text(transaction.category.name,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: bottomRowFontSize))
        ])
      ]),
      padding: EdgeInsets.all(8.0),
    );
  }
}
