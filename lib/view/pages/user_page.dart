import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/global_widgets/main_drawer.dart';
import 'package:budgetflow/view/utils/output_formater.dart';
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

  void _initUserPage() {
    Map<String, double> budgetCategoryAmounts =
    BudgetingApp.userController.buildBudgetMap();
    userPage = Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
      ),
      drawer:  SideMenu().sideMenu(BudgetingApp.userController),
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
                          color: BudgetingApp.userController.cashFlowColor,
                        ))
                  ]))),
          Card(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: BudgetingApp.userController.sectionMap.keys.toList().length,
              itemBuilder: (context, int index){
                String section = BudgetingApp.userController.sectionMap.keys.toList()[index];
                double remaining =  BudgetingApp.userController.remainingInSection(section);
                double spent = BudgetingApp.userController.expenseInSection(section);
                String route = BudgetingApp.userController.routeMap[section];
                return ListTile(
                  title:Text(Format.titleFormat(section)),
                  subtitle: Text(Format.dollarFormat(spent)+'\t'+Format.dollarFormat((remaining))),
                  onTap: (){
                    Navigator.pushNamed(context, route);
                  },
                );
              },
            )
          ),
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
                    return new Text(
                        trans.vendor + ' ' + trans.delta.toString());
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

  @override
  void initState() {
    super.initState();
    _load = BudgetingApp.userController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return userPage;
  }
} // _UserPage
