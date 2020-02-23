import 'package:budgetflow/model/budget_control.dart';
import 'package:flutter/material.dart';

class SideMenu {
  FlatButton _sideBarFlatButton(
      String name, String route, BuildContext context) {
    return new FlatButton(
      child: Text(name),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
    );
  }

  Drawer sideMenu(BudgetControl userController) {
    return Drawer(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: userController.routeMap.keys.toList().length,
        itemBuilder: (BuildContext context, int index) {
          String name = userController.routeMap.keys.toList()[index];
          return _sideBarFlatButton(
              name, userController.routeMap[name], context);
        },
      ),
    );
  }
}
