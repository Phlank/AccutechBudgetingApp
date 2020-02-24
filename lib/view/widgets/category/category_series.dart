import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class CategorySeries {
  final String name;
  final double amount;
  final charts.Color barColor;

  CategorySeries(
      {@required this.name, @required this.amount, @required this.barColor});
}
