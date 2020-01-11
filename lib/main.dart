import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'sidebarOptions/user_catagory_displays.dart' as sideBar;
import 'sidebarOptions/user_info_displayandedit.dart'as edit;
import 'sidebarOptions/hsitory_display.dart'as history;
import 'sidebarOptions/acount_dispaly.dart' as account;

//user input validators
RegExp allNumbers = new RegExp(r"[0-9]{4}");
RegExp allLetters = new RegExp(r"[A-Za-z]+");
RegExp emailVerification =
    new RegExp(r"([^@]+@[^@]+(.com|.org|.net|.gov))");
RegExp dollarAmount = new RegExp(r"([$?0-9]+(.[0-9]{2})?)");
RegExp userNameVerification = new RegExp(r"[A-z0-9!@#?&]{8,16}");
int cardOrder = 0;

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
      home: LoginPage(),
      initialRoute: '/', //InitialRoute
      routes: {
        '/knownUser': (context) => sideBar.UserPage(),
        '/newUser': (context) => UserInformation(),
        '/housing':(context)=> sideBar.HousingView(),
        '/edit':(context)=> edit.EditInformationDirectory(),
        '/houseEdit':(context)=> edit.HousingInformationEdit(),
        '/budgetEdit':(context)=> edit.CategoryInformationEdit(),
        '/userEdit':(context)=> edit.UserInformationEdit(),
        '/historyVeiw':(context)=> history.HistoryDisplay(),
        '/accountVeiw':(context)=> account.AccountDisplay(),
        '/utilities':(context)=> sideBar.UtilitiesView(),
        '/groceries':(context)=> sideBar.GroceriesView(),
        '/savings':(context)=> sideBar.SavingsView(),
         '/health':(context)=> sideBar.HealthView(),
        '/transport':(context)=> sideBar.TransportationView(),
        '/education':(context)=> sideBar.EducationView(),
        '/kids':(context)=> sideBar.KidsView(),
        '/pets':(context)=> sideBar.PetsView(),
        '/misc':(context)=> sideBar.MiscView(),
      }, //Routes
    );
  } // build
} // BudgetingApp

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
} // LoginPage

class UserInformation extends StatefulWidget {
  @override
  _UserInformation createState() => _UserInformation();
}//userInformation

class _LoginPage extends State<LoginPage> {
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
                    if(true) user='nouser';
                    //todo make check if user is a real user
                    return null;
                  },
                  obscureText: true,
                ),
                RaisedButton(
                  onPressed: () {
                    if (user!='nouser') {
                      Navigator.pushNamed(context, 'KnownUser');
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

class _UserInformation extends State<UserInformation>{
  Scaffold informationCollection(){
    String nameButton = 'next';
    final _formKey = GlobalKey<FormState>();
    String housePaymentType = 'Renting';
    bool dependencyOnSavings = false;
    double savingsDraw = 0.0;
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
                  decoration: InputDecoration(
                    hintText: 'regular income',
                    labelText: 'regular income',
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'please dont leave blank';
                    if (!dollarAmount.hasMatch(value))
                      return 'numerical values only please';
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'frequency that your paid?',
                    hintText: 'give number of paychecks per month',
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'please do not leave blank';
                    if (!new RegExp(r'[0-9]{0,2}').hasMatch(value))
                      return 'numerical value please';
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
                value: true,
                onChanged: (value) {
                  setState(() {
                    dependencyOnSavings = value;
                  });
                },
              ),
              RadioListTile(
                groupValue: dependencyOnSavings,
                title: Text('no'),
                value: false,
                onChanged: (value) {
                  setState(() {
                    dependencyOnSavings = value;
                  });
                },
                selected: true,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'How Much are you pulling out of savings?',
                  hintText: 'only fill in oif you selected \'yes\'',
                ),
                validator: (value) {
                  return null;
                },
                enabled: dependencyOnSavings,
                onChanged:  (value) {
                  if (value.isNotEmpty)
                    savingsDraw =
                        double.parse(value.replaceAll('\$', ' ').trim());
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
                decoration: InputDecoration(
                  labelText: housePaymentType + 'Payment',
                  hintText: 'amount in USD',
                ),
                validator: (value) {
                  if (value.isEmpty) return 'please dont leave Blank';
                  if (!dollarAmount.hasMatch(value))
                    return 'Numeric format please';
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