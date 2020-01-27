import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_factory.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/priority_budget_factory.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'sidebar/user_catagory_displays.dart' as sideBar;
import 'sidebar/user_info_display.dart' as edit;

//user input validators
int cardOrder = 0;
InformationHolding hold = new InformationHolding();
bool newUser;

//todo move to all string and string dependent data to Strings.dart

void main() => runApp(BudgetingApp());

class BudgetingApp extends StatelessWidget {
  static BudgetControl userController = new BudgetControl();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tree Financial Wellness',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: HomePage(userController),
      initialRoute: '/',
      //InitialRoute
      routes: {
        '/knownUser': (context) => UserPage(userController),
        '/edit': (context) => edit.EditInformationDirectory(userController.getBudget()),
        '/needs':(context) => sideBar.Needs(userController),
        '/wants':(context) => sideBar.Wants(userController),
        '/savings':(context) => sideBar.Savings(userController),
        '/newTransaction': (context) => sideBar.NewTransaction(userController),
        '/firstLoad':(context) => FirstLoad(userController),
      }, //Routes
    );
  }
} // BudgetingApp

class UserPage extends StatefulWidget {
  BudgetControl userController;
  UserPage(BudgetControl userController){
    this.userController = userController;
  }
  @override
  _UserPage createState() => _UserPage(userController);
}

class HomePage extends StatefulWidget {
  BudgetControl userController;

  HomePage(BudgetControl userController){
    this.userController = userController;
  }
  @override
  _HomePage createState() => _HomePage(userController);
}

class FirstLoad extends StatefulWidget{
  BudgetControl userController;
  FirstLoad(BudgetControl userController){
    this.userController = userController;
  }

  @override
  _FirstLoad createState()=> _FirstLoad(userController);
}

class _FirstLoad extends State<FirstLoad>{
  BudgetControl userController;
  _FirstLoad(BudgetControl userController){
    this.userController = userController;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: userController.initialize(newUser),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if(snapshot.hasData){
          Navigator.pushNamed(context, '/knownUser');
        }else if(snapshot.hasError){
          return Scaffold(
              body: Center(child: Text('Error '+snapshot.error.toString()),)
          );
        }
        return sideBar.GeneralSliderCategory(userController).loadingPage();
      },
    );
  }
}

class _HomePage extends State<HomePage>{
  BudgetControl userController;
  _HomePage(BudgetControl userController){
    this.userController = userController;
  }
  
