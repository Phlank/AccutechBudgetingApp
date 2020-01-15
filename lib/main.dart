import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/budget_factory.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/model/history/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';
import 'sidebar/account_display.dart' as account;
import 'sidebar/history_display.dart' as history;
import 'sidebar/user_catagory_displays.dart' as sideBar;
import 'sidebar/user_info_display.dart' as edit;

//user input validators
RegExp allNumbers = new RegExp(r"[0-9]{4}");
RegExp allLetters = new RegExp(r"[A-Za-z]+");
RegExp emailVerification =
    new RegExp(r"([^@]+@[^@]+(.com|.org|.net|.gov))");
RegExp dollarAmount = new RegExp(r"([$?0-9]+(.[0-9]{2})?)");
RegExp userNameVerification = new RegExp(r"[A-z0-9!@#?&]{8,16}");
int cardOrder = 0;
History userHistory = new History();
Budget userBudget;
//todo implement a global storage object to retain and disperse all of the information

void main() => runApp(BudgetingApp());

class BudgetingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tree Financial Wellness',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: HomePage(),
      initialRoute: '/', //InitialRoute
      routes: {
        '/knownUser': (context) => UserPage(),
        '/newUser': (context) => UserInformation(),
        '/housing':(context)=> sideBar.HousingView(userBudget),
        '/edit':(context)=> edit.EditInformationDirectory(userBudget),
        '/houseEdit':(context)=> edit.HousingInformationEdit(userBudget),
        '/budgetEdit':(context)=> edit.CategoryInformationEdit(userBudget),
        '/userEdit':(context)=> edit.UserInformationEdit(userBudget),
        '/historyVeiw':(context)=> history.HistoryDisplay(),
        '/accountVeiw':(context)=> account.AccountDisplay(),
        '/utilities':(context)=> sideBar.UtilitiesView(userBudget),
        '/groceries':(context)=> sideBar.GroceriesView(userBudget),
        '/savings':(context)=> sideBar.SavingsView(userBudget),
         '/health':(context)=> sideBar.HealthView(userBudget),
        '/transport':(context)=> sideBar.TransportationView(userBudget),
        '/education':(context)=> sideBar.EducationView(userBudget),
        '/kids':(context)=> sideBar.KidsView(userBudget),
        '/pets':(context)=> sideBar.PetsView(userBudget),
        '/misc':(context)=> sideBar.MiscView(userBudget),
        '/entertainment':(context)=> sideBar.EntertainmentView(userBudget),
        '/newTransaction':(context)=> sideBar.NewTransaction(userBudget),
      }, //Routes

    );
  }

} // BudgetingApp

class UserPage extends StatefulWidget {
  @override
  _UserPage createState() => _UserPage();
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => chooseState();

  State chooseState(){
    if(userHistory.isNewUser()) return _UserInformation();
    return _LoginPage();
  }

}

class UserInformation extends StatefulWidget {
  @override
  _UserInformation createState() => _UserInformation();
}//userInformation

class _UserPage extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    if(userBudget == null){
      userBudget = userHistory.budget;
    }
    Map<String, double> budgetCatagoryAMNTS = buildBudgetMap();
    TransactionList expenses = userBudget.transactions; //todo get expenses list from where ever that might be
    return Scaffold(
      appBar: AppBar(
        title: Text(/*users entered name when available*/ 'User Page'),
      ),
      drawer: new sideBar.GeneralCategory().sideMenu(),
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
                itemCount: expenses.length(),
                itemBuilder: (BuildContext context, int index) {
                  Transaction trans = expenses.getAt(index);
                  return new Text(trans.vendor+'\n'+trans.delta.toString()+'\n'+trans.datetime.toIso8601String()+'\n'+trans.method);
                },
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, '/newTransaction' );
        },
      ),
    );
  } //build

  Map<String, double> buildBudgetMap() {

    Map<String, double> map = new Map();
    map.putIfAbsent('housing', () => userBudget.allottedSpending.valueOf(BudgetCategory.housing));
    map.putIfAbsent('utilities', () => userBudget.allottedSpending.valueOf(BudgetCategory.utilities));
    map.putIfAbsent('groceries', () => userBudget.allottedSpending.valueOf(BudgetCategory.groceries));
    map.putIfAbsent('savings', () => userBudget.allottedSpending.valueOf(BudgetCategory.savings));
    map.putIfAbsent('helath', () => userBudget.allottedSpending.valueOf(BudgetCategory.health));
    map.putIfAbsent('transportation', () => userBudget.allottedSpending.valueOf(BudgetCategory.transportation));
    map.putIfAbsent('education', () => userBudget.allottedSpending.valueOf(BudgetCategory.education));
    map.putIfAbsent('entertainment', () => userBudget.allottedSpending.valueOf(BudgetCategory.entertainment));
    map.putIfAbsent('kids', () => userBudget.allottedSpending.valueOf(BudgetCategory.kids));
    map.putIfAbsent('pets', () => userBudget.allottedSpending.valueOf(BudgetCategory.pets));
    map.putIfAbsent('miscellaneous', () => userBudget.allottedSpending.valueOf(BudgetCategory.miscellaneous));
    return map;
  }
} // _UserPage

