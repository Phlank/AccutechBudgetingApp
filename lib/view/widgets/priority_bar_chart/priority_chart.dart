import 'package:budgetflow/model/budget/category/priority.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/widgets/priority_bar_chart/priority_series.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PriorityChart extends StatelessWidget {
  final Priority priority;
  double _allottedAmount, _actualAmount;
  PrioritySeries _allottedSeries, _actualSeries;
  List<PrioritySeries> data;

  PriorityChart({@required this.priority}) {
    _allottedAmount =
        BudgetingApp.userController.getBudget().getAllottedPriority(priority);
    _actualAmount =
        BudgetingApp.userController.getBudget().getActualPriority(priority);
    _allottedSeries = _makeAllottedSeries();
    _actualSeries = _makeActualSeries();
    data = [_allottedSeries, _actualSeries];
  }

  PrioritySeries _makeAllottedSeries() {
    String name = 'Allotted';
    double amount =
        BudgetingApp.userController.getBudget().getAllottedPriority(priority);
    charts.Color barColor = charts.ColorUtil.fromDartColor(Colors.blue);
    return PrioritySeries(name: name, amount: amount, barColor: barColor);
  }

  PrioritySeries _makeActualSeries() {
    String name = 'Actual';
    double amount =
        BudgetingApp.userController.getBudget().getActualPriority(priority);
    charts.Color barColor;
    if (_allottedAmount < _actualAmount) {
      barColor = charts.ColorUtil.fromDartColor(Colors.red);
    } else {
      barColor = charts.ColorUtil.fromDartColor(Colors.green);
    }
    return PrioritySeries(name: name, amount: amount, barColor: barColor);
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<PrioritySeries, String>> series = [
      charts.Series(
          id: priority.name,
          data: data,
          domainFn: (PrioritySeries series, _) => series.name,
          measureFn: (PrioritySeries series, _) => series.amount,
          colorFn: (PrioritySeries series, _) => series.barColor)
    ];
    return ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.29,
            minHeight: MediaQuery.of(context).size.height * 0.3,
            maxWidth: MediaQuery.of(context).size.width * 0.29,
            maxHeight: MediaQuery.of(context).size.height * 0.3),
        child: charts.BarChart(
          series,
          animate: true,
          primaryMeasureAxis:
              new charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
          domainAxis: charts.OrdinalAxisSpec(
            showAxisLine: true,
            renderSpec: charts.NoneRenderSpec(),
          ),
        ));
  }
}
