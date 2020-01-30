import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/add_transaction.dart';
import 'package:budgetflow/view/sidebar/user_catagory_displays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => new _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future _load;
  Scaffold userPage;

  _UserPageState() {
    _initUserPage();
  }

  List<Widget> transactionTiles() {
    List<Widget> tiles = new List<Widget>();
    TransactionList transactions = BudgetingApp.userController
        .getLoadedTransactions();
    for (int i = 0; i < transactions.length(); i++) {
      print(i.toString());
      tiles.add(fromTransaction(transactions[i]));
    }
    return tiles;
  }

  Widget fromTransaction(Transaction t) {
    final String subtitle = t.vendor + ' ' + categoryJson[t.category];
    return ListTile(
      title: Text(t.delta.toString()),
      subtitle: Text(subtitle),
    );
  }

  void _initUserPage() {
    final tiles = transactionTiles();
    Map<String, double> budgetCategoryAmounts =
    BudgetingApp.userController.buildBudgetMap();
    userPage = Scaffold(
      appBar: AppBar(
        title: Text(/*users entered name when available*/ 'User Page'),
      ),
      drawer: GeneralSliderCategory(BudgetingApp.userController).sideMenu(),
      body: ListView(
        padding: EdgeInsets.all(4.0),
        children: <Widget>[
          Card(
            /*pie chart display*/
              child: PieChart(
                dataMap: budgetCategoryAmounts,
                showChartValues: true,
                showLegends: true,
                colorList: Colors.primaries,
                showChartValuesOutside: true,
                showChartValueLabel: true,
                chartType: ChartType.ring,
              )),
          Card(
            /*user cash flow*/
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'Available Income: ' +
                            (BudgetingApp.userController
                                .getBudget()
                                .income -
                                BudgetingApp.userController
                                    .getBudget()
                                    .allotted[BudgetCategory.housing])
                                .toString() +
                            '\n',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                        )),
                    TextSpan(
                        text: 'Expenses: -' +
                            BudgetingApp.userController
                                .expenseTotal()
                                .toString() +
                            '\n',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                        )),
                    TextSpan(
                        text: 'Cash Flow ' +
                            BudgetingApp.userController.getCashFlow() +
                            '\n',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors
                              .red, //todo implement a function to return red or green based on cashFlow
                        ))
                  ]))),
          Card(/*user warnings*/),
          Card(
            //todo make better scrollable
            /*expense tracker*/
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                children: tiles,
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AddTransaction.ROUTE);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _load = BudgetingApp.userController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _load,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return userPage;
          } else {
            return CircularProgressIndicator();
          }
        });
  }
} // _UserPage
