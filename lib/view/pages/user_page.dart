import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/accounts_page.dart';
import 'package:budgetflow/view/pages/setup/welcome_page.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:budgetflow/view/widgets/page_cards.dart';
import 'package:budgetflow/view/widgets/priority_bar_chart/priority_chart_row.dart';
import 'package:budgetflow/view/widgets/transaction/edit/transaction_edit_page.dart';
import 'package:budgetflow/view/widgets/transaction/transaction_list_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: () {
              while (Navigator.of(context).canPop())
                Navigator.of(context).pop();
              Navigator.of(context)
                  .push(RouteUtil.routeWithSlideTransition(WelcomePage()));
            },
          )
        ],
      ),
//      drawer: SideMenu().sideMenu(BudgetingApp.userController),
      body: ListView(
        padding: EdgeInsets.all(8),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: <Widget>[
          PriorityChartRow(),
          GlobalCards.cashFlowBudgetCard(),
          TransactionListCard(BudgetingApp.control.getLoadedTransactions()),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(RouteUtil.routeWithSlideTransition(AccountsPage()));
                },
                child: Text('Accounts'),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add transaction',
        child: Icon(Icons.add),
        onPressed: () async {
          await TransactionEditPage.show(Transaction.empty, context);
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
