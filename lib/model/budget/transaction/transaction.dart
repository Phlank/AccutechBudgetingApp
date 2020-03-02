import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/location/location.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:flutter/widgets.dart';

class Transaction implements Serializable {
  final DateTime time;
  final String vendor;
  final String method;
  final double amount;
  final Category category;
  final Location location;

  static final empty = Transaction(
      vendor: "",
      method: "Cash",
      amount: 0.0,
      category: Category.uncategorized,
      time: DateTime.now());

  Transaction({@required this.vendor,
    @required this.method,
    @required this.amount,
    @required this.category,
    @required this.time,
    this.location = const Location(0.0, 0.0)});

  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(KEY_TIME, time.millisecondsSinceEpoch);
    serializer.addPair(KEY_VENDOR, vendor);
    serializer.addPair(KEY_METHOD, method);
    serializer.addPair(KEY_AMOUNT, amount);
    serializer.addPair(KEY_CATEGORY, category);
    serializer.addPair(KEY_LOCATION, location);
    return serializer.serialize;
  }
}
