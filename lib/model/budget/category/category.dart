import 'dart:convert';

import 'priority.dart';

class Category {
  static const _NAME_KEY = 'name';
  static const _PRIORITY_KEY = 'priority';

  final String name;
  final Priority priority;

  static const Category //
      housing = Category("Housing", Priority.required),
      utilities = Category("Utilities", Priority.need),
      groceries = Category("Groceries", Priority.need),
      savings = Category("Savings", Priority.savings),
      health = Category("Health", Priority.need),
      transportation = Category("Transportation", Priority.need),
      education = Category("Education", Priority.want),
      entertainment = Category("Entertainment", Priority.want),
      kids = Category("Kids", Priority.want),
      pets = Category("Pets", Priority.want),
      miscellaneous = Category("Miscellaneous", Priority.want),
      uncategorized = Category("Uncategorized", Priority.other);

  const Category(this.name, this.priority);

  int compareTo(Category other) {
    if (this.priority.compareTo(other.priority) == 1) {
      return 1;
    } else if (this.priority.compareTo(other.priority) == 0) {
      return this.name.compareTo(other.name);
    } else {
      return -1;
    }
  }

  bool operator ==(Object other) => other is Category && this._equals(other);

  bool _equals(Category other) {
    return this.name == other.name && this.priority == other.priority;
  }

  int get hashCode => name.hashCode ^ priority.hashCode;

  String serialize() {
    String output = '{';
    output += '"$_NAME_KEY":"$name",';
    output += '"$_PRIORITY_KEY":"' + priority.name + '"';
    output += '}';
    return output;
  }

  static Category unserialize(String serialized) {
    Map map = jsonDecode(serialized);
    return unserializeMap(map);
  }

  static Category unserializeMap(Map map) {
    return new Category(map[_NAME_KEY], Priority(map[_PRIORITY_KEY]));
  }
}
