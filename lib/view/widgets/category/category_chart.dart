import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/widgets/category/category_series.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class CategoryChart extends StatelessWidget {
  final Category category;
  double _allottedAmount, _actualAmount;
  CategorySeries _allottedSeries, _actualSeries;
  List<CategorySeries> data;

  CategoryChart({@required this.category}) {
    _allottedAmount =
        BudgetingApp.control.accountant.getAllottedCategory(category).abs();
    _actualAmount =
        BudgetingApp.control.accountant.getActualCategory(category).abs();
    _allottedSeries = _makeAllottedSeries();
    _actualSeries = _makeActualSeries();
    data = [_allottedSeries, _actualSeries];
  }

  CategorySeries _makeAllottedSeries() {
    String name = 'Allotted';
    double amount =
        BudgetingApp.control.accountant.getAllottedCategory(category).abs();
    charts.Color barColor = charts.ColorUtil.fromDartColor(Colors.blue);
    return CategorySeries(name: name, amount: amount, barColor: barColor);
  }

  CategorySeries _makeActualSeries() {
    String name = 'Actual';
    double amount =
        BudgetingApp.control.accountant.getActualCategory(category).abs();
    charts.Color barColor;
    if (_allottedAmount < _actualAmount) {
      barColor = charts.ColorUtil.fromDartColor(Colors.red);
    } else {
      barColor = charts.ColorUtil.fromDartColor(Colors.green);
    }
    return CategorySeries(name: name, amount: amount, barColor: barColor);
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<CategorySeries, String>> series = [
      charts.Series(
          id: category.name,
          data: data,
          domainFn: (CategorySeries series, _) => series.name,
          measureFn: (CategorySeries series, _) => series.amount,
          colorFn: (CategorySeries series, _) => series.barColor)
    ];
    return ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.8,
            minHeight: MediaQuery.of(context).size.height * 0.05,
            maxWidth: MediaQuery.of(context).size.width * 1,
            maxHeight: MediaQuery.of(context).size.height * 0.1),
        child: charts.BarChart(
          series,
          animate: true,
          vertical: false,
          primaryMeasureAxis:
              new charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
          domainAxis: charts.OrdinalAxisSpec(
            showAxisLine: true,
            renderSpec: charts.NoneRenderSpec(),
          ),
        ));
  }
}
