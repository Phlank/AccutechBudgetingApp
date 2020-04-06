import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/payment_method.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class MethodStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    if (value.containsKey(accountKey))
      return Serializer.unserialize(accountKey, value[accountKey]);
    else
      return PaymentMethod(value[methodNameKey]);
  }
}
