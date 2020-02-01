class BudgetCategory {
  String name;
  Priority priority;

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
    new BudgetCategory("Housing", Priority.required),
    new BudgetCategory("Utilities", Priority.need),
    new BudgetCategory("Groceries", Priority.need),
    new BudgetCategory("Savings", Priority.savings),
    new BudgetCategory("Health", Priority.need),
    new BudgetCategory("Transportation", Priority.need),
    new BudgetCategory("Education", Priority.want),
    new BudgetCategory("Entertainment", Priority.want),
    new BudgetCategory("Kids", Priority.want),
    new BudgetCategory("Pets", Priority.want),
    new BudgetCategory("Miscellaneous", Priority.want),
    new BudgetCategory("Uncategorized", Priority.other)
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

  bool removeIfPresent(BudgetCategory category) {

  }

  void forEach(void action(BudgetCategory category)) {
    categories.forEach(action);
  }

  BudgetCategoryList get values {
  }
}
