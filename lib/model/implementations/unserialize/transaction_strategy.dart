import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class TransactionStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    var time = DateTime.tryParse(value[timeKey]);
    var vendor = value[vendorKey];
    var method = Serializer.unserialize(methodKey, value[methodKey]);
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
