import 'package:budgetflow/model/budget/category/priority.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class Category implements Serializable {

  static Map<String, Category> categoryMap = {
    'housing': Category.housing,
    'utilities': Category.utilities,
    'groceries': Category.groceries,
    'savings': Category.savings,
    'health': Category.health,
    'transportation': Category.transportation,
    'education': Category.education,
    'entertainment': Category.entertainment,
    'kids': Category.kids,
    'pets': Category.pets,
    'miscellaneous': Category.miscellaneous
  };
  final String name;
  final Priority priority;

  static const Category //
      housing = Category("Housing", Priority.need),
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
      income = Category("Income", Priority.other),
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
    Serializer serializer = Serializer();
    serializer.addPair(KEY_NAME, name);
    serializer.addPair(KEY_PRIORITY, priority);
    return serializer.serialize;
  }

  static void addCatagory(Category c){
    categoryMap.putIfAbsent(c.name, ()=>c);
  }

  static Category categoryFromString(String catString){
    return  categoryMap[catString];
  }
}
