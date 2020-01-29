import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/sidebar/user_catagory_displays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddTransaction extends StatefulWidget {
  static const String ROUTE = '/addTransaction';

  @override
  State<StatefulWidget> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  @override
  Widget build(BuildContext context) {
    var addTransactionKey = GlobalKey<FormState>();
    TransactionInformationHolder holder = new TransactionInformationHolder();
    BudgetCategory defaultCategory = BudgetCategory.groceries;
    final List<String> methodStrings = [
      'Credit',
      'Checking',
      'Savings',
      'Cash'
    ];
    List<DropdownMenuItem> methods = new List<DropdownMenuItem>();
    String method = 'Cash';
    List<DropdownMenuItem> categories = new List<DropdownMenuItem>();
    BudgetCategory category = BudgetCategory.groceries;

    void initState() {
      for (String s in methodStrings) {
        methods.add(new DropdownMenuItem(child: Text(s), value: s));
      }
      for (BudgetCategory c in BudgetCategory.values) {
        categories
            .add(new DropdownMenuItem(child: Text(categoryJson[c]), value: c));
      }
    }

    TextFormField amountInput = TextFormField(
        decoration: InputDecoration(
            labelText: 'Amount of Transaction', hintText: 'numbers only'),
        onChanged: (value) {
          holder.delta = -double.tryParse(value);
        },
        validator: (value) {
          if (value.isEmpty) return 'dont leave empty';
          //if(new RegExp(r'\d+').hasMatch(value)) return 'Numbers please';
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
          //if(new RegExp(r'\w+').hasMatch(value)) return 'words please';
          holder.vendor = value;
          return null;
        });

    DropdownButtonFormField methodInput = DropdownButtonFormField(
      value: method,
      items: methods,
      onChanged: (value) {
        setState(() {
          method = value;
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
      drawer: GeneralSliderCategory(BudgetingApp.userController).sideMenu(),
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
                Transaction t = new Transaction(holder.vendor,
                    holder.method.toString(), holder.delta, holder.category);
                BudgetingApp.userController.addTransaction(t);
              } else {
                Navigator.pushNamed(context, '/knownUser');
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
