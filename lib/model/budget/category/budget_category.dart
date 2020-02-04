import 'dart:convert';

class Category {
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
    output += '"name":"' + name + '",';
    output += '"priority":"' + priority.name + '"';
    output += '}';
    return output;
  }

  static Category unserialize(String serialized) {
    Map map = jsonDecode(serialized);
    return unserializeMap(map);
  }

  static Category unserializeMap(Map map) {
    return new Category(map['name'], Priority._new(map['priority']));
  }
}

class Priority {
  final String name;

  static const required = Priority._new("Required");
  static const need = Priority._new("Need");
  static const want = Priority._new("Want");
  static const savings = Priority._new("Savings");
  static const other = Priority._new("Other");

  static final Map<Priority, int> _valueOf = {
    required: 5,
    need: 4,
    want: 3,
    savings: 2,
    other: 1
  };

  const Priority._new(this.name);

  int compareTo(Priority other) {
    if (_valueOf[this] > _valueOf[other]) return 1;
    if (_valueOf[this] == _valueOf[other]) return 0;
    return -1;
  }
}

class CategoryList {
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
    Category.uncategorized
  ];

  List<Category> _categories;

  CategoryList({List<Category> list = defaultCategories}) {
    _categories = new List();
    list.forEach((category) {
      _categories.add(category);
    });
  }

  CategoryList.fromCategories(this._categories);

  int get length => _categories.length;

  bool contains(Category category) => _categories.contains(category);

  // Does not accept duplicates.
  bool add(Category category) {
    bool nameMatch = false;
    forEach((Category c) {
      if (c.name == category.name) {
        nameMatch = true;
      }
    });
    if (!nameMatch) {
      _categories.add(category);
      sort();
    }
    return !nameMatch;
  }

  void sort() {
    _categories.sort((Category a, Category b) {
      return a.compareTo(b);
    });
  }

  // Removes the specified category from the list if it is present.
  // Returns true if the element was found and deleted from the list, otherwise
  // returns false. If the specified category is the special category
  // 'BudgetCategory.uncategorized', it will not be removed and the function
  // will return false.
  bool remove(Category category) {
    if (contains(category) && category != Category.uncategorized) {
      _categories.remove(category);
      return true;
    }
    return false;
  }

  void forEach(void action(Category category)) {
    _categories.forEach(action);
  }

  Iterable<T> map<T>(T f(Category c)) => _categories.map(f);

  bool operator ==(Object o) => o is CategoryList && this._equals(o);

  bool _equals(CategoryList other) {
    if (this.length != other.length) return false;
    this.sort();
    other.sort();
    for (int i = 0; i < this.length; i++) {
      if (this._categories[i] != other._categories[i]) return false;
    }
    return true;
  }

  int get hashCode => _categories.hashCode;
}
