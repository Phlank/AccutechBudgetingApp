import 'package:budgetflow/model/budget/category/category.dart' as cat;
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/sidebar/account_display.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:budgetflow/view/utils/output_formatter.dart';
import 'package:budgetflow/view/utils/padding.dart';
import 'package:budgetflow/view/widgets/drop_downs.dart';
import 'package:budgetflow/view/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class TransactionDetailEdit extends StatefulWidget {
  final Transaction t;

  TransactionDetailEdit(this.t);

  @override
  State<StatefulWidget> createState() => _TransactionDetailEditState(t);
}

class _TransactionDetailEditState extends State<TransactionDetailEdit> {
  Transaction tran;
  Map<String, String> transactionMap;
  TextStyle style = TextStyle(
    color: Colors.black,
    fontSize: 20,
  );
  cat.Category initCat;
  String initMethod;
  final _formKey = GlobalKey<FormState>();

  _TransactionDetailEditState(this.tran) {
    initCat = tran.category;
    initMethod = tran.method;
    transactionMap = {
      'vendor': tran.vendor,
      'method': tran.method,
      'category': tran.category.name,
      'amount': tran.amount.toString()
    };
  }

  Transaction _mapToTrans() {
    String vendor = transactionMap['vendor'];
    String method = transactionMap['method'];
    cat.Category category =
        cat.Category.categoryFromString(transactionMap['category']);
    double amount = double.tryParse(transactionMap['amount'] == null
        ? tran.amount.toString()
        : transactionMap['amount']);

    return new Transaction.withTime(
        vendor == null ? tran.vendor : vendor,
        method == null ? tran.method : method,
        amount == null ? tran.amount : amount,
        category == null ? tran.category : category,
        tran.time);
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
          if (_formKey.currentState.validate()) {
            Transaction t = _mapToTrans();
            BudgetingApp.userController.removeTransaction(tran);
            BudgetingApp.userController.addTransaction(t);
            BudgetingApp.userController.save();
            Navigator.pushNamed(context, AccountDisplay.ROUTE);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transatcion Detail'),
      ),
      drawer: SideMenu().sideMenu(BudgetingApp.userController),
      body: Padding24(
          child: Column(
        children: <Widget>[
          Form(
              key: _formKey,
              child: Table(
                children: <TableRow>[
                  _genericTextField(tran.vendor, 'vendor'),
                  _genericTextField(tran.amount, 'amount'),
                  TableRow(
                    children: [
                      Text(
                        'Category',
                        style: style,
                      ),
                      DropDowns().categoryDrop(initCat, (cat.Category newCat) {
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
              )),
          _navButton(),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      )),
    );
  }
}
