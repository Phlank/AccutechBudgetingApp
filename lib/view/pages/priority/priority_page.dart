import 'package:budgetflow/model/data_types/priority.dart';
import 'package:budgetflow/view/sidebar/user_category_displays.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:budgetflow/view/widgets/category/category_list_view.dart';
import 'package:flutter/material.dart';

class PriorityPage extends StatelessWidget {
  final Priority priority;

  PriorityPage(this.priority);

  @override
  Widget build(BuildContext context) {
    List<IconButton> actions;
    if (this.priority == Priority.savings) {
      actions = [
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(RouteUtil.routeWithSlideTransition(
                  GeneralCategory(priority.name)));
            }),
        IconButton(
          icon: Icon(Icons.plus_one),
          onPressed: () {
            print('plus');
          },
        ),
      ];
    } else {
      actions = [
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(RouteUtil.routeWithSlideTransition(
                  GeneralCategory(priority.name)));
            }),
      ];
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(priority.name),
          actions: actions,
        ),
        body: CategoryListView(priority));
  }
}
