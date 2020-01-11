import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:budgetflow/budget/budget_category.dart';
import 'package:pie_chart/pie_chart.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPage createState() => _UserPage();
}

class HousingView extends StatefulWidget{
  @override
  _HousingView createState() => _HousingView();
}

class UtilitiesView extends StatefulWidget{
  @override
  _UtilitiesView createState() => _UtilitiesView();
}

class GroceriesView extends StatefulWidget{
  @override
  _GroceriesView createState() => _GroceriesView();
}

class SavingsView extends StatefulWidget{
  @override
  _SavingsView createState() => _SavingsView();
}

class HealthView extends StatefulWidget{
  @override
  _HealthView createState() => _HealthView();
}

class TransportationView extends StatefulWidget{
  @override
  _TransportationView createState() => _TransportationView();
}

class EducationView extends StatefulWidget {
  @override
  _EducationView createState() => _EducationView();
}

class EntertainmentView extends StatefulWidget{
  @override
  _EntertainmentView createState() => _EntertainmentView();
}

class KidsView extends StatefulWidget{
  @override
  _KidsView createState() => _KidsView();
}

class PetsView extends StatefulWidget{
  @override
  _PetsView createState() => _PetsView();
}

class MiscView extends StatefulWidget{
  @override
  _MiscView createState() => _MiscView();
}

class _UserPage extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    Map<String, double> budgetCatagoryAMNTS = buildBudgetMap();
    List expenses = []; //todo get expenses list from where ever that might be
    return Scaffold(
      appBar: AppBar(
        title: Text(/*users enterd name when available*/ 'User Page'),
      ),
      drawer: new GeneralCategory().sideMenu(),
      body:ListView(
        padding: EdgeInsets.all(4.0),
        children: <Widget>[
          Card(
            /*pie chart display*/
              child: PieChart(
                dataMap: budgetCatagoryAMNTS,
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
                  textAlign: TextAlign.left,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'Income:\n', //todo implement income here
                        style: TextStyle(
                          color: Colors.green,
                        )),
                    TextSpan(
                        text:
                        'Expences: -\n', //todo implement expenses total right here
                        style: TextStyle(
                          color: Colors.red,
                        )),
                    TextSpan(
                        text:
                        'Cash Flow', //todo implement function to calculate cashFlow
                        style: TextStyle(
                          color: Colors
                              .black, //todo implement a function to return red or green based on cashFlow
                        ))
                  ]))),
          Card(/*user warnings*/),
          Card(
            /*expense tracker*/
              child: new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: expenses.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Text(expenses[index]);
                },
              )),
        ],
      ),
    );
  } //build

  Map<String, double> buildBudgetMap() {
    //todo use global objet to get real data from user in to map
    Map<String, double> map = new Map();
    map.putIfAbsent('housing', () => 5);
    map.putIfAbsent('utilities', () => 3);
    map.putIfAbsent('groceries', () => 2);
    map.putIfAbsent('savings', () => 2);
    map.putIfAbsent('helath', () => 4);
    map.putIfAbsent('transportation', () => 2);
    map.putIfAbsent('education', () => 3);
    map.putIfAbsent('entertainment', () => 1);
    map.putIfAbsent('kids', () => 2);
    map.putIfAbsent('pets', () => 10);
    map.putIfAbsent('miscellaneous', () => 5);
    return map;
  }
} // _UserPage

class _HousingView extends State<HousingView>{
  @override
  Widget build(BuildContext context) => new GeneralCategory().generalDisplay('housing');
}

class _UtilitiesView extends State<UtilitiesView>{
  @override
  Widget build(BuildContext context) => new GeneralCategory().generalDisplay('utilities');
}

class _GroceriesView extends State<GroceriesView>{
  @override
  Widget build(BuildContext context) => new GeneralCategory().generalDisplay('groceries');
}

class _SavingsView extends State<SavingsView>{
  @override
  Widget build(BuildContext context) => new GeneralCategory().generalDisplay('savings');
}

class _HealthView extends State<HealthView>{
  @override
  Widget build(BuildContext context) => new GeneralCategory().generalDisplay('health');
}

class _TransportationView extends State<TransportationView>{
  @override
  Widget build(BuildContext context) => new GeneralCategory().generalDisplay('transportation');
}

class _EducationView extends State<EducationView>{
  @override
  Widget build(BuildContext context) => new GeneralCategory().generalDisplay('education');
}

class _EntertainmentView extends State<EntertainmentView>{
  @override
  Widget build(BuildContext context) => new GeneralCategory().generalDisplay('entertainment');
}

class _KidsView extends State<KidsView>{
  @override
  Widget build(BuildContext context) => new GeneralCategory().generalDisplay('kids');
}

class _PetsView extends State<PetsView>{
  @override
  Widget build(BuildContext context) => new GeneralCategory().generalDisplay('pets');
}

class _MiscView extends State<MiscView>{
  @override
  Widget build(BuildContext context) => new GeneralCategory().generalDisplay('miscellaneous');
}

class GeneralCategory{

  final Map<String, BudgetCategory> categoryMap = {
    'housing':BudgetCategory.housing,
    'utilities':BudgetCategory.utilities,
    'groceries':BudgetCategory.groceries,
    'savings':BudgetCategory.savings,
    'health':BudgetCategory.health,
    'transportation':BudgetCategory.transportation,
    'education':BudgetCategory.education,
    'entertainment':BudgetCategory.entertainment,
    'kids':BudgetCategory.kids,
    'pets':BudgetCategory.pets,
    'miscellaneous':BudgetCategory.miscellaneous
  };
  String categoryView;

  Scaffold generalDisplay(String category){
    this.categoryView = category;
    return Scaffold(
      appBar: AppBar(
        title:Text('User Info'),
      ),
      drawer: sideMenu(),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          remainingInCategory(),
          categoryExpences()
        ],
      )

    );
  }

  Drawer sideMenu(){
    return Drawer(
      child: ListView(
        children: <Widget>[
          FlatButton(
            child: Text('My Budgets'),
            textColor: Colors.black,
            splashColor: Colors.white,
            onPressed: () {
              //todo route towards user page
              //todo splach color purple or some varient of that
              //todo text color white
            },
          )
          //todo add budget catagory widgets, add user information, add userhistory
        ],
      ),
    );
  }

  Card remainingInCategory(){
    return Card(
      child: RichText(
        text: TextSpan(
          text: 'Cash Flow in '+categoryView+':\n',
          children: <TextSpan>[
            TextSpan(
              text:'budgeted\n',//todo implement category amounts
              style: TextStyle(
                color: Colors.green,
                fontSize: 12
              )
            ),
            TextSpan(
              text: 'spent -\n',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12
              )
            ),
            TextSpan(
              text: 'remaining:\n',
              style: TextStyle(
                color: Colors.black,//todo implemnt color switcher if pos or neg
                fontSize: 12
              ),
            )
          ],
        ),
      ),
    );
  }

  Card categoryExpences(){
    List categoryExpenses = [];//todo get specific types of transations
    return Card(
        child: new ListView.builder(
          itemCount: categoryExpenses.length,
          itemBuilder: (BuildContext context, int index) {
            return new Text(categoryExpenses[index]);
          },
        )
    );
  }
}