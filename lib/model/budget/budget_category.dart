class BudgetCategory {
  String name;
  Priority priority;

  static final BudgetCategory //
  housing = new BudgetCategory("Housing", Priority.required),
      utilities = new BudgetCategory("Housing", Priority.required),
      groceries = new BudgetCategory("Housing", Priority.required),
      savings = new BudgetCategory("Housing", Priority.required),
      health = new BudgetCategory("Housing", Priority.required),
      transportation = new BudgetCategory("Housing", Priority.required),
      education = new BudgetCategory("Housing", Priority.required),
      entertainment = new BudgetCategory("Housing", Priority.required),
      kids = new BudgetCategory("Housing", Priority.required),
      pets = new BudgetCategory("Housing", Priority.required),
      miscellaneous = new BudgetCategory("Housing", Priority.required),
      uncategorized = new BudgetCategory("Housing", Priority.required);

  BudgetCategory(this.name, this.priority);

  int _compareTo(BudgetCategory other) {
    if (this.priority._compareTo(other.priority) == 1) {
      return 1;
    } else if (this.priority._compareTo(other.priority) == 0) {
      return this.name.compareTo(other.name);
    } else {
      return -1;
    }
  }

  bool operator ==(Object other) =>
      other is BudgetCategory && this._equals(other);

  bool _equals(BudgetCategory other) {
    return this.name == other.name && this.priority == other.priority;
  }

  int hashCode() => name.hashCode ^ priority.hashCode;
}

class Priority {
  String name;

  static final required = Priority._new("Required");
  static final need = Priority._new("Need");
  static final want = Priority._new("Want");
  static final savings = Priority._new("Savings");
  static final other = Priority._new("Other");

  static final Map<Priority, int> _valueOf = {
    required: 5,
    need: 4,
    want: 3,
    savings: 2,
    other: 1
  };

  Priority._new(this.name);

  int _compareTo(Priority other) {
    if (_valueOf[this] > _valueOf[other]) return 1;
    if (_valueOf[this] == _valueOf[other]) return 0;
    return -1;
  }
}

class BudgetCategoryList {
  static final List<BudgetCategory> defaultCategories = [
    BudgetCategory.housing,
    BudgetCategory.utilities,
    BudgetCategory.groceries,
    BudgetCategory.savings,
    BudgetCategory.health,
    BudgetCategory.transportation,
    BudgetCategory.education,
    BudgetCategory.entertainment,
    BudgetCategory.kids,
    BudgetCategory.pets,
    BudgetCategory.miscellaneous,
    BudgetCategory.uncategorized
  ];

  List<BudgetCategory> _categories;

  BudgetCategoryList() {
    _categories = new List();
    defaultCategories.forEach((category) {
      _categories.add(category);
    });
  }

  BudgetCategoryList.fromCategories(this._categories);

  bool contains(BudgetCategory category) => _categories.contains(category);

  // Does not accept duplicates.
  bool add(BudgetCategory category) {
    bool nameMatch = false;
    forEach((BudgetCategory c) {
      if (c.name == category.name) {
        nameMatch = true;
      }
    });
    if (!nameMatch) {
      _categories.add(category);
      _sort();
    }
    return !nameMatch;
  }

  void _sort() {
    _categories.sort((BudgetCategory a, BudgetCategory b) {
      return a._compareTo(b);
    });
  }

  // Removes the specified category from the list if it is present.
  // Returns true if the element was found and deleted from the list, otherwise
  // returns false. If the specified category is the special category
  // 'BudgetCategory.uncategorized', it will not be removed and the function
  // will return false.
  bool remove(BudgetCategory category) {
    if (contains(category) && category != BudgetCategory.uncategorized) {
      _categories.remove(category);
      return true;
    }
    return false;
  }

  void forEach(void action(BudgetCategory category)) {
    _categories.forEach(action);
  }
}
