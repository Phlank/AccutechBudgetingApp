import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:budgetflow/view/utils/output_formatter.dart';
import 'package:flutter/material.dart';

class TransactionDetailEdit extends StatefulWidget{
  Transaction t;
  TransactionDetailEdit(this.t);
  @override
  State<StatefulWidget> createState() => _TransactionDetailEditState(t);

}

class _TransactionDetailEditState extends State<TransactionDetailEdit>{
  Transaction t;
  _TransactionDetailEditState(this.t);
  @override
  Widget build(BuildContext context) => new TransactionDetail().editDetail(t,context);

}

class TransactionDetailView extends StatefulWidget{
  Transaction t;
  TransactionDetailView(this.t);
  @override
  State<StatefulWidget> createState() => new _TransactionDetailViewState(t);
}

class _TransactionDetailViewState extends State<TransactionDetailView>{
  Transaction t;
  _TransactionDetailViewState(this.t);
  @override
  Widget build(BuildContext context) =>new TransactionDetail().viewDetail(t,context);
}

class TransactionDetail{

   Map<String, String> transactionMap = new Map();
   Transaction tran;
   BuildContext context;

   TableRow _genericTextField(dynamic initValue, String valueTitle){
    Text title = Text(Format.titleFormat(valueTitle));
    TextFormField textInput = TextFormField(
      initialValue: Format.dynamicFormating(initValue),
      validator:(value){
        if(value.isEmpty) return 'Must fill this in';
        if(!InputValidator.dynamicValidation(initValue.runtimeType, value)) return 'Please put in correct format';
        transactionMap[valueTitle] = value;
        return null;
      },
    );
    return TableRow(children: [title,textInput]);
  }

   TableRow _genericTextBox(dynamic value, String valueTitle){
    Text title = Text(Format.titleFormat(valueTitle));
    Text valueString =Text(Format.dynamicFormating(value));
    return TableRow(
      children: [title, valueString],
    );
  }

   Transaction mapToTrans() {

     return new Transaction.withTime(transactionMap['vendor'], transactionMap['method'],
         double.tryParse(transactionMap['amount']), Category.categoryFromString(transactionMap['category']), tran.time);
   }

   _onpressToEdit(){
     Navigator.push(context, MaterialPageRoute(
       builder: (BuildContext context) {
        return  new TransactionDetailEdit(tran);
       }
     ));
  }

   _onpressToSubmit(){
     Transaction t = mapToTrans();
     TransactionList tl = BudgetingApp.userController.getLoadedTransactions();
     for(int i=0; i<tl.length; i++){
       if(tran.time == tl.getAt(i).time){
          BudgetingApp.userController.getLoadedTransactions().getIterable().removeAt(i);
          BudgetingApp.userController.getLoadedTransactions().getIterable().add(t);
       }
     }
     Navigator.push(context, MaterialPageRoute(
         builder: (BuildContext context) {
           return  new TransactionDetailView(t);
         }
     ));
  }

   RaisedButton _navButton(String name){
    Function onPress;
    switch(name){
      case 'submit':
        onPress = _onpressToSubmit();
        break;
      case 'edit':
        onPress = _onpressToEdit();
    }

    return RaisedButton(
      child: Text(name),
      onPressed: onPress,
    );
  }

  RaisedButton _returnToList(){
     return RaisedButton();
  }

   Scaffold editDetail(Transaction t,BuildContext context){
     this.tran = t;
     this.context = context;
    return Scaffold();
  }

   Scaffold viewDetail(Transaction t,BuildContext context){
    this.tran=t;
    this.context = context;
    return Scaffold();
  }

}