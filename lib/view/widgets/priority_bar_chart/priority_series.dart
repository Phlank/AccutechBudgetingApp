import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class PrioritySeries {
  final String name;
  final double amount;
  final charts.Color barColor;

  PrioritySeries(
      {@required this.name, @required this.amount, @required this.barColor});
}
