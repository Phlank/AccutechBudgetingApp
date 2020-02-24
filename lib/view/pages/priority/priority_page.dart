import 'package:budgetflow/model/budget/category/priority.dart';
import 'package:budgetflow/view/sidebar/user_catagory_displays.dart';
import 'package:budgetflow/view/utils/routes.dart';
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
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(RouteUtil.routeWithSlideTransition(
                      GeneralCategory(priority.name)));
                })
          ],
        ),
        body: CategoryListView(priority));
  }
}
