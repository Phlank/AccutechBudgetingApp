import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/global_widgets/main_drawer.dart';
import 'package:budgetflow/view/global_widgets/page_cards.dart';
import 'package:budgetflow/view/global_widgets/transaction_view.dart';
import 'package:flutter/material.dart';

//todo get on to the side menu
  /*
  it is the future home to display account information
  it is the current place to see full list of recorded transactions
   */


class AccountDisplay extends StatefulWidget{

  @override
  _AccountDisplay createState() => _AccountDisplay();
}

class  _AccountDisplay extends State<AccountDisplay>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Veiw'),
      ),
      drawer: SideMenu().sideMenu(BudgetingApp.userController),
      body: Column(
        children: <Widget>[
          GlobalCards.cashFlowCard(),
          new TransactionListView()
        ],
      ),
    );
  }
}