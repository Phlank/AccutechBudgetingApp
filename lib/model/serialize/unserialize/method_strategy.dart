import 'package:budgetflow/model/payment/payment_method.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class MethodStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    if (value.containsKey(accountKey))
      return Serializer.unserialize(accountKey, value[accountKey]);
    else
      return PaymentMethod(value[methodNameKey]);
  }
}
