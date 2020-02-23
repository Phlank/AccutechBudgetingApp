import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/sidebar/account_display.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:budgetflow/view/utils/output_formatter.dart';
import 'package:budgetflow/view/widgets/drop_downs.dart';
import 'package:budgetflow/view/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class TransactionDetailEdit extends StatefulWidget {
  final Transaction transaction;

  TransactionDetailEdit(this.transaction);

  @override
  State<StatefulWidget> createState() =>
      _TransactionDetailEditState(transaction);
}

class _TransactionDetailEditState extends State<TransactionDetailEdit> {
  Transaction transaction;
  Map<String, String> transactionMap = new Map();
  TextStyle style = TextStyle(
    fontSize: 20,
  );
  Category initCat;
  String initMethod;

  _TransactionDetailEditState(this.transaction) {
    initCat = transaction.category;
    initMethod = transaction.method;
  }

  Transaction _mapToTransaction() {
    String vendor = transactionMap['vendor'];
    String method = transactionMap['method'];
    Category category =
        Category.categoryFromString(transactionMap['category']);
    double amount = double.tryParse(transactionMap['amount'] == null
        ? transaction.amount.toString()
        : transactionMap['amount']);

    return new Transaction.withTime(
        vendor == null ? transaction.vendor : vendor,
        method == null ? transaction.method : method,
        amount == null ? transaction.amount : amount,
        category == null ? transaction.category : category,
        transaction.time);
  }

  TableRow _genericTextField(dynamic initValue, String valueTitle) {
    Text title = Text(
      Format.titleFormat(valueTitle),
      style: style,
    );
    TextFormField textInput = TextFormField(
      initialValue: Format.dynamicFormating(initValue),
      validator: (value) {
        if (value.isEmpty) return 'Must fill this in';
        if (!InputValidator.dynamicValidation(initValue.runtimeType, value))
          return 'Please put in correct format';
        transactionMap[valueTitle] = value;
        return null;
      },
    );
    return TableRow(children: [title, textInput]);
  }

  RaisedButton _navButton() {
    return RaisedButton(
        child: Text('submit'),
        onPressed: () {
          Transaction t = _mapToTransaction();
          BudgetingApp.userController.removeTransaction(transaction);
          BudgetingApp.userController.addTransaction(t);

          Navigator.pushNamed(context, AccountDisplay.ROUTE);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transatcion Detail'),
      ),
      drawer: SideMenu().sideMenu(BudgetingApp.userController),
      body: Column(children: <Widget>[
        Table(
          children: <TableRow>[
            _genericTextField(transaction.vendor, 'vendor'),
            _genericTextField(transaction.amount, 'amount'),
            TableRow(
              children: [
                Text(
                  'Category',
                  style: style,
                ),
                DropDowns().categoryDrop(initCat, (Category newCat) {
                  setState(() {
                    initCat = newCat;
                    transactionMap['category'] = newCat.name;
                  });
                })
              ],
            ),
            TableRow(
              children: [
                Text('Method', style: style),
                DropDowns().methodDrop(initMethod, (String method) {
                  setState(() {
                    initMethod = method;
                    transactionMap['method'] = method;
                  });
                })
              ],
            ),
          ],
        ),
        _navButton(),
      ]),
    );
  }
}
