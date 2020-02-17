import 'package:budgetflow/model/file_io/serializable.dart';

class Priority implements Serializable {
  final String name;

  static const required = Priority("Required");
  static const need = Priority("Need");
  static const want = Priority("Want");
  static const savings = Priority("Savings");
  static const other = Priority("Other");

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
    if (_valueOf[this] > _valueOf[other]) return 1;
    if (_valueOf[this] == _valueOf[other]) return 0;
    return -1;
  }

  String get serialize {
    return name;
  }

  bool operator ==(Object o) => o is Priority && name == o.name;

  int get hashCode => name.hashCode;
}
