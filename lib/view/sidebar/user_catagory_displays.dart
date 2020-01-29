import 'package:budgetflow/model/budget_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Wants extends StatefulWidget{

	BudgetControl userController;
	Wants(BudgetControl userController){
		this.userController = userController;
	}

	@override
	_Wants createState() => _Wants(userController);
}//todo figure out why the calculations are going awry

class _Wants extends State<Wants>{
	BudgetControl userController;
	_Wants(BudgetControl userController){
		this.userController = userController;
	}

	@override
	Widget build(BuildContext context) => GeneralSliderCategory(userController).generalDisplay('wants', context);

}

class Savings extends StatefulWidget{

	BudgetControl userController;
	Savings(BudgetControl userController){
		this.userController = userController;
	}

	@override
	_Savings createState() => _Savings(userController);
}//todo figure out the calculations that are going awry

class _Savings extends State<Savings>{
	BudgetControl userController;
	_Savings(BudgetControl userController){
		this.userController = userController;
	}

	@override
	Widget build(BuildContext context) => GeneralSliderCategory(userController).generalDisplay('savings', context);

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
  Widget build(BuildContext context) => GeneralSliderCategory(userController).generalDisplay('needs', context);

}

class GeneralSliderCategory{// todo figure out why sliders don't slide and make them slide

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
					itemCount: userController.routeMap.keys.toList().length,
					itemBuilder: (BuildContext context, int index){
						String name = userController.routeMap.keys.toList()[index];
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

			activeColor: Colors.lightGreen,
			value:userController.getBudget().allotted[userController.categoryMap[category]],
			onChanged:(value) {
				playBudget.setCategory(userController.categoryMap[category], value)
			},
			onChangeEnd:(value){
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

	Card buttonCard(BuildContext context){
		return Card(
			child:ListView(
				scrollDirection: Axis.vertical,
				shrinkWrap: true,
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

	Scaffold loadingPage() {
		return Scaffold(
				body:Center(
					child: CircularProgressIndicator(),
				)
		);
	} //build

	Scaffold generalDisplay(String display, BuildContext context){
		return Scaffold(
			appBar: AppBar(
				title: Text('Change '+display+' alotments'),
			),
			drawer: sideMenu(),
			body: Column(
				verticalDirection: VerticalDirection.down,
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				textDirection: TextDirection.ltr,
				children: <Widget>[
					unbudgetedCard(display),
					changeCard(display),
					buttonCard(context),
				],
			),
		);
	}





}