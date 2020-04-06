import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/payment_method.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

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
