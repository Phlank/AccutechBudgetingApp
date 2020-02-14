import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/global_widgets/main_drawer.dart';
import 'package:budgetflow/view/global_widgets/page_cards.dart';
import 'package:budgetflow/view/global_widgets/transaction_view.dart';
import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class UserPage extends StatefulWidget {

  @override
  _UserPageState createState() => new _UserPageState();
}

class _UserPageState extends State<UserPage> {
  //todo clean
  Card sectionGraphGenerator(String section){
    List data = [ new SectionData(BudgetingApp.userController.sectionBudget(section), 'allotted'),
      new SectionData(BudgetingApp.userController.expenseInSection(section), 'spent')];
    List<chart.Series<SectionData, String>> sectionDataList =[
      new chart.Series(id: section, data: data, domainFn: (SectionData data, _)=>data.state,
          measureFn: (SectionData data, _)=>data.amt) ];
    return Card(
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(context, BudgetingApp.userController.routeMap[section]);
        },
        child: chart.BarChart(
        sectionDataList,
        animate:true,
        primaryMeasureAxis:
        new chart.NumericAxisSpec(renderSpec: new chart.NoneRenderSpec()),
        domainAxis: new chart.OrdinalAxisSpec(
            showAxisLine: true,
            renderSpec: new chart.NoneRenderSpec()),
        layoutConfig: new chart.LayoutConfig(
            leftMarginSpec: new chart.MarginSpec.fixedPixel(0),
            topMarginSpec: new chart.MarginSpec.fixedPixel(0),
            rightMarginSpec: new chart.MarginSpec.fixedPixel(0),
            bottomMarginSpec: new chart.MarginSpec.fixedPixel(0)),),),
    );
  }

  ListBody barChartView(){
    List<Card> graphCards = new List<Card>();
    BudgetingApp.userController.sectionMap.keys.toList().forEach((section){
      graphCards.add(sectionGraphGenerator(section));
    });
   return ListBody(
     mainAxis: Axis.horizontal,
     children: graphCards,
   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: SideMenu().sideMenu(BudgetingApp.userController),
      body: ListView(
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
    );
  }
}

class SectionData {
  final double amt;
  final String state;
  SectionData(this.amt, this.state);
}