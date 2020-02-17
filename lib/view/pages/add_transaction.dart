import 'package:budgetflow/model/budget/data/category.dart';
import 'package:budgetflow/model/budget/data/transaction.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/global_widgets/main_drawer.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddTransaction extends StatefulWidget {
  static const String ROUTE = '/addTransaction';

  @override
  State<StatefulWidget> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormState>();
  static String methodValue = 'Cash';
  static String amountValue;
  static String vendorValue;
  static Category categoryValue = Category.miscellaneous;

  @override
  Widget build(BuildContext context) {
    TextFormField amountInput = TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Amount of Transaction'),
        validator: (value) {
          if (value.isEmpty) return InputValidator.REQUIRED_MESSAGE;
          if (!InputValidator.dollarAmount(value))
            return InputValidator.DOLLAR_MESSAGE;
          amountValue = value;
          return null;
        });

    TextFormField vendorInput = TextFormField(
        decoration: InputDecoration(labelText: 'Vendor Name'),
        validator: (value) {
          if (value.isEmpty) return InputValidator.REQUIRED_MESSAGE;
          vendorValue = value;
          return null;
        });

    DropdownButton methodInput = DropdownButton<String>(
      value: methodValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      onChanged: (String newValue) {
        setState(() {
          methodValue = newValue;
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

    DropdownButton categoryInput = DropdownButton<Category>(
      value: categoryValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      onChanged: (Category newValue) {
        setState(() {
          categoryValue = newValue;
        });
      },
      items: BudgetingApp.userController.getBudget().categories
          .map<DropdownMenuItem<Category>>((Category category) {
        return DropdownMenuItem<Category>(
          value: category,
          child: Text(category.name),
        );
      }).toList(),
    );

    Form addTransactionForm = Form(
        key: _formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            amountInput,
            vendorInput,
            methodInput,
            categoryInput
          ],
        ));

    return Scaffold(
      appBar: AppBar(title: Text('New Transaction')),
      drawer: SideMenu().sideMenu(BudgetingApp.userController),
      body: Column(
        children: <Widget>[
          addTransactionForm,
          RaisedButton(
            child: Text('submit'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                print('Vendor: $vendorValue');
                print('Method: $methodValue');
                print('Amount: $amountValue');
                print('Category: $categoryValue');
                Transaction t = new Transaction(
                    vendorValue, methodValue, -double.parse(amountValue),
                    categoryValue);
                BudgetingApp.userController.addTransaction(t);
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
