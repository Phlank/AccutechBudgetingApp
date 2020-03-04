import 'package:budgetflow/model/budget/category/category.dart';
import 'package:flutter/material.dart';

import '../budgeting_app.dart';

class DropDowns {
  DropdownButton categoryDrop(Category categoryValue, Function onChanged) {
    return DropdownButton<Category>(
      value: categoryValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      onChanged: onChanged,
      items: BudgetingApp.userController
          .getBudget()
          .allotted
          .keys
          .map<DropdownMenuItem<Category>>((Category category) {
        return DropdownMenuItem<Category>(
          value: category,
          child: Text(category.name),
        );
      }).toList(),
    );
  }

  DropdownButton methodDrop(String methodValue, Function onChange) {
    return DropdownButton<String>(
      value: methodValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      onChanged: onChange,
      items: <String>['Cash', 'Credit', 'Checking', 'Savings']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
