import 'package:budgetflow/model/serialize/serializable.dart';

class Priority implements Serializable {
  static const String NAME_REQUIRED = 'Required',
      NAME_NEED = 'Need',
      NAME_WANT = 'Want',
      NAME_SAVINGS = 'Savings',
      NAME_OTHER = 'Other';

  final String name;

  static const required = Priority(NAME_REQUIRED);
  static const need = Priority(NAME_NEED);
  static const want = Priority(NAME_WANT);
  static const savings = Priority(NAME_SAVINGS);
  static const other = Priority(NAME_OTHER);

  static const List<Priority> DEFAULT_PRIORITIES = [
    required,
    need,
    want,
    savings,
    other
  ];

  static final Map<Priority, int> _valueOf = {
    required: 5,
    need: 4,
    want: 3,
    savings: 2,
    other: 1
  };

  const Priority(this.name);

  int compareTo(Priority other) {
    return _valueOf[this].compareTo(_valueOf[other]);
  }

  String get serialize {
    return name;
  }

  static Priority unserialize(String input) {
    if (input == NAME_REQUIRED) return required;
    if (input == NAME_NEED) return need;
    if (input == NAME_WANT) return want;
    if (input == NAME_SAVINGS) return savings;
    return other;
  }

  bool operator ==(Object o) => o is Priority && name == o.name;

  int get hashCode => name.hashCode;
}
