import 'dart:convert';

import 'package:budgetflow/model/budget/data/map_keys.dart';
import 'package:budgetflow/model/budget/data/priority.dart';
import 'package:budgetflow/model/file_io/serializable.dart';

class Category implements Serializable {
  static const String MAP_KEY = 'category';
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

  String get serialize {
    String output = '{';
    output += '"$KEY_NAME":"' + name + '",';
    output += '"$KEY_PRIORITY":"' + priority.serialize + '"';
    output += '}';
    return output;
  }

  static Category unserialize(String serialized) {
    Map map = jsonDecode(serialized);
    return unserializeMap(map);
  }

  static Category unserializeMap(dynamic value) {
    if (value is Map) {
      return new Category(value[KEY_NAME], Priority(value[KEY_PRIORITY]));
    }
    return null;
  }
}
