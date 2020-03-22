import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/widgets/page_cards.dart';
import 'package:budgetflow/view/widgets/transaction/transaction_list_view.dart';
import 'package:flutter/material.dart';

//todo get on to the side menu
  /*
  it is the future home to display account information
  it is the current place to see full list of recorded transactions
   */


class AccountDisplay extends StatefulWidget{
  static const ROUTE = '/account';
  @override
  _AccountDisplay createState() => _AccountDisplay();
}

class  _AccountDisplay extends State<AccountDisplay>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts and Transactions'),
      ),
      body: Column(
        children: <Widget>[
          GlobalCards.cashFlowBudgetCard(),
          TransactionListView(
              BudgetingApp.control.getLoadedTransactions()),
        ],
      ),
    );
  }
}