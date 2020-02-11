import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_factory.dart';
import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/budget/priority_budget_factory.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SetupPage extends StatefulWidget {
  static int cardOrder = 0;
  static const String ROUTE = '/setup';

  @override
  State<StatefulWidget> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  var _formKey;
  InformationHolding hold = new InformationHolding();
  String nameButton = 'next';
  AppBar appBar;
  Card nameAndAgeCard, incomeAndSavingsCard, housingCard, pinCard;
  TextFormField nameInput,
      ageInput,
      incomeInput,
      savingsInput,
      depleteInput,
      housingInput,
      pinInput,
      confirmPinInput;
  List<Card> inputCards;

  _SetupPageState() {
    _formKey = GlobalKey<FormState>();
    _initControls();
  }

  void _initControls() {
    _initNameInput();
    _initAgeInput();
    _initNameAndAgeCard();
    _initIncomeInput();
    _initSavingsInput();
    _initDepleteInput();
    _initIncomeAndSavingsCard();
    _initHousingInput();
    _initHousingCard();
    _initPinInput();
    _initConfirmPinInput();
    _initPinCard();
    _initCards();
    _initAppBar();
  }

  void _initNameInput() {
    nameInput = TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Name',
      ),
      validator: (value) {
        if (value.isEmpty) return InputValidator.REQUIRED_MESSAGE;
        if (!InputValidator.name(value)) return 'Must be a valid name';
        return null;
      },
    );
  }

  void _initAgeInput() {
    ageInput = TextFormField(
      keyboardType: TextInputType.number,
      decoration:
          InputDecoration(labelText: 'How old are you?', hintText: 'Age'),
      validator: (value) {
        if (value.isEmpty) return InputValidator.REQUIRED_MESSAGE;
        if (!InputValidator.age(value)) return 'Must be a valid number';
        return null;
      },
    );
  }

  void _initNameAndAgeCard() {
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
  }

  void _initIncomeInput() {
    incomeInput = TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Monthly Income',
        labelText: 'Regular Income',
      ),
      validator: (value) {
        if (value.isEmpty) return InputValidator.REQUIRED_MESSAGE;
        if (!InputValidator.dollarAmount(value))
          return InputValidator.DOLLAR_MESSAGE;
        hold.setIncomeAmt(double.tryParse(value));
        return null;
      },
    );
  }

  void _initSavingsInput() {
    savingsInput = TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'savings amount', labelText: 'How much do you have saved?'),
      validator: (value) {
        if (value.isEmpty) return InputValidator.REQUIRED_MESSAGE;
        if (!InputValidator.dollarAmount(value))
          return 'please put in numerical form';
        return null;
      },
    );
  }

  void _initDepleteInput() {
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
  }

  void _initIncomeAndSavingsCard() {
    incomeAndSavingsCard = Card(
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[incomeInput, savingsInput, depleteInput],
            )));
  }

  void _initHousingInput() {
    housingInput = TextFormField(
      keyboardType: TextInputType.number,
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
  }

  void _initHousingCard() {
    housingCard = Card(
        /*Housing information continued*/
        child: Form(
      key: _formKey,
      child: Column(
        children: <Widget>[housingInput],
      ),
    ));
  }

  void _initPinInput() {
    pinInput = TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Any four numbers', labelText: 'Create a PIN'),
      validator: (value) {
        if (value.isEmpty) return InputValidator.REQUIRED_MESSAGE;
        if (!InputValidator.pin(value)) return InputValidator.PIN_MESSAGE;
        return null;
      },
      obscureText: true,
    );
  }

  void _initConfirmPinInput() {
    confirmPinInput = TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Confirm PIN'),
      validator: (value) {
        if (value.isEmpty) return InputValidator.REQUIRED_MESSAGE;
        if (!InputValidator.pin(value)) return InputValidator.PIN_MESSAGE;
        BudgetingApp.userController.setPassword(value);
        return null;
      },
      obscureText: true,
    );
  }

  void _initPinCard() {
    pinCard = Card(
        child: Form(
            key: _formKey,
            child: Column(children: <Widget>[pinInput, confirmPinInput])));
  }

  void _initCards() {
    inputCards = <Card>[
      nameAndAgeCard,
      incomeAndSavingsCard,
      housingCard,
      pinCard
    ];
  }

  void _initAppBar() {
    appBar = AppBar(
      title: Text('New User'),
      leading: BackButton(
        onPressed: () {
          if (SetupPage.cardOrder > 0) {
            SetupPage.cardOrder--;
            Navigator.pushNamed(context, '/newUser');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          inputCards[SetupPage.cardOrder],
          RaisedButton(
            child: Text(nameButton),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                if (SetupPage.cardOrder < inputCards.length - 1) {
                  if (SetupPage.cardOrder == inputCards.length - 2) {
                    setState(() {
                      nameButton = 'submit';
                    });
                  }
                  SetupPage.cardOrder++;
                  Navigator.pushNamed(context, '/setup');
                } else {
                  BudgetFactory budgetFactory = new PriorityBudgetFactory();
                  Budget userBudget = budgetFactory.newFromInfo(
                      hold.getIncomeAmt(),
                      hold.getHousingAmt(),
                      hold.getBudgetType());
                  BudgetingApp.userController.addNewBudget(userBudget);
                  BudgetingApp.userController.save();
                  while (Navigator.canPop(context)) Navigator.pop(context);
                  Navigator.pushNamed(context, '/knownUser');
                }
              }
            },
          )
        ],
      ),
    );
  }
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
