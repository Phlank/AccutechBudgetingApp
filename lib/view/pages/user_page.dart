import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/global_widgets/main_drawer.dart';
import 'package:budgetflow/view/global_widgets/transaction_view.dart';
import 'package:budgetflow/view/utils/output_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';

import 'add_transaction.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => new _UserPageState();
}

class _UserPageState extends State<UserPage> {

  Widget _initUserPage() {
    return Scaffold(
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
                dataMap: BudgetingApp.userController.buildBudgetMap(),
                showChartValues: true,
                showLegends: true,
                colorList: Colors.primaries,
                chartType: ChartType.ring,
              )),
          Card(
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'Available Income: ' +
                            Format.dollarFormat(BudgetingApp.userController
                                .getBudget()
                                .income -
                                BudgetingApp.userController
                                    .getBudget()
                                    .allotted[BudgetCategory.housing])
                                 +
                            '\n',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                        )),
                    TextSpan(
                        text: 'Expenses:' +
                            Format.dollarFormat(BudgetingApp.userController
                                .expenseTotal())+
                            '\n',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                        )),
                    TextSpan(
                        text: 'Cash Flow ' +
                            Format.dollarFormat(BudgetingApp.userController.getCashFlow())+
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
                    subtitle: Text('Spent: '+Format.dollarFormat(spent)+'\t Remains: '+Format.dollarFormat((remaining))),
                    onTap: (){
                      Navigator.pushNamed(context, route);
                    },
                  );
                },
              )
          ),
          new TransactionListView()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'add transaction',
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AddTransaction.ROUTE);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: BudgetingApp.userController.initialize(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _initUserPage();
          } else {
            return CircularProgressIndicator();
          }
        });
  }
} // _UserPage


