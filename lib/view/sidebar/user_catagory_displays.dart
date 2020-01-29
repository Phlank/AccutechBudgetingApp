import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/global_widgets/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GeneralCategory extends StatefulWidget{
  String section;
  static final String NEEDS_ROUTE = '/needs';
	static final String WANTS_ROUTE = '/wants';
	static final String SAVINGS_ROUTE = '/savings';


	GeneralCategory(String section){
		this.section = section;
	}

  @override
  State<StatefulWidget> createState() =>_GeneralCategoryState(section);

}

class _GeneralCategoryState extends State<GeneralCategory>{// todo figure out why sliders don't slide and make them slide

	BudgetControl userController;
	MockBudget playBudget;
	String section;

	_GeneralCategoryState(String section){
		this.userController = BudgetingApp.userController;
		this.playBudget = new MockBudget(userController.getBudget());
		this.section = section;
	}

	Card unbudgetedCard(){
		return Card(
			child: Text.rich(
				TextSpan(
					text:'Unbudgeted in Section\n',
					children: <TextSpan>[
						TextSpan(text:'\$')
					],
					style: TextStyle(
						color: userController.cashFlowColor,
						fontSize: 20,
						fontWeight: FontWeight.bold,
					),
				),
			),
		);
	}

	Slider sectionSlider(String category){
		return Slider(

			activeColor: Colors.lightGreen,
			value:userController.getBudget().allotted[userController.categoryMap[category]],
			onChanged:(value) {
				playBudget.setCategory(userController.categoryMap[category], value);
			},
			onChangeEnd:(value){
				playBudget.setCategory(userController.categoryMap[category], value);
			},
			min: 0,
			max:userController.sectionBudget(section),
			label: category,

		);
	}

	ListTile categoryTile(String category) {
		return ListTile(
			title: Text(category+'\t'+(playBudget.budget.allotted[userController.categoryMap[category]]).toString()),
			subtitle:sectionSlider(category),
		);
	}

	Card changeCard(){
		return Card(
			child: ListView.builder(
				controller: ScrollController(),
				scrollDirection: Axis.vertical,
				physics: ClampingScrollPhysics(),
				shrinkWrap: true,
				itemCount:  userController.sectionMap[section].length,
				itemBuilder: (context,int index){
					return categoryTile(userController.sectionMap[section][index]);
				},
			),
		);
	}

	Card buttonCard(){
		return Card(
			child:ListView(
				scrollDirection: Axis.vertical,
				shrinkWrap: true,
				children: <Widget>[

				],
			)
		);
	}


	Scaffold generalDisplay(){
		return Scaffold(
			appBar: AppBar(
				title: Text('Change '+section+' alotments'),
			),
			drawer: SideMenu().sideMenu(userController),
			body: Column(
				verticalDirection: VerticalDirection.down,
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				textDirection: TextDirection.ltr,
				children: <Widget>[
					unbudgetedCard(),
					changeCard(),
				],

			),
			persistentFooterButtons: <Widget>[
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
		);
	}

  @override
  Widget build(BuildContext context) => generalDisplay();
}