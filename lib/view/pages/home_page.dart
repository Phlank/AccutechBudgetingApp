import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_factory.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/priority_budget_factory.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  static int cardOrder = 0;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  InformationHolding hold = new InformationHolding();
  static bool valid = false;
  static final validationKey = GlobalKey<FormState>();

  TextFormField pinLoginInput;
  RaisedButton loginButton;

  HomePageState() {
    _initControls();
  }

  void _initControls() {
    _initPinLoginInput();
    _initLoginButton();
  }

  void _initPinLoginInput() {
    pinLoginInput = TextFormField(
      decoration: InputDecoration(
        hintText: 'PIN',
      ),
      validator: (value) {
        if (value.isEmpty) return 'Enter your PIN';
        if (!InputValidator.pin(value))
          return 'your PIN should only be 4 numbers';
        checkValidity(value);
        return null;
      },
      obscureText: true,
    );
  }

  void _initLoginButton() {
    loginButton = RaisedButton(
      onPressed: () {
        if (validationKey.currentState.validate()) {
          if (valid) {
            Navigator.pushNamed(context, '/firstLoad');
          } else {
            AlertDialog(
              content: Text('wrong pin'),
            );
          }
        }
      },
      child: Text('Submit'),
    );
  }

  Scaffold _loginPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Please Login'),
          Column(
            children: <Widget>[
              Form(
                key: validationKey,
                child: pinLoginInput,
              ),
              loginButton
            ],
          )
        ],
      ),
    );
  }

  static Future checkValidity(value) async {
    if (await BudgetingApp.userController.passwordIsValid(value)) valid = true;
  }

  Scaffold _informationCollection(GlobalKey<FormState> _formKey) {
    String nameButton = 'next';

    Card nameAndAgeCard, incomeAndSavingsCard, housingCard, pinCard;
    TextFormField nameInput,
        ageInput,
        incomeInput,
        savingsInput,
        depleteInput,
        housingInput,
        pinInput,
        confirmPinInput;

    nameInput = TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Name',
      ),
      validator: (value) {
        if (value.isEmpty) return 'Cannot leave blank';
        if (!InputValidator.name(value)) return 'Must be a valid name';
        return null;
      },
    );

    ageInput = TextFormField(
      keyboardType: TextInputType.number,
      decoration:
          InputDecoration(labelText: 'How old are you?', hintText: 'Age'),
      validator: (value) {
        if (value.isEmpty) return 'Cannot leave blank';
        if (!InputValidator.age(value)) return 'Must be a valid number';
        return null;
      },
    );

    nameAndAgeCard = Card(
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('All information is changable after submission'),
              nameInput,
              ageInput,
            ],
          )),
    );

    incomeInput = TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Monthly Income',
        labelText: 'Regular Income',
      ),
      validator: (value) {
        if (value.isEmpty) return 'Must be filled in';
        if (!InputValidator.dollarAmount(value))
          return 'Must be a valid number';
        hold.setIncomeAmt(double.tryParse(value));
        return null;
      },
    );

    savingsInput = TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'savings amount', labelText: 'How much do you have saved?'),
      validator: (value) {
        if (value.isEmpty) return ' Please don\'t leave this empty';
        if (!InputValidator.dollarAmount(value))
          return 'please put in numerical form';
        return null;
      },
    );

    depleteInput = TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'If you are dependent on Savings',
        hintText: 'enter the amount you take monthly from your savings',
      ),
      validator: (value) {
        return null;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          hold.setBudgetType(BudgetType.savingDepletion);
        }
      },
    );

    incomeAndSavingsCard = Card(
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[incomeInput, savingsInput, depleteInput],
            )));

    housingInput = TextFormField(
      decoration: InputDecoration(
        labelText: 'Housing Payment',
        hintText: 'Rent or Mortgage payment',
      ),
      validator: (value) {
        if (value.isEmpty) return 'please dont leave Blank';
        if (!InputValidator.dollarAmount(value)) return 'Numeric format please';
        hold.setHousingAmt(double.tryParse(value));
        return null;
      },
    );

    housingCard = Card(
      /*Housing information continued*/
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[housingInput],
          ),
        ));

    pinInput = TextFormField(
      decoration: InputDecoration(
          hintText: 'any four numbers', labelText: 'enter your desired pin'),
      validator: (value) {
        if (value.isEmpty) return 'please do not leave blank';
        if (!InputValidator.pin(value)) return 'please use only numbers';
        return null;
      },
    );

    confirmPinInput = TextFormField(
      decoration: InputDecoration(
          hintText: 're-enter your PIN', labelText: 'Confirm PIN'),
      validator: (value) {
        if (value.isEmpty) return 'please do not leave blank';
        if (!InputValidator.pin(value)) return 'please use only numbers';
        if (value.length != 4) return 'only four numbers please';
        BudgetingApp.userController.setPassword(value);
        return null;
      },
    );

    pinCard = Card(
        child: Form(
            key: _formKey,
            child: Column(children: <Widget>[pinInput, confirmPinInput])));

    final List<Card> inputCards = <Card>[
      nameAndAgeCard,
      incomeAndSavingsCard,
      housingCard,
      pinCard
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('New User'),
        leading: BackButton(
          onPressed: () {
            if (HomePage.cardOrder > 0) {
              HomePage.cardOrder--;
              Navigator.pushNamed(context, '/newUser');
            } else {}
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          inputCards[HomePage.cardOrder],
          RaisedButton(
            child: Text(nameButton),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                if (HomePage.cardOrder < inputCards.length - 1) {
                  if (HomePage.cardOrder == inputCards.length - 2) {
                    setState(() {
                      nameButton = 'submit';
                    });
                  }
                  HomePage.cardOrder++;
                  Navigator.pushNamed(context, '/');
                } else {
                  BudgetFactory budgetFactory = new PriorityBudgetFactory();
                  Budget userBudget = budgetFactory.newFromInfo(
                      hold.getIncomeAmt(),
                      hold.getHousingAmt(),
                      hold.getBudgetType());
                  BudgetingApp.userController.addNewBudget(userBudget);
                  BudgetingApp.userController.save();
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
      future: BudgetingApp.userController.isReturningUser(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          bool user = snapshot.data;
          if (user) {
            BudgetingApp.newUser = !user;
            return _loginPage();
          }
          BudgetingApp.newUser = true;
          return _informationCollection(_formKey);
        } else if (snapshot.hasError) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Error'),
              ),
              body: Text.rich(TextSpan(
                  text: 'Error',
                  style: TextStyle(
                      color: Colors.red,
                      backgroundColor: Colors.black,
                      fontSize: 24,
                      fontStyle: FontStyle.italic))));
        }
        return Scaffold(
            body: Column(
          children: <Widget>[
            Text.rich(
              TextSpan(
                  text: 'deciding',
                  style: TextStyle(
                    fontSize: 20,
                  )),
            )
          ],
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) => _chooseTheScreen();
}

class InformationHolding {
  static double _housingAmt;
  static double _incomeAmt;
  static BudgetType _budgetType;

  double getHousingAmt() => _housingAmt;

  setHousingAmt(double housingAmt) {
    _housingAmt = housingAmt;
  }

  double getIncomeAmt() => _incomeAmt;

  setIncomeAmt(double incomeAmt) {
    _incomeAmt = incomeAmt;
  }

  BudgetType getBudgetType() {
    if (_budgetType != null) return _budgetType;
    return BudgetType.savingGrowth;
  }

  setBudgetType(BudgetType budgetType) {
    _budgetType = budgetType;
  }
}
