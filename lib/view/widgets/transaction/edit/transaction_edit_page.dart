import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/data_types/location.dart';
import 'package:budgetflow/model/data_types/payment_method.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:budgetflow/view/view_presets.dart';
import 'package:budgetflow/view/widgets/location_picker.dart';
import 'package:flutter/material.dart';

class TransactionEditPage extends StatefulWidget {
  final Transaction transaction;

  // Underscore for named constructor makes constructor private
  TransactionEditPage._(this.transaction);

  @override
  State<StatefulWidget> createState() => _TransactionEditPageState(transaction);

  static Future<Transaction> show(
      Transaction toEdit, BuildContext context) async {
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
  final List<PaymentMethod> paymentMethods =
      BudgetingApp.control.dispatcher.accountService.paymentMethods;

  Transaction transactionResult;
  String vendor;
  PaymentMethod method;
  double amount;
  Category category;
  DateTime date;
  TimeOfDay time;
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
    date = initialTransaction.time;
    time = TimeOfDay.fromDateTime(initialTransaction.time);
    location = initialTransaction.location;
    paymentMethods.forEach((method) {
      if (method != null) {
        print('method: ' + method.methodName);
      } else {
        print('passing null method');
      }
    });
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
    List<PaymentMethod> items = paymentMethods;
    return DropdownButton<PaymentMethod>(
      value: method,
      icon: Icon(Icons.arrow_drop_down),
      onChanged: (value) {
        setState(() {
          method = value;
        });
      },
      items: items.map<DropdownMenuItem<PaymentMethod>>((value) {
        return DropdownMenuItem<PaymentMethod>(
          value: value,
          child: Text(value.methodName),
        );
      }).toList(),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      initialValue: initialTransaction.amount.toString(),
      validator: (value) {
        if (value.isEmpty) return InputValidator.requiredMessage;
        if (!InputValidator.dollarAmount(value))
          return InputValidator.dollarMessage;
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
      value: category,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      onChanged: (value) {
        setState(() {
          category = value;
        });
      },
      items: BudgetingApp.control
          .getBudget()
          .allotted
          .map<DropdownMenuItem<Category>>((allocation) {
        return DropdownMenuItem<Category>(
          value: allocation.category,
          child: Text(allocation.category.name),
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
          Location result =
              await LocationPicker.show(context, await Location.current);
          location = result;
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
    String formattedDate = defaultDateFormat.format(date);
    String formattedTime = time.format(context);
    return Row(children: <Widget>[
      Text('Time', style: TextStyle(fontSize: 16)),
      Container(width: 24),
      Expanded(child: Text(formattedDate)),
      _buildDateButton(),
      Expanded(child: Text(formattedTime)),
      _buildTimeButton(),
    ]);
  }

  Widget _buildDateButton() {
    return IconButton(
      onPressed: () {
        showDatePicker(
          context: context,
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          initialDate: DateTime.now(),
          lastDate: DateTime.now(),
        ).then((date) {
          setState(() {
            this.date = date;
          });
        });
      },
      icon: Icon(Icons.calendar_today),
    );
  }

  Widget _buildTimeButton() {
    return IconButton(
      onPressed: () {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((time) {
          setState(() {
            this.time = time;
          });
        });
      },
      icon: Icon(Icons.access_time),
    );
  }

  Widget _buildButton() {
    return RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          DateTime outputDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          BudgetingApp.control.removeTransactionIfPresent(initialTransaction);
          Transaction newTransaction = Transaction(
              amount: -amount,
              category: category,
              method: method,
              time: outputDateTime,
              vendor: vendor,
              location: location);
          BudgetingApp.control.addTransaction(newTransaction);
          BudgetingApp.control.save();
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
