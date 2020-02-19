import 'dart:convert';

import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class Priority implements Serializable {
  static const String NAME_REQUIRED = 'Required',
      NAME_NEED = 'Need',
      NAME_WANT = 'Want',
      NAME_SAVINGS = 'Savings',
      NAME_OTHER = 'Other';

  final String name;
  final int value;

  static const required = Priority(NAME_REQUIRED, 1);
  static const need = Priority(NAME_NEED, 2);
  static const want = Priority(NAME_WANT, 3);
  static const savings = Priority(NAME_SAVINGS, 4);
  static const other = Priority(NAME_OTHER, 5);

  const Priority(this.name, this.value);

  int compareTo(Priority other) {
    return value.compareTo(other.value);
  }

  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(KEY_NAME, name);
    return serializer.serialize;
  }

  static Priority unserialize(dynamic input) {
    if (input is String) input = jsonDecode(input);
    String inputName = input[KEY_NAME];
    switch (inputName) {
      case NAME_REQUIRED:
        return required;
      case NAME_NEED:
        return need;
      case NAME_WANT:
        return want;
      case NAME_SAVINGS:
        return savings;
      case NAME_OTHER:
        return other;
      default:
        return other;
    }
  }

  bool operator ==(Object o) => o is Priority && name == o.name;

  int get hashCode => name.hashCode ^ value.hashCode;
}
