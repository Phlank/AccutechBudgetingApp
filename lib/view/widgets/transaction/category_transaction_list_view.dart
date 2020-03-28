import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/transaction/transaction_list.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/widgets/transaction/transaction_list_view.dart';
import 'package:flutter/material.dart';

class CategoryTransactionListView extends StatelessWidget {
  final Category category;

  CategoryTransactionListView(this.category);

  @override
  Widget build(BuildContext context) {
    TransactionList transactions =
        BudgetingApp.control.getTransactionsInCategory(category);
    TransactionListView view = TransactionListView(transactions);
    return view;
  }
}
