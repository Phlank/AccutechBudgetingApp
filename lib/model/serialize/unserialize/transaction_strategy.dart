import 'package:budgetflow/model/budget/transaction/transaction.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class TransactionStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    var time = DateTime.fromMillisecondsSinceEpoch(int.parse(value[timeKey]));
    var vendor = value[vendorKey];
    var method = value[methodKey];
    var amount = double.parse(value[amountKey]);
    var category = Serializer.unserialize(categoryKey, value[categoryKey]);
    var location = Serializer.unserialize(locationKey, value[locationKey]);
    return Transaction(
        time: time,
        vendor: vendor,
        method: method,
        amount: amount,
        category: category,
        location: location);
  }
}
