enum BudgetCategory {
  housing,
  utilities,
  groceries,
  savings,
  health,
  transportation,
  education,
  entertainment,
  kids,
  pets,
  miscellaneous
}

const Map<BudgetCategory, String> categoryJson = {
  BudgetCategory.housing: "Housing",
  BudgetCategory.utilities: "Utilities",
  BudgetCategory.groceries: "Groceries",
  BudgetCategory.savings: "Savings",
  BudgetCategory.health: "Health",
  BudgetCategory.transportation: "Transportation",
  BudgetCategory.education: "Education",
  BudgetCategory.entertainment: "Entertainment",
  BudgetCategory.kids: "Kids",
  BudgetCategory.pets: "Pets",
  BudgetCategory.miscellaneous: "Miscellaneous",
};

const Map<String, BudgetCategory> jsonCategory = {
  "Housing": BudgetCategory.housing,
  "Utilities": BudgetCategory.utilities,
  "Groceries": BudgetCategory.groceries,
  "Savings": BudgetCategory.savings,
  "Health": BudgetCategory.health,
  "Transportation": BudgetCategory.transportation,
  "Education": BudgetCategory.education,
  "Entertainment": BudgetCategory.entertainment,
  "Kids": BudgetCategory.kids,
  "Pets": BudgetCategory.pets,
  "Miscellaneous": BudgetCategory.miscellaneous,
};
