import 'package:budgetflow/model/data_types/priority.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/widgets/category/category_list_item_button.dart';
import 'package:flutter/material.dart';

class CategoryListView extends StatelessWidget {
  final Priority priority;

  CategoryListView(this.priority);

  @override
  Widget build(BuildContext context) {
    List<Widget> categories = List();
    BudgetingApp.control
        .getBudget()
        .getCategoriesOfPriority(priority)
        .forEach((category) {
      categories.add(CategoryListItemButton(category));
    });
    return ListView(
      children: categories,
      padding: EdgeInsets.all(24),
    );
  }
}
