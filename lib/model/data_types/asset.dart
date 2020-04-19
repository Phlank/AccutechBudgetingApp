import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class Asset implements Serializable {
  String type;
  String name;
  double value;

  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(typeKey, type);
    serializer.addPair(nameKey, name);
    serializer.addPair(valueKey, value);
    return serializer.serialize;
  }
}
