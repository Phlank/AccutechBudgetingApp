import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/view/utils/output_formatter.dart';
import 'package:flutter/material.dart';

import '../budgeting_app.dart';

class GlobalCards{
  static Card cashFlowCard(){
    double income = BudgetingApp.userController.getBudget().income -
        BudgetingApp.userController.getBudget().allotted[Category.housing];
    double spent = BudgetingApp.userController.expenseTotal();
    double remaining= BudgetingApp.userController.getCashFlow();
    return Card(
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: <TextSpan>[
              TextSpan(text: 'Available Income: '),
              TextSpan(
                  text:Format.dollarFormat(income)+'\n',
                  style: TextStyle(
                      fontSize: 20,
                      color: Format.deltaColor(income)
                  )),
              TextSpan(text:'Expenses: '),
              TextSpan(
                  text:Format.dollarFormat(spent)+'\n',
                  style: TextStyle(
                    fontSize: 20,
                    color: Format.deltaColor(spent),
                  )),
              TextSpan(text:'Cash Flow '),
              TextSpan(
                  text:Format.dollarFormat(remaining)+'\n',
                  style: TextStyle(
                    fontSize: 20,
                    color: Format.deltaColor(remaining),
                  ))
            ])));
  }
}
