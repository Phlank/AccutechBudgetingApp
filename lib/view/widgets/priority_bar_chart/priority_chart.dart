import 'dart:math';

import 'package:budgetflow/model/budget/category/priority.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/widgets/priority_bar_chart/priority_series.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PriorityChart extends StatelessWidget {
  final Priority priority;

  PriorityChart({@required this.priority});

  PrioritySeries _makeAllottedSeries() {
    String name = 'Allotted';
    double amount =
    BudgetingApp.control.accountant.getAllottedPriority(priority);
    charts.Color barColor = charts.ColorUtil.fromDartColor(Colors.blue);
    return PrioritySeries(name: name, amount: amount, barColor: barColor);
  }

  PrioritySeries _makeActualSeries() {
    double allotted =
    BudgetingApp.control.accountant.getAllottedPriority(priority);
    double actual =
    BudgetingApp.control.accountant.getActualPriority(priority);
    String name = 'Actual';
    charts.Color barColor;
    if (allotted < actual) {
      barColor = charts.ColorUtil.fromDartColor(Colors.red);
    } else {
      barColor = charts.ColorUtil.fromDartColor(Colors.green);
    }
    return PrioritySeries(name: name, amount: actual, barColor: barColor);
  }

  @override
  Widget build(BuildContext context) {
    PrioritySeries _allottedSeries, _actualSeries;
    _allottedSeries = _makeAllottedSeries();
    _actualSeries = _makeActualSeries();
    final data = [_allottedSeries, _actualSeries];
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
          minWidth: MediaQuery
              .of(context)
              .size
              .width * 0.29,
          minHeight: MediaQuery
              .of(context)
              .size
              .height * 0.3,
          maxWidth: MediaQuery
              .of(context)
              .size
              .width * 0.29,
          maxHeight: MediaQuery
              .of(context)
              .size
              .height * 0.3),
      child: charts.BarChart(
        series,
        animate: true,
        primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: charts.NoneRenderSpec(),
          viewport: new charts.NumericExtents(
            0,
            max(_allottedSeries.amount, _actualSeries.amount),
          ),
        ),
        domainAxis: charts.OrdinalAxisSpec(
          showAxisLine: true,
          renderSpec: charts.NoneRenderSpec(),
        ),
      ),
    );
  }
}
