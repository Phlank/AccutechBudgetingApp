import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/priority.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class Category implements Serializable {
  final String name;
  final Priority priority;

  static const Category housing = Category("Housing", Priority.needs),
      utilities = Category("Utilities", Priority.needs),
      groceries = Category("Groceries", Priority.needs),
      savings = Category("Savings", Priority.savings),
      health = Category("Health", Priority.needs),
      transportation = Category("Transportation", Priority.needs),
      education = Category("Education", Priority.wants),
      entertainment = Category("Entertainment", Priority.wants),
      kids = Category("Kids", Priority.wants),
      pets = Category("Pets", Priority.wants),
      miscellaneous = Category("Miscellaneous", Priority.wants),
      income = Category("Income", Priority.income),
      uncategorized = Category("Uncategorized", Priority.other);

  static const List<Category> defaultCategories = [
    Category.housing,
    Category.utilities,
    Category.groceries,
    Category.savings,
    Category.health,
    Category.transportation,
    Category.education,
    Category.entertainment,
    Category.kids,
    Category.pets,
    Category.miscellaneous,
    Category.income,
    Category.uncategorized,
  ];

  const Category(this.name, this.priority);

  bool get isSpending {
    return (priority == Priority.needs ||
        priority == Priority.wants ||
        priority == Priority.other ||
        priority == Priority.required) && priority != Priority.income;
  }

  bool get isSaving {
    return priority == Priority.savings;
  }

  bool get isIncome {
    return priority == Priority.income;
  }

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

  /// The hash code for this object. => name.hashCode ^ priority.hashCode;

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(nameKey, name);
    serializer.addPair(priorityKey, priority);
    return serializer.serialize;
  }
}
