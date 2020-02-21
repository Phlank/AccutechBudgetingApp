import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/global_widgets/main_drawer.dart';
import 'package:budgetflow/view/global_widgets/page_cards.dart';
import 'package:budgetflow/view/global_widgets/transaction_view.dart';
import 'package:budgetflow/view/utils/output_formater.dart';
import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'add_transaction.dart';

class UserPage extends StatefulWidget {

  @override
  _UserPageState createState() => new _UserPageState();
}

class _UserPageState extends State<UserPage> {
  //todo clean
  Widget sectionGraphGenerator(String section){
    List<SectionData> data = [ new SectionData(BudgetingApp.userController.sectionBudget(section).floor(), 'allotted'),
      new SectionData(BudgetingApp.userController.expenseInSection(section).ceil(), 'spent')];
    chart.Series<SectionData, String> s = chart.Series(
      data: data,
      id: section,
      domainFn: (SectionData name, _)=>name.state,
      measureFn: (SectionData amt, _)=>amt.amt,
      displayName: section,
    );
    List<chart.Series<SectionData,String>> sectionDataList = [s];
    return Card(
      child:Column(
      children: <Widget>[ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 200,
          maxWidth: 122,
          minWidth: 100,
          minHeight: 100
        ),
        child: chart.BarChart(
          sectionDataList,
          animate:true,
          primaryMeasureAxis:
          new chart.NumericAxisSpec(renderSpec: new chart.NoneRenderSpec()),
          domainAxis: new chart.OrdinalAxisSpec(
              showAxisLine: true,
              renderSpec: new chart.NoneRenderSpec()),),),
      FlatButton(
        child: Text(Format.titleFormat(section)),
        onPressed: (){
          print(section);
          Navigator.pushNamed(context, BudgetingApp.userController.routeMap[section]);
        },
      )]),);
  }

  Widget barChartView(){
    List<Widget> graphCards = new List<Widget>();
    BudgetingApp.userController.sectionMap.keys.toList().forEach((section){
     graphCards.add(sectionGraphGenerator(section));
    });
   return Row(
     children: graphCards,
   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
      ),
      drawer: SideMenu().sideMenu(BudgetingApp.userController),
      body:
      ListView(
       padding: EdgeInsets.all(8),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: <Widget>[
          barChartView(),
          GlobalCards.cashFlowCard(),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, BudgetingApp.userController.routeMap['accounts']);
            },
            child:TransactionListView(3),
          ),
        ],
      ),
      floatingActionButton:  FloatingActionButton(
        tooltip: 'add transaction',
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