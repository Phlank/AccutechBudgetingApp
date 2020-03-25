import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class PaymentMethod implements Serializable {
  static final String cashName = 'Cash';

  String methodName;

  static final cash = PaymentMethod(cashName);

  PaymentMethod(this.methodName);

  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(methodNameKey, methodName);
    return serializer.serialize;
  }
}
