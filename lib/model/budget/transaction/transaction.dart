import 'dart:convert';

import 'package:budgetflow/model/budget/budget_category.dart';
import 'package:budgetflow/model/file_io/serializable.dart';

class Transaction implements Serializable {
  DateTime datetime;
  String vendor;
  String method;
  double delta;
  BudgetCategory category;

  Transaction(
      String vendor, String method, double delta, BudgetCategory category) {
    datetime = DateTime.now();
    this.vendor = vendor;
    this.method = method;
    this.delta = delta;
    this.category = category;
  }

  static Transaction unserialize(String serialized) {
    Map map = jsonDecode(serialized);
    return unserializeMap(map);
  }

  static Transaction _emptyTransaction() {
    Transaction t = new Transaction("", "", 0.0, BudgetCategory.housing);
    return t;
  }

  static Transaction unserializeMap(Map map) {
    Transaction t = _emptyTransaction();
    t.datetime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(map["datetime"]));
    t.vendor = map["vendor"];
    t.method = map["method"];
    t.delta = double.parse(map["delta"]);
    t.category = jsonCategory[map["category"]];
    return t;
  }

  String serialize() {
    String output = '{';
    output +=
      '"datetime":"' + datetime.millisecondsSinceEpoch.toString() + '",';
    output += '"vendor":"' + vendor + '",';
    output += '"method":"' + method + '",';
    output += '"delta":"' + delta.toString() + '",';
    output += '"category":"' + categoryJson[category] + '"';
    output += '}';
    return output;
  }
}
