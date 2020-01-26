import 'package:budgetflow/main.dart';
import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class HousingView extends StatefulWidget {
  HousingView(Budget userBudget);

	@override
	_HousingView createState() => _HousingView(userBudget);
}

class UtilitiesView extends StatefulWidget {
  UtilitiesView(Budget userBudget);

	@override
	_UtilitiesView createState() => _UtilitiesView(userBudget);
}

class GroceriesView extends StatefulWidget {
  GroceriesView(Budget userBudget);

	@override
	_GroceriesView createState() => _GroceriesView(userBudget);
}

class SavingsView extends StatefulWidget {
  SavingsView(Budget userBudget);

	@override
	_SavingsView createState() => _SavingsView(userBudget);
}

class HealthView extends StatefulWidget {
  HealthView(Budget userBudget);

	@override
	_HealthView createState() => _HealthView(userBudget);
}

class TransportationView extends StatefulWidget {
  TransportationView(Budget userBudget);

	@override
	_TransportationView createState() => _TransportationView(userBudget);
}

class EducationView extends StatefulWidget {
  EducationView(Budget userBudget);

	@override
	_EducationView createState() => _EducationView(userBudget);
}

class EntertainmentView extends StatefulWidget {
  EntertainmentView(Budget userBudget);
	@override
	_EntertainmentView createState() => _EntertainmentView(userBudget);
}

class KidsView extends StatefulWidget {
  KidsView(Budget userBudget);

	@override
	_KidsView createState() => _KidsView(userBudget);
}

class PetsView extends StatefulWidget {
  PetsView(Budget userBudget);

	@override
	_PetsView createState() => _PetsView(userBudget);
}

class MiscView extends StatefulWidget {
  MiscView(Budget userBudget);

	@override
	_MiscView createState() => _MiscView(userBudget);
}

class NewTransaction extends StatefulWidget {
	NewTransaction(Budget userBudget);
	@override
	_NewTransaction createState() => _NewTransaction(userBudget);
}

class _NewTransaction extends State<NewTransaction> {
	_NewTransaction(Budget userBudget);
	static List<DropdownMenuItem> methodList =
	makeDropDown(['deposit', 'cash', 'debit', 'credit']);
	String currentMethod = methodList[0].value;
	static List<DropdownMenuItem> categories =
	makeDropDown(GeneralCategory().categoryMap.keys.toList());
	String currentCategory = categories[0].value;
	DateTime date;
	String place;
	String amnt;
	@override
	Widget build(BuildContext context) {
		final formKey = GlobalKey<FormState>();
		return Scaffold(
				appBar: AppBar(
					title: Text('new transaction'),
				),
				drawer: GeneralCategory().sideMenu(),
				body: Column(children: <Widget>[
					Form(
						key: formKey,
						child: Column(children: <Widget>[
							Text('What day did you make the transaction'),
							CupertinoDatePicker(
								mode: CupertinoDatePickerMode.date,
								initialDateTime: DateTime.now(),
								onDateTimeChanged: (value) {
									date = value;
								},
							),
							TextFormField(
								decoration: InputDecoration(
									labelText: 'Where did you make the transaction?',
								),
								validator: (value) {
									if (value.isEmpty) return 'please don\'t leave this blank';
									place = value;
									return null;
								},
							),
							DropdownButton(
								value: currentMethod,
								items: methodList,
								onChanged: (selectedMethod) {
									setState(() {
										currentMethod = selectedMethod;
									});
								},
							),
							DropdownButton(
								value: currentCategory,
								items: categories,
								onChanged: (selectedCategory) {
									setState(() {
										currentCategory = selectedCategory;
									});
								},
							),
							TextFormField(
									keyboardType: TextInputType.phone,
									decoration: InputDecoration(labelText: 'amont of tranaction'),
									validator: (value) {
										if (value.isEmpty) {
											return 'please do not leave empty';
										}
										return null;
									})
						]),
					),
					RaisedButton(
						child: Text('add transaction'),
						onPressed: () {
							if (formKey.currentState.validate()) {
								Transaction trans = new Transaction(
										place,
										currentMethod,
										double.parse(amnt),
										GeneralCategory().categoryMap[currentCategory]);
								userBudget.addTransaction(trans);
								Navigator.pushNamed(context, '/knownUser');
							}
						},
					)
				]));
	}

	static List<DropdownMenuItem> makeDropDown(List<String> list) {
		List<DropdownMenuItem> retList = new List(list.length);
		for (String item in list) {
			retList.add(DropdownMenuItem(value: item, child: Text(item)));
		}
		return retList;
	}
}

class _HousingView extends State<HousingView> {
	_HousingView(Budget userBudget);

	@override
	Widget build(BuildContext context) =>
			new GeneralCategory().generalDisplay('housing',userBudget);
}

class _UtilitiesView extends State<UtilitiesView> {
	Budget userBudget;
	_UtilitiesView(Budget userBudget);
	@override
	Widget build(BuildContext context) =>
			new GeneralCategory().generalDisplay('utilities',userBudget);
}

//todo onload() initialize *new* History thing to  pull all of the recently written data out to read
class _GroceriesView extends State<GroceriesView> {
	Budget userBudget;
	_GroceriesView(Budget userBudget);
	@override
	Widget build(BuildContext context) =>
			new GeneralCategory().generalDisplay('groceries',userBudget);
}

