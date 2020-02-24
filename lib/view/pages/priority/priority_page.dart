import 'package:budgetflow/model/budget/category/priority.dart';
import 'package:budgetflow/view/widgets/category/category_list_view.dart';
import 'package:flutter/material.dart';

class PriorityPage extends StatelessWidget {
  final Priority priority;

  PriorityPage(this.priority);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(priority.name),
        ),
        body: CategoryListView(priority));
  }
}
