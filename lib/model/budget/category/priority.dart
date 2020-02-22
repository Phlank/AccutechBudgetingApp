import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class Priority implements Serializable {
  static const String _NAME_REQUIRED = 'Required',
      _NAME_NEED = 'Needs',
      _NAME_WANT = 'Wants',
      _NAME_SAVINGS = 'Savings',
      _NAME_OTHER = 'Other';

  final String name;
  final int value;

  static const required = Priority(_NAME_REQUIRED, 1);
  static const need = Priority(_NAME_NEED, 2);
  static const want = Priority(_NAME_WANT, 3);
  static const savings = Priority(_NAME_SAVINGS, 4);
  static const other = Priority(_NAME_OTHER, 5);

  const Priority(this.name, this.value);

  static Priority fromName(String name) {
    switch (name) {
      case _NAME_REQUIRED:
        return required;
      case _NAME_NEED:
        return need;
      case _NAME_WANT:
        return want;
      case _NAME_SAVINGS:
        return savings;
      case _NAME_OTHER:
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
    serializer.addPair(KEY_NAME, name);
    return serializer.serialize;
  }

  bool operator ==(Object o) => o is Priority && name == o.name;

  int get hashCode => name.hashCode ^ value.hashCode;
}
