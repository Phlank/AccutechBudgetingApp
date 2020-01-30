import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/global_widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddTransaction extends StatefulWidget {
  static const String ROUTE = '/addTransaction';

  @override
  State<StatefulWidget> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  static double amount;
  static String vendor;
  static String method;
  static BudgetCategory category;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    TextFormField amountInput = TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Amount of Transaction'),
        onChanged: (value) {
          amount = -double.tryParse(value);
        },
        validator: (value) {
          if (value.isEmpty) return 'dont leave empty';
//          if (InputValidator.dollarAmount(value)) return 'Numbers please';
          amount = -double.tryParse(value);
          return null;
        });

    TextFormField vendorInput = TextFormField(
        decoration: InputDecoration(labelText: 'Vendor Name'),
        onChanged: (value) {
          vendor = value;
        },
        validator: (value) {
          if (value.isEmpty) return 'Cannot be empty';
//          if (InputValidator.name(value)) return 'words please';
          vendor = value;
          return null;
        });

    return Scaffold(
      appBar: AppBar(title: Text('New Transaction')),
      drawer: SideMenu().sideMenu(BudgetingApp.userController),
      body: Column(
        children: <Widget>[
          Form(
              key: _formKey,
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  amountInput,
                  vendorInput,
                  MethodDropdownButton(),
                  CategoryDropdownButton()
                ],
              )),
          RaisedButton(
            child: Text('submit'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Transaction t =
                new Transaction(vendor, method, amount, category);
                print(t);
                BudgetingApp.userController.addTransaction(t);
                print('Added transaction');
                BudgetingApp.userController.save();
                Navigator.pushNamed(context, '/knownUser');
              }
            },
          )
        ],
      ),
    );
  }
}

class MethodDropdownButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MethodDropdownButtonState();
}

class _MethodDropdownButtonState extends State<MethodDropdownButton> {
  String methodValue = 'Cash';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: methodValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      onChanged: (String newValue) {
        setState(() {
          methodValue = newValue;
          _AddTransactionState.method = newValue;
        });
      },
      items: <String>['Cash', 'Credit', 'Checking', 'Savings']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class CategoryDropdownButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoryDropdownButtonState();
}

class _CategoryDropdownButtonState extends State<CategoryDropdownButton> {
  BudgetCategory categoryValue = BudgetCategory.miscellaneous;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<BudgetCategory>(
      value: categoryValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      onChanged: (BudgetCategory newValue) {
        setState(() {
          categoryValue = newValue;
          _AddTransactionState.category = categoryValue;
        });
      },
      items: BudgetCategory.values
          .map<DropdownMenuItem<BudgetCategory>>((BudgetCategory category) {
        return DropdownMenuItem<BudgetCategory>(
          value: category,
          child: Text(categoryJson[category]),
        );
      }).toList(),
    );
  }
}

class TransactionInformationHolder {
  double delta;
  String vendor;
  String method;
  BudgetCategory category;
}
