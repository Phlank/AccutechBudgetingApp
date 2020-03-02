import 'package:budgetflow/keys.dart';
import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/location/location.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

Future<Transaction> showTransactionEditor(
    Transaction toEdit, BuildContext context) async {
  final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => TransactionEditPage(toEdit)));
  return result;
}

class TransactionEditPage extends StatefulWidget {
  final Transaction transaction;

  TransactionEditPage(this.transaction);

  @override
  State<StatefulWidget> createState() => _TransactionEditPageState(transaction);
}

class _TransactionEditPageState extends State<TransactionEditPage> {
  final Transaction initialTransaction;

  Transaction transactionResult;
  String vendor, method;
  double amount;
  Category category;
  DateTime time;
  Location location;

  final _formKey = GlobalKey<FormState>();

  _TransactionEditPageState(this.initialTransaction);

  @override
  void initState() {
    super.initState();
    vendor = transactionResult.vendor;
    method = transactionResult.method;
    amount = transactionResult.amount;
    category = transactionResult.category;
    time = transactionResult.time;
    location = transactionResult.location;
  }

  Widget _buildVendorField() {
    return TextFormField(
      initialValue: transactionResult.vendor,
      onSaved: (value) {
        vendor = value;
      },
    );
  }

  Widget _buildMethodField() {
    return DropdownButton<String>(
      value: method,
      icon: Icon(Icons.arrow_drop_down),
      onChanged: (value) {
        setState(() {
          method = value;
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

  Widget _buildAmountField() {
    return TextFormField(
      initialValue: transactionResult.amount.toString(),
      validator: (value) {
        if (value.isEmpty) return InputValidator.REQUIRED_MESSAGE;
        if (!InputValidator.dollarAmount(value))
          return InputValidator.DOLLAR_MESSAGE;
        return null;
      },
      onSaved: (value) {
        setState(() {
          amount = double.parse(value);
        });
      },
    );
  }

  Widget _buildCategoryField() {
    return DropdownButton<Category>(
      value: category,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      onChanged: (value) {
        setState(() {
          category = value;
        });
      },
      items: BudgetingApp.userController
          .getBudget()
          .categories
          .map<DropdownMenuItem<Category>>((Category category) {
        return DropdownMenuItem<Category>(
          value: category,
          child: Text(category.name),
        );
      }).toList(),
    );
  }

  Widget _buildVendorRow() {
    return Row(
      children: <Widget>[
        Text(
          'Vendor',
          style: TextStyle(fontSize: 16),
        ),
        Container(width: 24),
        Expanded(child: _buildVendorField())
      ],
    );
  }

  Widget _buildMethodRow() {
    return Row(
      children: <Widget>[
        Text(
          'Method',
          style: TextStyle(fontSize: 16),
        ),
        Container(width: 24),
        Expanded(child: _buildMethodField())
      ],
    );
  }

  Widget _buildAmountRow() {
    return Row(
      children: <Widget>[
        Text(
          'Amount',
          style: TextStyle(fontSize: 16),
        ),
        Container(width: 24),
        Expanded(child: _buildAmountField())
      ],
    );
  }

  Widget _buildLocationRow() {
    return Row(children: <Widget>[
      Text('Location', style: TextStyle(fontSize: 16)),
      Container(width: 24),
      RaisedButton(
        child: Text('Select location'),
        onPressed: () async {
          // Load google maps interface
          LocationResult result =
              await showLocationPicker(context, googleMapsAPIKey);
          location = Location(result.latLng.latitude, result.latLng.longitude);
        },
      )
    ]);
  }

  Widget _buildCategoryRow() {
    return Row(
      children: <Widget>[
        Text(
          'Category',
          style: TextStyle(fontSize: 16),
        ),
        Container(width: 24),
        Expanded(child: _buildCategoryField())
      ],
    );
  }

  Widget _buildButton() {
    return RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          Navigator.pop(context);
          BudgetingApp.userController.removeTransaction(transactionResult);
          Transaction newTransaction = Transaction.withTime(
              vendor, method, amount, category, time, location);
          BudgetingApp.userController.addTransaction(newTransaction);
          BudgetingApp.userController.save();
          if (location != null) {
            print('Location: ' +
                location.latitude.toString() +
                ', ' +
                location.longitude.toString());
          }
        }
      },
      child: Text('Submit'),
      textTheme: ButtonTextTheme.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Transaction'),
        ),
        body: Form(
          key: _formKey,
          child: Padding24(
            child: ListView(
              children: <Widget>[
                _buildVendorRow(),
                _buildMethodRow(),
                _buildAmountRow(),
                _buildCategoryRow(),
                _buildLocationRow(),
                _buildButton()
              ],
              shrinkWrap: true,
            ),
          ),
        ));
  }
}
