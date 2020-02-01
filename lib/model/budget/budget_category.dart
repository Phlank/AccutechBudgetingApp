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

  Priority._new(this.name);
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

  List<BudgetCategory> categories;

  BudgetCategoryList() {
    categories = new List();
    defaultCategories.forEach((category) {
      categories.add(category);
    });
  }

  BudgetCategoryList.fromCategories(this.categories);

  bool contains(BudgetCategory category) => categories.contains(category);

  bool addIfNotPresent(BudgetCategory category) {
    bool nameMatch = false;
    forEach((BudgetCategory c) {
      if (c.name == category.name) {
        nameMatch = true;
      }
    });
    if (!nameMatch) {
      categories.add(category);
    }
    return !nameMatch;
  }

  bool removeIfPresent(BudgetCategory category) {}

  void forEach(void action(BudgetCategory category)) {
    categories.forEach(action);
  }

  BudgetCategoryList get values {}
}