class _SavingsView extends State<SavingsView> {
	Budget userBudget;
	_SavingsView(Budget userBudget);
	@override
	Widget build(BuildContext context) =>
			new GeneralCategory().generalDisplay('savings',userBudget);
}

class _HealthView extends State<HealthView> {
	Budget userBudget;
	_HealthView(Budget userBudget);
	@override
	Widget build(BuildContext context) =>
			new GeneralCategory().generalDisplay('health',userBudget);
}

class _TransportationView extends State<TransportationView> {
	Budget userBudget;
	_TransportationView(Budget userBudget);
	@override
	Widget build(BuildContext context) =>
			new GeneralCategory().generalDisplay('transportation',userBudget);
}

class _EducationView extends State<EducationView> {
	Budget userBudget;
	_EducationView(Budget userBudget);
	@override
	Widget build(BuildContext context) =>
			new GeneralCategory().generalDisplay('education',userBudget);
}

class _EntertainmentView extends State<EntertainmentView> {

  _EntertainmentView(Budget userBudget);

	@override
	Widget build(BuildContext context) =>
			new GeneralCategory().generalDisplay('entertainment',userBudget);
}

class _KidsView extends State<KidsView> {
	Budget userBudget;
	_KidsView(Budget userBudget);
	@override
	Widget build(BuildContext context) =>
			new GeneralCategory().generalDisplay('kids',userBudget);
}

class _PetsView extends State<PetsView> {
	Budget userBudget;
	_PetsView(Budget userBudget);
	@override
	Widget build(BuildContext context) =>
			new GeneralCategory().generalDisplay('pets',userBudget);
}

class _MiscView extends State<MiscView> {
	Budget userBudget;
	_MiscView(Budget userBudget);
	@override
	Widget build(BuildContext context) =>
			new GeneralCategory().generalDisplay('miscellaneous',userBudget);
}

class GeneralCategory {

	final Map<String, BudgetCategory> categoryMap = {
		'housing': BudgetCategory.housing,
		'utilities': BudgetCategory.utilities,
		'groceries': BudgetCategory.groceries,
		'savings': BudgetCategory.savings,
		'health': BudgetCategory.health,
		'transportation': BudgetCategory.transportation,
		'education': BudgetCategory.education,
		'entertainment': BudgetCategory.entertainment,
		'kids': BudgetCategory.kids,
		'pets': BudgetCategory.pets,
		'miscellaneous': BudgetCategory.miscellaneous
	};

	final Map<String, String> routeMap = {
		'housing': '/housing',
		'utilities': '/utilities',
		'groceries': '/groceries',
		'savings': '/savings',
		'health': '/health',
		'transportation': '/transport',
		'education': '/education',
		'entertainment': '/entertainment',
		'kids': '/kids',
		'pets': '/pets',
		'miscellaneous': '/misc',
		'home':'/knownUser'
	};

	String categoryView;

	Scaffold generalDisplay(String category, Budget userBudget) {
		this.categoryView = category;
		return Scaffold(
				appBar: AppBar(
					title: Text('User Info'),
				),
				drawer: sideMenu(),
				body: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: <Widget>[remainingInCategory(), categoryExpences()],
				));
	}

	Drawer sideMenu() {
		return Drawer(
			child: ListView.builder(
				scrollDirection: Axis.vertical,
				shrinkWrap: true,
				itemCount: routeMap.keys.length,
				itemBuilder: (BuildContext context, int item) {
					return sideBarFlatButton(routeMap.keys.toList()[item],
							routeMap[routeMap.keys.toList()[item]], context);
				},
			),
		);
	}

	FlatButton sideBarFlatButton(
			String name, String route, BuildContext context) {
		return new FlatButton(
			child: Text(name),
			onPressed: () {
				Navigator.pushNamed(context, route);
			},
		);
	}

	Card remainingInCategory() {
		return Card(
			child: RichText(
				text: TextSpan(
					text: 'Cash Flow in ' + categoryView + ':\n',
					children: <TextSpan>[
						TextSpan(
								text: 'budgeted\n', //todo implement category amounts
								style: TextStyle(color: Colors.green, fontSize: 12)),
						TextSpan(
								text: 'spent -\n',
								style: TextStyle(color: Colors.red, fontSize: 12)),
						TextSpan(
							text: 'remaining:\n',
							style: TextStyle(
									color:
									Colors.black, //todo implemnt color switcher if pos or neg
									fontSize: 12),
						)
					],
				),
			),
		);
	}

	Card categoryExpences() {
		List categoryExpenses = getSpecificTransactions(categoryMap[categoryView]); //todo get specific types of transations
		return Card(
				child: new ListView.builder(
					shrinkWrap: true,
					scrollDirection: Axis.vertical,
					itemCount: categoryExpenses.length,
					itemBuilder: (BuildContext context, int index) {
						return new Text(categoryExpenses[index]);
					},
				));
	}

	List getSpecificTransactions(BudgetCategory category) {
		List retList = [];
		for(Transaction tran in userBudget.transactions.getIterable()){
			if(tran.category == category){
				retList.add(tran);
			}
		}
		return retList;
	}
}

class GeneralSliderCategory{

	BudgetCategory userController;
	GeneralSliderCategory(BudgetCategory userController){
		this.userController = userController;
	}

	Drawer sideMenu(){

	}

	Slider sectionSlider(){

	}

	Scaffold generalDisplay(){

	}





}