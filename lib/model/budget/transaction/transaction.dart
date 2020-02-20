import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

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
