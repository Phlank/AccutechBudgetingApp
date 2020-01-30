import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/global_widgets/main_drawer.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  @override
  Widget build(BuildContext context) {
    final addTransactionKey = GlobalKey<FormState>();
    TransactionInformationHolder holder = new TransactionInformationHolder();
    BudgetCategory defaultCategory = BudgetCategory.groceries;
    String defaultMethod = 'Cash';

    TextFormField amountInput = TextFormField(
        decoration: InputDecoration(
            labelText: 'Amount of Transaction', hintText: 'numbers only'),
        onChanged: (value) {
          holder.delta = -double.tryParse(value);
        },
        validator: (value) {
          if (value.isEmpty) return 'dont leave empty';
          if(InputValidator.dollarAmount(value)) return 'Numbers please';
          holder.delta = -double.tryParse(value);
          return null;
        });

    TextFormField vendorInput = TextFormField(
        decoration: InputDecoration(
            labelText: 'Where did you spend method', hintText: 'words only'),
        onChanged: (value) {
          holder.vendor = value;
        },
        validator: (value) {
          if (value.isEmpty) return 'dont leave empty';
          if(InputValidator.name(value)) return 'words please';
          holder.vendor = value;
          return null;
        });

    List<DropdownMenuItem> dropdownMethodItems() {
      List<String> methods = ['Credit', 'Checking', 'Savings', 'Cash'];
      List<DropdownMenuItem> retList = new List();
      for (String method in methods) {
        retList.add(new DropdownMenuItem(
          child: Text(method),
          value: method,
        ));
      }
      return retList;
    }

    DropdownButtonFormField methodInput = DropdownButtonFormField(
      value: defaultMethod,
      items: dropdownMethodItems(),
      onChanged: (value) {
        setState(() {
          defaultMethod = value;
        });
        holder.method = value;
        return value;
      },
    );

    List<DropdownMenuItem> dropdownCategoryItems() {
      List<DropdownMenuItem> retList = new List();
      for (String name
          in BudgetingApp.userController.categoryMap.keys.toList()) {
        retList.add(new DropdownMenuItem(
          child: Text(name),
          value: BudgetingApp.userController.categoryMap[name],
        ));
      }
      return retList;
    }

    DropdownButtonFormField categoryInput = DropdownButtonFormField(
        value: defaultCategory,
        items: dropdownCategoryItems(),
        onChanged: (value) {
          setState(() {
            defaultCategory = value;
          });
          holder.category = value;
          return value;
        });

    return Scaffold(
      appBar: AppBar(title: Text('New Transaction')),
      drawer: SideMenu().sideMenu(BudgetingApp.userController),
      body: Column(
        children: <Widget>[
          Form(
              key: addTransactionKey,
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  amountInput,
                  vendorInput,
                  methodInput,
                  categoryInput
                ],
              )),
          RaisedButton(
            child: Text('submit'),
            onPressed: () {
              if (addTransactionKey.currentState.validate()) {
                Transaction t = new Transaction(holder.vendor, holder.method,
                    holder.delta, holder.category);
                BudgetingApp.userController.addTransaction(t);
              }
            },
          )
        ],
      ),
    );
  }
}

class TransactionInformationHolder {
  double delta;
  String vendor;
  String method;
  BudgetCategory category;
}
