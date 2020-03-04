import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class Priority implements Serializable {
  static const String _requiredName = 'Required',
      _needsName = 'Needs',
      _wantsName = 'Wants',
      _savingsName = 'Savings',
      _otherName = 'Other';

  final String name;
  final int value;

  static const required = Priority(_requiredName, 1);
  static const needs = Priority(_needsName, 2);
  static const wants = Priority(_wantsName, 3);
  static const savings = Priority(_savingsName, 4);
  static const other = Priority(_otherName, 5);

  const Priority(this.name, this.value);

  static Priority fromName(String name) {
    switch (name) {
      case _requiredName:
        return required;
      case _needsName:
        return needs;
      case _wantsName:
        return wants;
      case _savingsName:
        return savings;
      case _otherName:
        return other;
      default:
        return other;
    }
  }

  int compareTo(Priority other) {
    return value.compareTo(other.value);
  }

  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(nameKey, name);
    return serializer.serialize;
  }

  bool operator ==(Object o) => o is Priority && name == o.name;

  int get hashCode => name.hashCode ^ value.hashCode;
}
