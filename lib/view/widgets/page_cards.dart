import 'package:budgetflow/model/data_types/category.dart';
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

  static Card cashFlowCard() {
    double income = BudgetingApp.control.getBudget().expectedIncome -
        BudgetingApp.control
            .getBudget()
            .allotted
            .getCategory(Category.housing)
            .value;
    double spent = BudgetingApp.control.expenseTotal();
    double remaining = BudgetingApp.control.getCashFlow();
    return Card(
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: <TextSpan>[
              TextSpan(text: 'Available Income: '),
              TextSpan(
                  text: Format.dollarFormat(income) + '\n',
                  style: TextStyle(
                      fontSize: 20, color: Format.deltaColor(income))),
              TextSpan(text: 'Expenses: '),
              TextSpan(
                  text: Format.dollarFormat(spent) + '\n',
                  style: TextStyle(
                    fontSize: 20,
                    color: Format.deltaColor(spent),
                  )),
              TextSpan(text: 'Cash Flow '),
              TextSpan(
                  text: Format.dollarFormat(remaining) + '\n',
                  style: TextStyle(
                    fontSize: 20,
                    color: Format.deltaColor(remaining),
                  ))
            ])));
  }
}
