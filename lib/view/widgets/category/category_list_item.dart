import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/utils/output_formatter.dart';
import 'package:budgetflow/view/view_presets.dart';
import 'package:budgetflow/view/widgets/category/category_chart.dart';
import 'package:flutter/material.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;

  CategoryListItem(this.category);

  Widget _buildCategoryText(Category category) {
    return Text(
      category.name,
      textAlign: TextAlign.left,
      style: listItemTextStyle,
    );
  }

  Widget _buildCategoryRemainingAmount(Category category) {
    double remaining =
    BudgetingApp.control.accountant.getRemainingOfCategory(category);
    double allotted =
    BudgetingApp.control.accountant.getAllottedOfCategory(category);
    double actual =
    BudgetingApp.control.accountant.getActualOfCategory(category);
    String formattedRemaining = 'Remaining: ' + Format.dollarFormat(remaining);
    String formattedAllotted = 'Allotted: ' + Format.dollarFormat(allotted);
    String formattedSpending = 'Spending: ' + Format.dollarFormat(actual);
    Color color;
    if (remaining < 0)
      color = Colors.red;
    else
      color = Colors.green;
    return Text(
      formattedRemaining + '\n' + formattedAllotted + '\n' + formattedSpending,
      style: TextStyle(fontSize: 16, color: color),
      textAlign: TextAlign.right,
    );
  }

  Widget _buildCategoryBarGraph(Category category) {
    return CategoryChart(category: category);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(children: <Widget>[
          Expanded(child: _buildCategoryText(category)),
          Expanded(child: _buildCategoryRemainingAmount(category)),
        ]),
        _buildCategoryBarGraph(category)
      ],
    );
  }
}