class _LoginPage extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String user = 'nouser';
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Please Login'),
            Spacer(
              flex: 1,
            ),
            Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your PIN',
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'Enter your PIN, please';
                    if (!allNumbers.hasMatch(value))
                      return 'your PIN should only be 4 numbers';
                    if(userHistory.passwordIsValid(value)) user='user';
                    //todo make check if user is a real user
                    return null;
                  },
                  obscureText: true,
                ),
                RaisedButton(
                  onPressed: () {
                    if (user!='nouser') {
                      Navigator.pushNamed(context, '/knownUser');
                    }else{
                      Text('please try again');
                    }
                  },
                  child: Text('Submit'),
                )
              ],
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/newUser');
              },
              child: Text('New User'),
            )
          ],
        ),
      ),
    );
  } // build
} //_LoginPage

final  housingCon = new TextEditingController();
final incomeCon = new TextEditingController();

InformationHolding hold = new InformationHolding();

class _UserInformation extends State<HomePage>{

  @override
  void dispose(){
    housingCon.dispose();
    incomeCon.dispose();
    super.dispose();
  }

  Scaffold informationCollection(){
    String nameButton = 'next';
    final _formKey = GlobalKey<FormState>();
    String housePaymentType = 'Renting';
    BudgetType dependencyOnSavings = BudgetType.savingGrowth;
    List<Card> inputFields = <Card>[
      Card(
        child:Form(
          key: _formKey,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('all information is changable after submision'),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Name: ',
                  hintText: 'Enter your Name',
                ),
                validator: (value) {
                  if (value.isEmpty) return 'please enter your name';
                  if (!allLetters.hasMatch(value)) return 'only letters A-Z please';
                  return null;
                },
                onSaved: (value){
                  //todo load in to global object
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'How old are you?', hintText: 'age'),
                validator: (value) {
                  if (value.isEmpty) return 'please do not leave blank';
                  if (!new RegExp(r"[0-9]{2,3}").hasMatch(value))
                    return 'please enter in numeric format';
                  return null;
                },
                onSaved: (value){
                  //todo load in to global object
                },
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email: ',
                  hintText: 'email',
                ),
                validator: (value) {
                  if (value.isEmpty) return 'please input your email';
                  if (!emailVerification.hasMatch(value))
                    return 'please enter a valid email \n (eg. name23436@example.com)';
                  return null;
                },
                onSaved: (value){
                  //todo load in to global object
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'UserName: ',
                    hintText:
                    'A-z 0-9 !? no spaces and between 8-16 characters'),
                validator: (value) {
                  if (value.isEmpty) return 'Please enter a username';
                  if (!userNameVerification.hasMatch(value))
                    return 'please only alphanumeric and !?&#@ no spaces';
                  return null;
                },
                onSaved: (value){
                  //todo load in to global object
                },
              ),
            ],
          )
        ),
      ),
      Card(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: incomeCon,
                  decoration: InputDecoration(
                    hintText: 'monthly income',
                    labelText: 'regular income',
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'please dont leave blank';
                    if (!dollarAmount.hasMatch(value))
                      return 'numerical values only please';
                    hold.setIncome(double.tryParse(value));
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'savings amount',
                      labelText: 'How much do you have saved?'),
                  validator: (value) {
                    if (value.isEmpty) return ' Please don\'t leave this empty';
                    if (!dollarAmount.hasMatch(value))
                      return 'please put in numerical form';
                    return null;
                  },
                ),
              ],
            )
          )
      ),
      Card(
        child: Form (
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text('Are you currently pulling out of savings to make ends meat?'),
              RadioListTile(
                groupValue: dependencyOnSavings,
                title: Text('yes'),
                value: BudgetType.savingDepletion,
                onChanged: (value) {
                  setState(() {
                    dependencyOnSavings = value;
                  });
                },
              ),
              RadioListTile(
                groupValue: dependencyOnSavings,
                title: Text('no'),
                value: BudgetType.savingGrowth,
                onChanged: (value) {
                  setState(() {
                    dependencyOnSavings = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'How Much are you pulling out of savings?',
                  hintText: 'only fill in oif you selected \'yes\'',
                ),
                validator: (value) {
                  return null;
                },
                enabled: false,
                onChanged:  (value) {
                  if (value.isNotEmpty)

                  return null;
                },
              )
            ],
          ),
        ),
      ),
      Card(
        child: Form(
          key: _formKey,
          child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'dollar amt',
                  labelText: 'How much debt in total do you have?'),
              validator: (value) {
                if (value.isEmpty) return 'please do not leave empty';
                if (!dollarAmount.hasMatch(value))
                  return 'please put in to numerical value';
                return null;
              }),
        ),
      ),
      Card(
        /*Housing Information*/
        child:Form(
          key: _formKey,
          child:Column(
            children: <Widget>[
              Text('What type of housing situation best describes you?'),
              RadioListTile(
                title: const Text('Renting'),
                value: 'renting',
                groupValue: housePaymentType,
                onChanged: (value) {
                  setState(() {
                    housePaymentType = value;
                  });
                },
                selected: true,
              ),
              RadioListTile(
                title: const Text('Own with Mortgage'),
                value: 'own with payment',
                groupValue: housePaymentType,
                onChanged: (value) {
                  setState(() {
                    housePaymentType = value;
                  });
                },
              ),
              RadioListTile(
                title: Text('Own no payments left'),
                value: 'own',
                groupValue: housePaymentType,
                onChanged: (value) {
                  setState(() {
                    cardOrder++;
                    //todo set housing to $0
                    housePaymentType = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      Card(
        /*Housing information continued*/
        child:Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: housingCon,
                decoration: InputDecoration(
                  labelText: housePaymentType + 'Payment',
                  hintText: 'amount in USD',
                ),
                validator: (value) {
                  if (value.isEmpty) return 'please dont leave Blank';
                  if (!dollarAmount.hasMatch(value))
                    return 'Numeric format please';
                  hold.setHouse(double.tryParse(value));
                  return null;
                },
              ),
            ],
          ),
        )
      ),
      Card(
        //todo figure out the regexp in these validators and why they don't like the the input
        /*Security Information*/
          child:Form(
              key: _formKey,
              child: Column(
                  children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'any four numbers',
                        labelText: 'enter your desired pin'),
                    validator: (value) {
                      if (value.isEmpty) return 'please do not leave blank';
                      //if (allNumbers.hasMatch(value)) return 'please use only numbers';
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 're-enter your PIN', labelText: 'Confirm PIN'),
                    validator: (value) {
                      if (value.isEmpty) return 'please do not leave blank';
                      //if (new RegExp(r'[0-9][0-9][0-9][0-9]').hasMatch(value)) return 'please use only numbers';
                      if (value.length != 4) return 'only four numbers please';
                      return null;
                    },
                  )
                ]
              )
          )
        )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('New User'),
      ),
      body: Column(
        children: <Widget>[
          inputFields[cardOrder],
          RaisedButton(
            child: Text(nameButton),
            onPressed: (){
              if(_formKey.currentState.validate()){
                if(cardOrder<inputFields.length-1){
                  if(cardOrder==5){
                    setState(() {
                      nameButton = 'submit';
                    });
                  }
                  cardOrder++;
                  Navigator.pushNamed(context, '/newUser');
                }else {
                  userBudget = BudgetFactory.newFromInfo(hold.incomeamt,hold.housingamt, dependencyOnSavings);
                  Navigator.pushNamed(context, '/knownUser');
              }}},
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return informationCollection();
  }
}

class InformationHolding{
  double housingamt;
  double incomeamt;
  InformationHolding();
  setHouse(double housingamt){
    this.housingamt =housingamt;
  }
  setIncome(double incomeamt){
    this.incomeamt = incomeamt;
  }
}