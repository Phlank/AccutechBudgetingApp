import 'package:budgetflow/view/utils/output_formatter.dart';
import 'package:flutter/material.dart';

import '../budgeting_app.dart';

class GlobalCards {
  static Widget cashFlowBudgetCard() {
    var titleStyle = TextStyle(
      fontSize: 20,
      color: Colors.black,
    );
    var weekly = BudgetingApp.control.accountant.balanceWeek;
    var monthly = BudgetingApp.control.accountant.balanceMonth;
    return Padding(
        child: Card(
            child: Column(
          children: <Widget>[
            Text(
              'Balance',
              style: titleStyle,
            ),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(children: <Text>[
                  Text(
                    'Weekly',
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Monthly',
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  )
                ]),
                TableRow(children: <Text>[
                  Text(Format.dollarFormat(weekly),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, color: Format.deltaColor(weekly))),
                  Text(Format.dollarFormat(monthly),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, color: Format.deltaColor(monthly)))
                ]),
              ],
            ),
          ],
        )),
        padding: EdgeInsets.all(24.0));
  }
}
