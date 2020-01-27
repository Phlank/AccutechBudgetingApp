import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  	final _transFormKey = GlobalKey<FormState>();
  	TransactionInformationHolder holder = new TransactionInformationHolder();
  	BudgetCategory dropDown = BudgetCategory.miscellaneous;
  	String method = 'cash';
    return Scaffold(
			appBar: AppBar(title:Text('New Transaction')),
			drawer: GeneralSliderCategory(userController).sideMenu(),
			body: Column(
				children: <Widget>[
					Form(
						key: _transFormKey,
						child: Column(
							children: <Widget>[
								TextFormField(
									decoration:InputDecoration(
										labelText: 'Amount of Transaction',
										hintText: 'numbers only'
									),
									validator:(value){
										if(value.isEmpty)return 'dont leave empty';
										if(userController.validInput(value, 'dollarAmnt')) return 'Numbers please';
										holder.setAmnt(double.tryParse(value));
										return null;
									}
								),
								TextFormField(
										decoration:InputDecoration(
												labelText: 'Where did you spend method',
												hintText: 'words only'
										),
										validator:(value){
											if(value.isEmpty)return 'dont leave empty';
											if(userController.validInput(value, 'name')) return 'words please';
											holder.setVendor(value);
											return null;
										}
								),
								DropdownButtonFormField(
									value: method,
									items: dropdownMethodItems(),
									onChanged: (value){
										setState(() {
										  method = value;
										});
										holder.setMethod(value);
									},
								),
								DropdownButtonFormField(
									value: dropDown,
									items: dropdownCategoryItems(),
									onChanged:(value){
										setState(() {
										  dropDown = value;
										});
										holder.setCategory(value);
									}
								)
							],
						)
					),
					RaisedButton(
						onPressed: (){
							if(_transFormKey.currentState.validate()) {
								Transaction trans = new Transaction(
										holder.vendor, holder.method, holder.delta,
										holder.category);
								userController.addTransaction(trans);
							}
						},
					)
				],
			),
		);
  }

  List<DropdownMenuItem> dropdownMethodItems(){
  	List<String> methods = ['credit','checking','savings','cash'];
  	List<DropdownMenuItem> retList = new List();
  	for(String method in methods){
  		retList.add(new DropdownMenuItem(
				child: Text(method),
				value: method,
			));
		}
	}

  List<DropdownMenuItem> dropdownCategoryItems(){
  	List<DropdownMenuItem> retList = new List();
  	for(String name in userController.categoryMap.keys.toList()){
  		retList.add(new DropdownMenuItem(
				child: Text(name),
				value: userController.categoryMap[name],
			));
		}
  	return retList;
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
}

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
			value:userController.getBudget().allotted[userController.categoryMap[category]],
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

class TransactionInformationHolder {
	double delta;
	String vendor;
	String method;
	BudgetCategory category;

	setAmnt(double amt){this.delta = amt;}
	setVendor(String vendor){this.vendor = vendor;}
	setMethod(String method){this.method = method;}
	setCategory(BudgetCategory category) {this.category = category;}

}