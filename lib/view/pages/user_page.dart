import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/sidebar/user_catagory_displays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';

class UserPage extends StatefulWidget {
  @override
  UserPageState createState() => new UserPageState();
}

class UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    Map<String, double> budgetCategoryAmounts =
        BudgetingApp.userController.buildBudgetMap();
    return Scaffold(
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
                            (BudgetingApp.userController.getBudget().income -
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
              child: new ListView.builder(
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount:
                BudgetingApp.userController.getLoadedTransactions().length(),
            itemBuilder: (BuildContext context, int index) {
              Transaction trans = BudgetingApp.userController
                  .getLoadedTransactions()
                  .getAt(index);
              if (trans != null) {
                return new Text(trans.vendor + ' ' + trans.delta.toString());
              }
              return Text('No Transactions');
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/newTransaction');
        },
      ),
    );
  }
} // _UserPage
