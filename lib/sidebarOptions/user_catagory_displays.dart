import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:budgetflow/budget/budget_category.dart';


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

class _HousingView extends State<HousingView>{
  @override
  Widget build(BuildContext context) => new GeneralCategory().generalDisplay('housing');
}

class _UtilitiesView extends State<UtilitiesView>{
  @override
  Widget build(BuildContext context) => new GeneralCategory().generalDisplay('utilities');
}
//todo onload() initialize *new* History thing to  pull all of the recently written data out to read
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

  final Map<String,String> routeMap ={
    'housing':'/housing',
    'utilities':'/utilities',
    'groceries':'/groceries',
    'savings':'/savings',
    'health':'/health',
    'transportation':'/transport',
    'education':'/education',
    'entertainment':'/entertainment',
    'kids':'/kids',
    'pets':'/pets',
    'miscellaneous':'/misc',
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
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: routeMap.keys.length,
        itemBuilder: (BuildContext context, int item) {
          return sideBarFlatButton(routeMap.keys.toList()[item],routeMap[routeMap.keys.toList()[item]],context);
        },
      ),
    );
  }

  FlatButton sideBarFlatButton(String name, String route, BuildContext context){
    return new FlatButton(
      child: Text(name),
      onPressed: (){
        Navigator.pushNamed(context, route);
      },
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