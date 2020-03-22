import 'category.dart';

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
    Category.income,
    Category.uncategorized,
  ];

  List<Category> _categories;

  CategoryList({List<Category> list = defaultCategories}) {
    _categories = new List();
    list.forEach((category) {
      _categories.add(category);
    });
  }

  CategoryList.fromCategories(this._categories);

  CategoryList.empty() {
    _categories = List();
  }

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
