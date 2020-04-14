import 'package:budgetflow/model/data_types/priority.dart';
import 'package:budgetflow/view/sidebar/user_category_displays.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:budgetflow/view/widgets/category/category_list_view.dart';
import 'package:flutter/material.dart';

class PriorityPage extends StatelessWidget {
  final Priority priority;
  List <IconButton> actions = [];

  PriorityPage(this.priority);

  @override
  Widget build(BuildContext context){

  if(this.priority == Priority.savings){
    this.actions =  [
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(RouteUtil.routeWithSlideTransition(
          GeneralCategory(priority.name)));
        }),
      IconButton(
        icon: Icon(Icons.plus_one),
        onPressed: (){
          print('plus');
        },
      ),
    ];
  } else{
    this.actions =  [
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
          actions: this.actions,
        ),
        body: CategoryListView(priority));
  }
}
