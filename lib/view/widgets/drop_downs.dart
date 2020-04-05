import 'package:budgetflow/model/data_types/category.dart';
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
      items: BudgetingApp.control
          .getBudget()
          .allotted
          .map<DropdownMenuItem<Category>>((allocation) {
        return DropdownMenuItem<Category>(
          value: allocation.category,
          child: Text(allocation.category.name),
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
