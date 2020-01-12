import 'package:budgetflow/budget/budget.dart';

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

const Map<BudgetCategory, String> jsonStrings = {
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