import 'package:budgetflow/model/budget/category/priority.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/utils/output_formatter.dart';
import 'package:budgetflow/view/global_widgets/priority_bar_chart/priority_chart.dart';
import 'package:flutter/material.dart';

class PriorityChartButton extends StatelessWidget {
  final Priority priority;

  PriorityChartButton({@required this.priority});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          child: Column(children: <Widget>[
            Text(priority.name, style: TextStyle(fontSize: 20)),
            PriorityChart(priority: priority),
            Text('Balance: ' + Format.dollarFormat(BudgetingApp.userController.getBudget().getRemainingPriority(priority)))
          ]),
          onTap: () {
            Navigator.pushNamed(context, '/' + priority.name);
          }),
    );
  }
}
