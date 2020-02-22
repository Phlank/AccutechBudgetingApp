import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/view/utils/output_formatter.dart';
import 'package:flutter/cupertino.dart';

class TransactionListItem extends StatelessWidget {
  static const double TOP_ROW_FONT_SIZE = 20;
  static const double BOTTOM_ROW_FONT_SIZE = 16;

  final Transaction transaction;

  TransactionListItem(this.transaction);

  @override
  Widget build(BuildContext context) {
    if (transaction == null) return null;
    return Padding(
      child: Table(children: [
        TableRow(children: [
          Text(
            transaction.vendor,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: TOP_ROW_FONT_SIZE),
          ),
          Text(Format.dollarFormat(transaction.amount),
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: TOP_ROW_FONT_SIZE,
                  color: Format.deltaColor(transaction.amount)))
        ]),
        TableRow(children: [
          Text(Format.dateFormat(transaction.time),
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: BOTTOM_ROW_FONT_SIZE)),
          Text(transaction.category.name,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: BOTTOM_ROW_FONT_SIZE))
        ])
      ]),
      padding: EdgeInsets.all(8.0),
    );
  }
}
