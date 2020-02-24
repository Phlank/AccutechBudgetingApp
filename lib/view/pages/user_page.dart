import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/widgets/main_drawer.dart';
import 'package:budgetflow/view/widgets/page_cards.dart';
import 'package:budgetflow/view/widgets/priority_bar_chart/priority_chart_row.dart';
import 'package:budgetflow/view/widgets/transaction/transaction_list_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'add_transaction.dart';

class UserPage extends StatefulWidget {
  static const ROUTE = '/knownUser';
  @override
  _UserPageState createState() => new _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
      ),
      drawer: SideMenu().sideMenu(BudgetingApp.userController),
      body: ListView(
        padding: EdgeInsets.all(8),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: <Widget>[
          PriorityChartRow(),
          GlobalCards.cashFlowBudgetCard(),
          TransactionListCard(BudgetingApp.userController.getBudget().transactions)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add transaction',
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AddTransaction.ROUTE);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class SectionData {
  final int amt;
  final String state;

  SectionData(this.amt, this.state);
}
