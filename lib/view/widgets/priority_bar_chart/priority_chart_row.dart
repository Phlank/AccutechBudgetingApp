import 'package:budgetflow/model/budget/category/priority.dart';
import 'package:budgetflow/view/widgets/priority_bar_chart/priority_chart_button.dart';
import 'package:flutter/cupertino.dart';

class PriorityChartRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: PriorityChartButton(priority: Priority.need), flex: 1,),
        Expanded(child: PriorityChartButton(priority: Priority.want), flex: 1,),
        Expanded(child: PriorityChartButton(priority: Priority.savings), flex: 1,),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

}