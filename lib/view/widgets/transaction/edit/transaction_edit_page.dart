import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/location/location.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:budgetflow/view/widgets/datetime/date_form_field.dart';
import 'package:budgetflow/view/widgets/datetime/time_form_field.dart';
import 'package:budgetflow/view/widgets/location_picker.dart';
import 'package:flutter/material.dart';

class TransactionEditPage extends StatefulWidget {
  final Transaction transaction;

  // Underscore for named constructor makes constructor private
  TransactionEditPage._(this.transaction);

  @override
  State<StatefulWidget> createState() => _TransactionEditPageState(transaction);

  static Future<Transaction> show(Transaction toEdit,
      BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => TransactionEditPage._(toEdit),
        ));
    return result;
  }
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
    vendor = initialTransaction.vendor;
    method = initialTransaction.method;
    amount = initialTransaction.amount;
    category = initialTransaction.category;
    time = initialTransaction.time;
    location = initialTransaction.location;
  }

  Widget _buildVendorField() {
    return TextFormField(
      initialValue: initialTransaction.vendor,
      onSaved: (value) {
        setState(() {
          vendor = value;
        });
      },
    );
  }

  Widget _buildMethodField() {
    return DropdownButton<String>(
      value: initialTransaction.method,
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
      initialValue: initialTransaction.amount.toString(),
      validator: (value) {
        if (value.isEmpty) return InputValidator.REQUIRED_MESSAGE;
        if (!InputValidator.dollarAmount(value))
          return InputValidator.DOLLAR_MESSAGE;
        return null;
      },
      onSaved: (value) {
        setState(() {
          if (category == Category.income) {
            amount = double.parse(value).abs();
          } else {
            amount = -double.parse(value).abs();
          }
        });
      },
    );
  }

  Widget _buildCategoryField() {
    return DropdownButton<Category>(
      value: initialTransaction.category,
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
          Location result = await LocationPicker.show(
              context, await Location.current);
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

  Widget _buildTimeRow() {
    return Row(children: <Widget>[
      Text('Time', style: TextStyle(fontSize: 16)),
      Container(width: 24),
      Expanded(child: DateFormField(initialTransaction.time)),
      Expanded(child: TimeFormField(initialTransaction.time))
    ]);
  }

  Widget _buildButton() {
    return RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          BudgetingApp.userController
              .removeTransactionIfPresent(transactionResult);
          Transaction newTransaction = Transaction(
              amount: -amount,
              category: category,
              method: method,
              time: time,
              vendor: vendor,
              location: location);
          BudgetingApp.userController.addTransaction(newTransaction);
          BudgetingApp.userController.save();
          Navigator.of(context).pop(newTransaction);
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
                _buildTimeRow(),
                _buildLocationRow(),
                _buildButton()
              ],
              shrinkWrap: true,
            ),
          ),
        ));
  }
}
