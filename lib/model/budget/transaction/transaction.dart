import 'dart:convert';

import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/file_io/serializable.dart';

class Transaction implements Serializable {
  static const String _TIME_KEY = 'datetime',
      _VENDOR_KEY = 'vendor',
      _METHOD_KEY = 'method',
      _DELTA_KEY = 'delta',
      _CATEGORY_KEY = 'category';

  DateTime time;
  String vendor;
  String method;
  double delta;
  Category category;

  Transaction(this.vendor, this.method, this.delta, this.category) {
    time = DateTime.now();
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
    t.time = DateTime.fromMillisecondsSinceEpoch(int.parse(map[_TIME_KEY]));
    t.vendor = map[_VENDOR_KEY];
    t.method = map[_METHOD_KEY];
    t.delta = double.parse(map[_DELTA_KEY]);
    t.category = Category.unserializeMap(map[_CATEGORY_KEY]);
    return t;
  }

  String serialize() {
    String output = '{';
    output += '"$_TIME_KEY":"' + time.millisecondsSinceEpoch.toString() + '",';
    output += '"$_VENDOR_KEY":"' + vendor + '",';
    output += '"$_METHOD_KEY":"' + method + '",';
    output += '"$_DELTA_KEY":"' + delta.toString() + '",';
    output += '"$_CATEGORY_KEY":' + category.serialize();
    output += '}';
    return output;
  }
}
