import 'package:budgetflow/model/payment/payment_method.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class MethodListStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    List<PaymentMethod> methods = [];
    value.forEach((key, subvalue) {
      methods.add(Serializer.unserialize(methodKey, subvalue));
    });
    return methods;
  }
}
