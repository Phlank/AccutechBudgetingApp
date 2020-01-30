import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/global_widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';

import 'add_transaction.dart';

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

  void _initUserPage() {
    Map<String, double> budgetCategoryAmounts =
    BudgetingApp.userController.buildBudgetMap();
    userPage = Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
      ),
      drawer: SideMenu().sideMenu(BudgetingApp.userController),
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
          new _TransactionListView()
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

class _TransactionListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TransactionList transactions =
    BudgetingApp.userController.getLoadedTransactions();
    print('Generating ' +
        transactions.length.toString() +
        ' transaction list items');
    return Card(
        child: new ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return _buildTransactionListViewItem(index);
            }));
  }

  Widget _buildTransactionListViewItem(int index) {
    Transaction t = BudgetingApp.userController.getLoadedTransactions()[index];
    return Table(children: [
      TableRow(children: [
        Text(
          t.vendor,
          textAlign: TextAlign.left,
        ),
        Text(
          _formatDelta(t.delta),
          textAlign: TextAlign.right,
        )
      ]),
      TableRow(children: [
        Text(t.datetime.toLocal().toIso8601String(), textAlign: TextAlign.left),
        Text(categoryJson[t.category], textAlign: TextAlign.right)
      ])
    ]);
  }

  String _formatDelta(double delta) {
    String output = delta.toStringAsPrecision(2);
    if (output.contains('-')) {
      output = output.replaceAll('-', '-\$');
    } else {
      output = '\$' + output;
    }
    return output;
  }
}
