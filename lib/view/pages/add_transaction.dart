import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:budgetflow/view/widgets/drop_downs.dart';
import 'package:budgetflow/view/widgets/main_drawer.dart';
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

    DropdownButton methodInput =
        DropDowns().methodDrop(methodValue, (String newValue) {
      setState(() {
        methodValue = newValue;
      });
    });

    DropdownButton categoryInput =
        DropDowns().categoryDrop(categoryValue, (Category newValue) {
      setState(() {
        categoryValue = newValue;
      });
    });

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
        body: Padding(
          child: Column(
            children: <Widget>[
              addTransactionForm,
              RaisedButton(
                child: Text('submit'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Transaction t = new Transaction(vendorValue, methodValue,
                        -double.parse(amountValue), categoryValue);
                    BudgetingApp.userController.addTransaction(t);
                    BudgetingApp.userController.save();
                    Navigator.pushNamed(context, '/knownUser');
                  }
                },
              )
            ],
          ),
          padding: EdgeInsets.all(8.0),
        ));
  }
}
