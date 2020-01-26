import 'package:budgetflow/main.dart';
import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';



class NewTransaction extends StatefulWidget {

  BudgetControl userController;
	NewTransaction(BudgetControl userController){
		this.userController = userController;
	}
	@override
	_NewTransaction createState() => _NewTransaction(userController);
}

class _NewTransaction extends State{

	BudgetControl userController;
  _NewTransaction(BudgetControl userController){
  	this.userController = userController;
	}

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}





class Wants extends StatefulWidget{

	BudgetControl userController;
	Wants(BudgetControl userController){
		this.userController = userController;
	}

	@override
	_Wants createState() => _Wants(userController);
}

class _Wants extends State<Needs>{
	BudgetControl userController;
	_Wants(BudgetControl userController){
		this.userController = userController;
	}

	@override
	Widget build(BuildContext context) => GeneralSliderCategory(userController).generalDisplay('wants');

}

class Savings extends StatefulWidget{

	BudgetControl userController;
	Savings(BudgetControl userController){
		this.userController = userController;
	}

	@override
	_Savings createState() => _Savings(userController);
}

class _Savings extends State<Needs>{
	BudgetControl userController;
	_Savings(BudgetControl userController){
		this.userController = userController;
	}

	@override
	Widget build(BuildContext context) => GeneralSliderCategory(userController).generalDisplay('savings');

}


class Needs extends StatefulWidget{

	BudgetControl userController;
	Needs(BudgetControl userController){
		this.userController = userController;
	}

  @override
  _Needs createState() => _Needs(userController);
}

class _Needs extends State<Needs>{
	BudgetControl userController;
	_Needs(BudgetControl userController){
		this.userController = userController;
	}

  @override
  Widget build(BuildContext context) => GeneralSliderCategory(userController).generalDisplay('needs');

}

class GeneralSliderCategory{

	BudgetControl userController;
	MockBudget playBudget;

	GeneralSliderCategory(BudgetControl userController){
		this.userController = userController;
		this.playBudget = new MockBudget(userController.getBudget());
	}

	FlatButton sideBarFlatButton(String name, String route,
			BuildContext context) {
		return new FlatButton(
			child: Text(name),
			onPressed: () {
				Navigator.pushNamed(context, route);
			},
		);
	}

	Drawer sideMenu(){
		return Drawer(
			child: ListView.builder(
					scrollDirection: Axis.vertical,
					shrinkWrap: true,
					itemCount: userController.sectionMap.keys.toList().length,
					itemBuilder: (BuildContext context, int index){
						String name = userController.sectionMap.keys.toList()[index];
						return sideBarFlatButton(name, userController.routeMap[name], context);
					},
			),
		);
	}

	Card unbudgetedCard(String display){
		return Card(
			child: Text.rich(
				TextSpan(
					text:'\$'+(userController.sectionBudget(display)- playBudget.getNewTotalAlotted(display)).toString(),
					style: TextStyle(
						color: Colors.black,
						fontSize: 20,
						fontWeight: FontWeight.bold,
					),
				),
			),
		);
	}

	Slider sectionSlider(String category,String section){
		return Slider(
			value:userController.getBudget().getAllotment(userController.categoryMap[category]),
			onChanged: (value){
				playBudget.setCategory(userController.categoryMap[category], value);
			},
			min: 0,
			max:userController.sectionBudget(section),
			label: category,
		);
	}

	Card changeCard(String display){
		return Card(
			child: ListView.builder(
				scrollDirection: Axis.vertical,
				shrinkWrap: true,
				itemCount:  userController.sectionMap[display].length,
				itemBuilder: (context,int index){
					return sectionSlider(userController.sectionMap[display][index],display);
				},
			),
		);
	}

	Card buttonCard(){
		return Card(
			child:ListView(
				scrollDirection: Axis.horizontal,
				children: <Widget>[
					RaisedButton(
						child:Text('submit'),
						onPressed: (){
							for(String category in userController.categoryMap.keys.toList()){
								userController.changeAllotment(category ,playBudget.getCategory(userController.categoryMap[category]));
							}
						},
					),
					RaisedButton(
						child:Text('cancel'),
						onPressed: (){
							Navigator.pushNamed(context, '/knownUser');
						},
					),
				],
			)
		);
	}

	Scaffold generalDisplay(String display){
		return Scaffold(
			appBar: AppBar(
				title: Text('Change '+display+' alotments'),
			),
			drawer: sideMenu(),
			body: Column(
				children: <Widget>[
					unbudgetedCard(display),
					changeCard(display),
					buttonCard(),
				],
			),
		);
	}





}