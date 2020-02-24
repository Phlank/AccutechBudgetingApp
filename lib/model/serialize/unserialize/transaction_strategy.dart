import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class TransactionStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    var time = DateTime.fromMillisecondsSinceEpoch(int.parse(value[KEY_TIME]));
    var vendor = value[KEY_VENDOR];
    var method = value[KEY_METHOD];
    var amount = double.parse(value[KEY_AMOUNT]);
    var category = Serializer.unserialize(KEY_CATEGORY, value[KEY_CATEGORY]);
    var location;
    if (value.containsKey(KEY_LOCATION))
      location = Serializer.unserialize(KEY_LOCATION, value[KEY_LOCATION]);
    else location = null;
    return Transaction.withTime(vendor, method, amount, category, time, location);
  }
}