  bool valid = false;
  Scaffold _loginPage(){
    final validationkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Please Login'),
            Column(
              children: <Widget>[
                Form(
                  key:validationkey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter your PIN',
                    ),
                    validator:(value) {
                      if (value.isEmpty) return 'Enter your PIN, please';
                      if (!userController.validInput(value, 'pin'))
                        return 'your PIN should only be 4 numbers';
                      checkValidity(value);
                      return null;
                    },
                    obscureText: true,
                  ),
                ),
                  RaisedButton(
                    onPressed: () {
                      if(validationkey.currentState.validate()) {
                        if (valid) {
                          Navigator.pushNamed(context, '/firstLoad');
                        } else {
                          AlertDialog(content: Text('wrong pin'),);
                        }
                      }
                    },
                    child: Text('Submit'),
                  )
                ],
            )
          ],
      ),
    );
  }

  void checkValidity(value) async {
    if (await userController.passwordIsValid(value)) valid = true;
  }

  Scaffold _informationCollection(GlobalKey<FormState> _formKey) {
    String nameButton = 'next';
    final List<Card> inputFields = <Card>[
      Card(
        child: Form(
            key: _formKey,
            child: Column(
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
                    if (!userController.validInput(value, 'name'))
                      return 'only letters A-Z please';
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'How old are you?', hintText: 'age'),
                  validator: (value) {
                    if (value.isEmpty) return 'please do not leave blank';
                    if (!userController.validInput(value, 'age'))
                      return 'please enter in numeric format';
                    return null;
                  },
                ),
              ],
            )),
      ),
      Card(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'monthly income',
                      labelText: 'regular income',
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'please dont leave blank';
                      if (!userController.validInput(value, 'dollarAmnt'))
                        return 'numerical values only please';
                      hold.setIncomeAmt(double.tryParse(value));
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'savings amount',
                        labelText: 'How much do you have saved?'),
                    validator: (value) {
                      if (value.isEmpty)
                        return ' Please don\'t leave this empty';
                      if (!userController.validInput(value, 'dollarAmnt'))
                        return 'please put in numerical form';
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'If you are dependent on Savings',
                      hintText: 'enter the amount you take monthly from your savings',
                    ),
                    validator: (value) {
                      return null;
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty){
                        hold.setBudgetType(BudgetType.savingDepletion);
                      }
                    },
                  )
                ],
              )
          )
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
                if (!userController.validInput(value, 'dollarAmnt'))
                  return 'please put in to numerical value';
                return null;
              }),
        ),
      ),
      Card(
        /*Housing information continued*/
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText:'Housing Payment',
                    hintText: 'Rent or Mortgage payment',
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'please dont leave Blank';
                    if (!userController.validInput(value, 'dollarAmnt'))
                      return 'Numeric format please';
                    hold.setHousingAmt(double.tryParse(value));
                    return null;
                  },
                ),
              ],
            ),
          )),
      Card(
        //todo figure out the regexp in these validators and why they don't like the the input
        /*Security Information*/
          child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'any four numbers',
                      labelText: 'enter your desired pin'),
                  validator: (value) {
                    if (value.isEmpty) return 'please do not leave blank';
                    if (!userController.validInput(value, 'pin')) return 'please use only numbers';
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 're-enter your PIN', labelText: 'Confirm PIN'),
                  validator: (value) {
                    if (value.isEmpty) return 'please do not leave blank';
                    if (!userController.validInput(value, 'pin')) return 'please use only numbers';
                    if (value.length != 4) return 'only four numbers please';
                    userController.setPassword(value);
                    return null;
                  },
                )
              ])))
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('New User'),
        leading: BackButton(
          onPressed: (){
            if(cardOrder>0) {
              cardOrder--;
              Navigator.pushNamed(context, '/newUser');
            }else{

            }
          },
        ),
      ),
      body:Column(
        children: <Widget>[
          inputFields[cardOrder],
          RaisedButton(
            child: Text(nameButton),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                if (cardOrder < inputFields.length - 1) {
                  if (cardOrder == inputFields.length - 2) {
                    setState(() {
                      nameButton = 'submit';
                    });
                  }
                  cardOrder++;
                  Navigator.pushNamed(context, '/');
                } else {
                  BudgetFactory budgetFactory = new PriorityBudgetFactory();
                  Budget userBudget = budgetFactory.newFromInfo(
                      hold.getIncomeAmt(), hold.getHousingAmt(), hold.getBudgetType());
                  userController.addNewBudget(userBudget);
                  userController.save();
                  Navigator.pushNamed(context, '/knownUser');
                }
              }
            },
          )
        ],
      ),
    );
  }

  Widget _chooseTheScreen() {
     final _formKey = GlobalKey<FormState>();
     return FutureBuilder(
       future: userController.isReturningUser(),
       builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
         if (snapshot.hasData) {
           bool user = snapshot.data;
           if(user){
             newUser = !user;
             return _loginPage();
           }
           newUser = true;
           return _informationCollection(_formKey);
         } else if (snapshot.hasError) {
           return Scaffold(
             appBar: AppBar(
               title: Text('Error'),
             ),
             body:Text.rich(
                 TextSpan(
                   text: 'Error',
                   style: TextStyle(
                     color: Colors.red,
                     backgroundColor: Colors.black,
                     fontSize: 24,
                     fontStyle: FontStyle.italic
                   )
                 )
             )
           );
         }
         return Scaffold(
           body: Column(
             children: <Widget>[
               Text.rich(
                 TextSpan(
                   text:'deciding',
                   style:TextStyle(
                     fontSize: 20,
                   )
                 ),
               )
             ],
           )
         );
       },
     );
   }

  @override
  Widget build(BuildContext context) => _chooseTheScreen();
}

class _UserPage extends State<UserPage> {
  BudgetControl userController;

  _UserPage(BudgetControl userController){
    this.userController = userController;
  }

  @override
  Widget build(BuildContext context) {
    {
      Map<String, double> budgetCatagoryAMNTS = userController.buildBudgetMap();
      return Scaffold(
        appBar: AppBar(
          title: Text(/*users entered name when available*/ 'User Page'),
        ),
        drawer: sideBar.GeneralSliderCategory(userController).sideMenu(),
        body: ListView(
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
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: 'Income: '+userController.getBudget().income.toString()+'\n',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          )),
                      TextSpan(
                          text: 'Expences: -'+userController.expenseTotal().toString()+'\n',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          )),
                      TextSpan(
                          text: 'Cash Flow '+userController.getCashFlow()+'\n',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red, //todo implement a function to return red or green based on cashFlow
                          ))
                    ]))),
            Card(/*user warnings*/),
            Card(
              /*expense tracker*/
                child: new ListView.builder(
                  padding: EdgeInsets.all(8),
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: userController.getLoadedTransactions().length(),
                  itemBuilder: (BuildContext context, int index) {
                    Transaction trans = userController.getLoadedTransactions().getAt(index);
                    if (trans != null) {
                      return new Text(trans.vendor +
                          ' ' +
                          trans.delta.toString() );
                    }
                    return Text('No Transactions');
                  },
                )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/newTransaction');
          },
        ),
      );
    }
  }

} // _UserPage

class InformationHolding {
  double _housingAmt;
  double _incomeAmt;
  BudgetType _budgetType;

  double getHousingAmt() => _housingAmt;

  setHousingAmt(double housingAmt) {
    _housingAmt = housingAmt;
  }
  double getIncomeAmt()=> _incomeAmt;

  setIncomeAmt(double incomeAmt) {
    _incomeAmt = incomeAmt;
  }
  BudgetType getBudgetType() {
    if(_budgetType!=null) return _budgetType;
    return BudgetType.savingGrowth;
  }

  setBudgetType(BudgetType budgetType) {
    _budgetType = budgetType;
  }
}
