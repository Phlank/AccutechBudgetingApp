import 'package:budgetflow/model/data_types/priority.dart';
import 'package:budgetflow/view/widgets/priority_bar_chart/priority_chart_button.dart';
import 'package:flutter/cupertino.dart';

class PriorityChartRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: PriorityChartButton(priority: Priority.needs),
          flex: 1,
        ),
        Expanded(
          child: PriorityChartButton(priority: Priority.wants),
          flex: 1,
        ),
        Expanded(
          child: PriorityChartButton(priority: Priority.savings),
          flex: 1,
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
