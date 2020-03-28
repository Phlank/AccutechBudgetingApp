import 'package:budgetflow/model/budget/category/priority.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/priority/priority_page.dart';
import 'package:budgetflow/view/utils/output_formatter.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:budgetflow/view/widgets/priority_bar_chart/priority_chart.dart';
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
            Text('Balance: ' +
                Format.dollarFormat(BudgetingApp.control.accountant
                    .getRemainingPriority(priority)))
          ]),
          onTap: () {
            Navigator.of(context).push(
                RouteUtil.routeWithSlideTransition(PriorityPage(priority)));
          }),
    );
  }
}
