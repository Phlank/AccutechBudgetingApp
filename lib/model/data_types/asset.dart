import 'package:budgetflow/model/abstract/serializable.dart';

class Asset implements Serializable {
  String type;
  String name;
  double value;

  String get serialize {
    // TODO implement this
    return '';
  }
}
