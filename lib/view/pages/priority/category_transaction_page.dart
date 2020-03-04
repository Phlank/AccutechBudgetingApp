import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/view/widgets/transaction/category_transaction_list_view.dart';
import 'package:flutter/material.dart';

class CategoryTransactionPage extends StatelessWidget {
  final Category category;

  CategoryTransactionPage(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions in ' + category.name),
      ),
      body: CategoryTransactionListView(category),
    );
  }
}
