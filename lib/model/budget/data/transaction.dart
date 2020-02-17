import 'dart:convert';

import 'package:budgetflow/model/budget/data/category.dart';
import 'package:budgetflow/model/budget/data/map_keys.dart';
import 'package:budgetflow/model/budget/data/serializer.dart';
import 'package:budgetflow/model/file_io/serializable.dart';

class Transaction implements Serializable {
  DateTime time;
  String vendor;
  String method;
  double amount;
  Category category;

  Transaction(this.vendor, this.method, this.amount, this.category) {
    time = DateTime.now();
  }

  Transaction.withTime(this.vendor, this.method, this.amount, this.category,
      this.time);

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
    t.time = DateTime.fromMillisecondsSinceEpoch(int.parse(map[KEY_TIME]));
    t.vendor = map[KEY_VENDOR];
    t.method = map[KEY_METHOD];
    t.amount = double.parse(map[KEY_AMOUNT]);
    t.category = Category.unserializeMap(map[KEY_CATEGORY]);
    return t;
  }

  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(KEY_TIME, time.millisecondsSinceEpoch);
    serializer.addPair(KEY_VENDOR, vendor);
    serializer.addPair(KEY_METHOD, method);
    serializer.addPair(KEY_AMOUNT, amount);
    serializer.addPair(KEY_CATEGORY, category);
    return serializer.serialize;
  }
}
