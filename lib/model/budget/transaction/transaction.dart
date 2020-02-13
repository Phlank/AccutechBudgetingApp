import 'dart:convert';

import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/file_io/serializable.dart';

class Transaction implements Serializable {
  DateTime datetime;
  String vendor;
  String method;
  double delta;
  Category category;

  Transaction(this.vendor, this.method, this.delta, this.category) {
    datetime = DateTime.now();
  }

  Transaction.withTime(this.vendor, this.method, this.delta, this.category, this.datetime);

  static Transaction unserialize(String serialized) {
    Map map = jsonDecode(serialized);
    return unserializeMap(map);
  }

  static Transaction _emptyTransaction() {
    Transaction t = new Transaction("", "", 0.0, Category.housing);
    return t;
  }

  static Transaction unserializeMap(Map map) {
    Transaction t = _emptyTransaction();
    t.datetime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(map["datetime"]));
    t.vendor = map["vendor"];
    t.method = map["method"];
    t.delta = double.parse(map["delta"]);
    t.category = Category.unserializeMap(map["category"]);
    return t;
  }

  String serialize() {
    String output = '{';
    output +=
        '"datetime":"' + datetime.millisecondsSinceEpoch.toString() + '",';
    output += '"vendor":"' + vendor + '",';
    output += '"method":"' + method + '",';
    output += '"delta":"' + delta.toString() + '",';
    output += '"category":' + category.serialize();
    output += '}';
    return output;
  }
}
